#![no_std]
#![no_main]
use core::panic::PanicInfo;
use hippomenes_rt as _;
#[rtic::app(device = hippomenes_core)]
mod app {
    use hippomenes_core::*;
    #[shared]
    struct Shared {
        r: u8,
    }

    #[local]
    struct Local {}

    #[init]
    fn init(cx: init::Context) -> (Shared, Local) {
        let r = 2;
        rtic::export::pend(interrupt1::Interrupt1);
        rtic::export::pend(interrupt2::Interrupt2);
        (Shared { r }, Local {})
    }

    #[idle]
    fn idle(_: idle::Context) -> ! {
        loop {}
    }

    #[task(binds = Interrupt1, priority = 1, shared = [])]
    fn i1(mut cx: i1::Context) {}
    #[task(binds = Interrupt2, priority = 2, shared=[])]
    fn i2(mut cx: i2::Context) {}
}

#[panic_handler]
fn panic(_: &PanicInfo) -> ! {
    loop {}
}
