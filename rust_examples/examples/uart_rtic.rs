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

    #[local]
    struct Local {
        uart: UART,
    }

    #[init]
    fn init(cx: init::Context) -> (Shared, Local) {
        let peripherals = cx.device;
        let timer = peripherals.timer;
        let mut uart = peripherals.uart;
        write!(uart, "init").ok();
        timer.write(0x100F); //timer interrupt every
                             // 500*2^15 ~ 16M cycles ~0.75s @ 20MHz
        (Shared { dummy: true }, Local { uart })
    }

    #[idle]
    fn idle(_: idle::Context) -> ! {
        loop {}
    }

    #[task(binds = Interrupt0, priority=1, shared=[dummy], local=[uart])]
    fn some_task(cx: some_task::Context) {
        write!(cx.local.uart, "A").ok();
        cx.local.uart.write_byte(0); // force sentinel, notice NOT end of packet
        write!(cx.local.uart, "C").ok();
        // write!(cx.local.uart, "B").ok();
    }
}

#[panic_handler]
fn p(_: &PanicInfo) -> ! {
    loop {}
}
