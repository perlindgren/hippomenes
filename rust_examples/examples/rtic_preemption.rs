#![no_std]
#![no_main]
use core::panic::PanicInfo;
use hippomenes_rt as _;

#[rtic::app(device = hippomenes_core)]
mod app {
    use core::fmt::Write;
    use hippomenes_core::{UART, Interrupt};
    #[shared]
    struct Shared {
        uart: UART,
    }

    #[local]
    struct Local {}

    #[init]
    fn init(cx: init::Context) -> (Shared, Local) {
        let peripherals = cx.device;
        let timer = peripherals.timer;
        let mut uart = peripherals.uart;
        write!(uart, "init").ok();
        timer.write(0x100F); //timer interrupt every
                             // 500*2^15 ~ 16M cycles ~0.75s @ 20MHz
        (Shared { uart }, Local { })
    }

    #[idle]
    fn idle(_: idle::Context) -> ! {
        loop {}
    }

    #[task(binds = Interrupt0, priority=1, shared=[uart])]
    fn some_task(mut cx: some_task::Context) {
        cx.shared.uart.lock(|uart| {
            write!(uart, "T1");
        });
        unsafe{hippomenes_core::Interrupt2::pend_int()};
        cx.shared.uart.lock(|uart|{
                write!(uart, "T2");
            }); 
    }

    #[task(binds = Interrupt2, priority = 2, shared = [uart])]
    fn sw_task(mut cx: sw_task::Context) {
        cx.shared.uart.lock(|uart|write!(uart, "SW"));
    }
}

#[panic_handler]
fn p(_: &PanicInfo) -> ! {
    loop {}
}
