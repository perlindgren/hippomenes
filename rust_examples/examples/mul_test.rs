#![no_std]
#![no_main]
use core::panic::PanicInfo;
use hippomenes_core::gpo::{Pout0, Pout1, Pout2, Pout3};
use hippomenes_rt as _;
// This bench semi-exhaustively tests the mul unit.
// EXPECTED BEHAVIOR:
// The LED blinks while the test is running.
// Once the test has finished (this can take a while)
// The LED stops blinking.
// If the tests fail, we panic, which turns on all of the LEDs.

#[rtic::app(device = hippomenes_core)]
mod app {
    use hippomenes_core::gpo::Pout1;
    #[shared]
    struct Shared {
        dummy: u8,
    }

    #[local]
    struct Local {}

    #[init]
    fn init(_: init::Context) -> (Shared, Local) {
        let mut led_state = true;
        Pout1::set();
        let mut res: u64 = 0;
        let res_ptr = &mut res;
        for x in (1..4294967295u64).step_by(99999) {
            for y in (1..4294967295u64).step_by(100000) {
                unsafe { core::ptr::write_volatile(res_ptr, x * y) };
                assert!(*res_ptr / y == x);
            }
            if led_state {
                Pout1::clear();
            } else {
                Pout1::set();
            }
            led_state = !led_state
        }
        Pout1::clear();
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
    Pout0::set();
    Pout1::set();
    Pout2::set();
    Pout3::set();
    loop {}
}
