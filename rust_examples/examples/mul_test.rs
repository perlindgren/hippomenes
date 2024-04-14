#![no_std]
#![no_main]
use core::panic::PanicInfo;
use hippomenes_core::gpio::{Pin0, Pin1, Pin2, Pin3};
use hippomenes_rt as _;
#[rtic::app(device = hippomenes_core)]
mod app {
    use hippomenes_core::gpio::{Pin0, Pin1, Pin2, Pin3};
    #[shared]
    struct Shared {
        dummy: u8,
    }

    #[local]
    struct Local {}

    #[init]
    fn init(_: init::Context) -> (Shared, Local) {
        Pin0::set();
        let mut res: u64 = 0;
        let res_ptr = &mut res;
        for x in (1..4294967295u64).step_by(99999) {
            for y in (1..4294967295u64).step_by(100000) {
                unsafe { core::ptr::write_volatile(res_ptr, x * y) };
                assert!(*res_ptr / y == x);
            }
        }
        Pin1::set();
        (Shared { dummy: 0 }, Local {})
    }

    #[idle]
    fn idle(_: idle::Context) -> ! {
        loop {}
    }

    #[task(binds = Interrupt0, priority = 5, shared = [dummy])]
    fn i0(_: i0::Context) {}
}

#[panic_handler]
fn panic(_: &PanicInfo) -> ! {
    Pin0::set();
    Pin1::set();
    Pin2::set();
    Pin3::set();
    loop {}
}
