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
        dummy: bool,
    }

    #[init]
    fn init() -> Shared {
        Shared { dummy: true }
    }

    #[task(binds = Interrupt0, deadline=1, shared=[dummy])]
    struct SomeTask {
        uart: UART,
    }

    impl RticTask for SomeTask {
        fn init() -> Self {
            let peripherals = unsafe { hippomenes_core::Peripherals::steal() };
            let timer = peripherals.timer;
            let mut uart = peripherals.uart;
            write!(uart, "init").ok();
            timer.write(0x200F); //timer interrupt every
                                 // 500*2^15 ~ 16M cycles ~0.75s @ 20MHz
            Self { uart }
        }

        fn exec(&mut self) {
            write!(self.uart, "A").ok();
            //self.uart.write_byte(0); // force sentinel, notice NOT end of packet
            write!(self.uart, "1").ok();
            write!(self.uart, "B").ok();
        }
    }
}

#[panic_handler]
fn p(_: &PanicInfo) -> ! {
    loop {}
}
