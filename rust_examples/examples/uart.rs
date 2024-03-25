#![no_std]
#![no_main]
use core::panic::PanicInfo;
use hippomenes_rt as _;

#[rtic::app(device = hippomenes_core)]
mod app {
    use hippomenes_core::{Pin, Pin0};
    use hippomenes_hal::UART;
    #[shared]
    struct Shared {
        dummy: bool,
    }

    #[local]
    struct Local {}

    #[init]
    fn init(cx: init::Context) -> (Shared, Local) {
        let peripherals = cx.device;
        let pin = peripherals.gpio.pins().pin0;
        let timer = peripherals.timer;
        let mut uart = UART::new(pin, timer, 200_000);
        let buf = [48, 49, 50, 51, 52, 53, 54, 55];
        uart.send(buf);
        (Shared { dummy: true }, Local {})
    }

    #[idle]
    fn idle(_: idle::Context) -> ! {
        loop {}
    }

    #[task(binds=Interrupt2, priority=2, shared=[dummy])]
    fn some_task(cx: some_task::Context) {}
}

#[panic_handler]
fn p(_: &PanicInfo) -> ! {
    loop {}
}
