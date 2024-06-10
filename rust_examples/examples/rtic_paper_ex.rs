#![no_std]
#![no_main]
use core::panic::PanicInfo;
use hippomenes_rt as _;

#[rtic::app(device = hippomenes_core)]
mod app {
    use core::fmt::Write;
    use hippomenes_core::UART;
    use hippomenes_core::{interrupt1, interrupt2};
    #[shared]
    struct Shared {
        resource: bool,
    }

    #[local]
    struct Local {}

    #[init]
    fn init(cx: init::Context) -> (Shared, Local) {
        let peripherals = cx.device;
        let timer = peripherals.timer;
        timer.write(0x800F); //timer interrupt every
                             // 800*2^15 cycles
        (Shared { resource: true }, Local {})
    }

    #[idle]
    fn idle(_: idle::Context) -> ! {
        loop {}
    }

    #[task(binds = Interrupt0, priority=2, shared=[resource])]
    fn timer_task(mut cx: timer_task::Context) {
        rtic::export::pend(interrupt1::Interrupt1);
        rtic::export::pend(interrupt2::Interrupt2);
        cx.shared.resource.lock(|_| {});
    }

    #[task(binds = Interrupt2, priority=3)]
    fn task_3(_: task_3::Context) {}

    #[task(binds = Interrupt1, priority=1, shared=[resource])]
    fn task_1(mut cx: task_1::Context) {
        cx.shared.resource.lock(|_| {});
    }
}

#[panic_handler]
fn p(_: &PanicInfo) -> ! {
    loop {}
}
