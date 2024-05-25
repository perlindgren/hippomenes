#![no_std]
#![no_main]
use core::panic::PanicInfo;
use hippomenes_rt as _;


#[rtic::app(device = hippomenes_core)]
mod app {
    use core::fmt::Write;
    use hippomenes_core::UART;
    use core::arch::asm;

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

    #[task(binds = Interrupt0, priority=1, shared=[uart])]
    struct Task1;

    impl RticTask for Task1 {
        fn init() -> Self {
            Self
        }

        fn exec(&mut self) {
            let mut r: u32;
            unsafe{ asm!("csrrs {0}, 0xB40, x0", out(reg) r); }
            // csrr    t3, 0xB40               # read captured timestamp
            self.shared().uart.lock(|uart| {
                write!(uart, "time {}", r);
                // uart.write_byte(r);
                // uart.write_byte(41);

                // rtic::export::pend(hippomenes_core::Interrupt1);

                // uart.write_byte(102);
                // uart.write_byte(103);
            });
        }
    }

    #[task(binds = Interrupt1, priority=3, shared=[uart])]
    struct Task2;

    impl RticTask for Task2 {
        fn init() -> Self {
            Self
        }

        fn exec(&mut self) {
            self.shared().uart.lock(|uart| {
                uart.write_byte(10);
                uart.write_byte(0);
                rtic::export::pend(hippomenes_core::Interrupt2);
                uart.write_byte(11);
            });
        }
    }

    #[task(binds = Interrupt2, priority=2, shared=[uart])]
    struct Task3 {
        data: u8,
    }

    impl RticTask for Task3 {
        fn init() -> Self {
            Self { data: 0 }
        }

        fn exec(&mut self) {
            self.shared().uart.lock(|uart| {
                uart.write_byte(90);
                uart.write_byte(self.data);
                uart.write_byte(92);
            });
            self.data = (self.data + 1) % 10;
        }
    }
}

#[panic_handler]
fn p(_: &PanicInfo) -> ! {
    loop {}
}
