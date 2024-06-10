#![no_std]
#![no_main]
use core::panic::PanicInfo;

use hippomenes_rt as _;

#[rtic::app(device = hippomenes_core, dispatchers = [Interrupt2])]
mod app {
    use core::fmt::Write;
    use hippomenes_core::{OutputPin, UART};

    #[shared]
    struct Shared {
        uart: UART,
    }

    #[init]
    fn init() -> Shared {
        let peripherals = unsafe { hippomenes_core::Peripherals::steal() };
        let timer = peripherals.timer;
        let mut uart = peripherals.uart;
        write!(uart, "init").ok();
        timer.write(0x800F); //timer interrupt every
                             // 500*2^15 ~ 16M cycles ~0.75s @ 20MHz
        Shared { uart }
    }

    #[task(binds = Interrupt0, priority=1, shared=[uart])]
    struct SomeTask;

    impl RticTask for SomeTask {
        fn init() -> Self {
            Self
        }

        fn exec(&mut self) {
            self.shared().uart.lock(|uart| {
                write!(uart, "T").ok();
                write!(uart, "1").ok();
            });

            Sw1::spawn(()).ok();

            self.shared().uart.lock(|uart| {
                write!(uart, "T").ok();
                write!(uart, "2").ok();
            });
        }
    }

    #[sw_task(priority=2, shared=[uart])]
    struct Sw1;

    impl RticSwTask for Sw1 {
        type SpawnInput = ();

        fn init() -> Self {
            Self
        }

        fn exec(&mut self, p: ()) {
            self.shared().uart.lock(|uart| {
                write!(uart, "SW").ok();
            });
            unsafe { rtic::export::Peripherals::steal() }
                .gpo
                .split()
                .pout2
                .set_high();
        }
    }
}

#[panic_handler]
fn p(_: &PanicInfo) -> ! {
    loop {}
}
