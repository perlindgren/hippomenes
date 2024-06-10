#![no_std]
#![no_main]
use core::panic::PanicInfo;
use hippomenes_rt as _;

#[rtic::app(device = hippomenes_core)]
mod app {
    use core::fmt::Write;
    use hippomenes_core::UART;

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
        timer.write(0x400F); //timer interrupt every
                             // 500*2^15 ~ 16M cycles ~0.75s @ 20MHz
        Shared { uart }
    }

    #[task(binds = Interrupt0, priority=2)]
    struct Task1 {
        uart: UART,
    }

    impl RticTask for Task1 {
        fn init() -> Self {
            let peripherals = unsafe { hippomenes_core::Peripherals::steal() };
            let timer = peripherals.timer;
            let mut uart = peripherals.uart;
            write!(uart, "init").ok();
            timer.write(0x300F); //timer interrupt every
                                 // 500*2^15 ~ 16M cycles ~0.75s @ 20MHz
            Self { uart }
        }

        fn exec(&mut self) {
            write!(self.uart, "A").ok();

            rtic::export::pend(hippomenes_core::Interrupt1);

            write!(self.uart, "B").ok();
        }
    }

    #[task(binds = Interrupt1, priority=3)]
    struct Task2;

    impl RticTask for Task2 {
        fn init() -> Self {
            Self
        }

        fn exec(&mut self) {}
    }
}

#[panic_handler]
fn p(_: &PanicInfo) -> ! {
    loop {}
}
