#![no_std]
#![no_main]
use core::panic::PanicInfo;

use hippomenes_rt as _;

#[rtic::app(device = hippomenes_core, dispatchers = [Interrupt1])]
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
        let uart = peripherals.uart;

        timer.write(0x400F); //timer interrupt every
                             // 500*2^15 ~ 16M cycles ~0.75s @ 20MHz
        Shared { uart }
    }

    // Tied to timer
    #[task(binds = Interrupt0, priority=1, shared=[uart])]
    struct SomeTask;

    impl RticTask for SomeTask {
        fn init() -> Self {
            Self
        }

        fn exec(&mut self) {
            Sw1::spawn(1).ok();
            Sw2::spawn(2).ok();

            self.shared().uart.lock(|uart| {
                write!(uart, "Sorry").ok();
            });
        }
    }

    #[sw_task(priority=2, shared=[uart])]
    struct Sw1;

    impl RticSwTask for Sw1 {
        type SpawnInput = u8;

        fn init() -> Self {
            Self
        }

        fn exec(&mut self, p: u8) {
            self.shared().uart.lock(|uart| {
                write!(uart, "Fin {}", p).ok();
            });
        }
    }

    #[sw_task(priority=2, shared=[uart])]
    struct Sw2;

    impl RticSwTask for Sw2 {
        type SpawnInput = u8;

        fn init() -> Self {
            Self
        }

        fn exec(&mut self, p: u8) {
            self.shared().uart.lock(|uart| {
                write!(uart, "Swe {}", p).ok();
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
