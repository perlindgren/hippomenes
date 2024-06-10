#![no_std]
#![no_main]
use core::panic::PanicInfo;

use hippomenes_rt as _;

#[rtic::app(device = hippomenes_core, dispatchers = [Interrupt2, Interrupt3])]
mod app {
    use core::fmt::Write;
    use hippomenes_core::{OutputPin, UART};

    #[shared]
    struct Shared {
        resource: bool,
    }

    #[init]
    fn init() -> Shared {
        let peripherals = unsafe { hippomenes_core::Peripherals::steal() };
        let timer = peripherals.timer;
        let mut uart = peripherals.uart;
        write!(uart, "init").ok();
        timer.write(0x800F); //timer interrupt every
                             // 500*2^15 ~ 16M cycles ~0.75s @ 20MHz
        Shared { resource: true }
    }

    #[task(binds = Interrupt0, priority=2, shared=[resource])]
    struct TimerTask;

    impl RticTask for TimerTask {
        fn init() -> Self {
            Self
        }

        fn exec(&mut self) {
            Sw1::spawn(()).ok();
            Sw2::spawn(()).ok();
            self.shared().resource.lock(|_| {});
        }
    }

    #[sw_task(priority=1, shared=[resource])]
    struct Sw1;

    impl RticSwTask for Sw1 {
        type SpawnInput = ();

        fn init() -> Self {
            Self
        }

        fn exec(&mut self, _: ()) {
            unsafe { rtic::export::Peripherals::steal() }
                .gpo
                .split()
                .pout2
                .set_high();
            self.shared().resource.lock(|_| {});
        }
    }
    #[sw_task(priority = 3)]
    struct Sw2;

    impl RticSwTask for Sw2 {
        type SpawnInput = ();

        fn init() -> Self {
            Self
        }

        fn exec(&mut self, _: ()) {}
    }
}

#[panic_handler]
fn p(_: &PanicInfo) -> ! {
    loop {}
}
