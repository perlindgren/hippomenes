#![no_std]
#![no_main]
use core::panic::PanicInfo;
use hippomenes_rt as _;

mod helpers {
    pub fn is_prime(n: u32) -> bool {
        // 0 and 1 are not prime
        if n < 2 {
            return false;
        };
        // Check if n is divisible by any positive integer less than itself (other than 1)
        for x in 2..n {
            if n % x == 0 {
                return false;
            }
        }
        // If not divisible by any number, n is prime
        true
    }
}

#[rtic::app(device = hippomenes_core)]
mod app {
    use crate::helpers::is_prime;
    use hippomenes_core::*;

    #[shared]
    struct Shared {
        dummy: u8,
    }

    #[local]
    struct Local {
        light: i32,
        pin0: Pout0,
        pin1: Pout1,
        pin2: Pout2,
        pin3: Pout3,
    }

    #[init]
    fn init(cx: init::Context) -> (Shared, Local) {
        let peripherals = cx.device;

        let pins = peripherals.gpo.split();
        let pin0 = pins.pout0;
        let pin1 = pins.pout1;
        let pin2 = pins.pout2;
        let pin3 = pins.pout3;

        let light = 0;
        let timer = peripherals.timer;

        timer.write(0b100000000001110); // interrupt every (1024 << 14) cycles, at 20Mhz yields
                                        // ~1.19Hz
                                        //timer.write(0b101110);

        (
            Shared { dummy: 0 },
            Local {
                light,
                pin0,
                pin1,
                pin2,
                pin3,
            },
        )
    }
    // This background task will toggle led3 every time it finds a new prime
    #[idle(local = [pin3])]
    fn idle(cx: idle::Context) -> ! {
        let mut n = 30000;
        let mut highest_prime_so_far;
        let mut blink = false;

        loop {
            if is_prime(n) {
                highest_prime_so_far = n;
                // Perform blink
                if blink && (highest_prime_so_far % 2 == 1) {
                    blink = false;
                    cx.local.pin3.set_low();
                } else {
                    blink = true;
                    cx.local.pin3.set_high();
                }
            }
            n += 1;
        }
    }

    // This interrupt task will switch between led0-2 in a cycle
    #[task(binds = Interrupt0, priority = 3, shared = [dummy], local = [light, pin0, pin1, pin2])]
    fn i0(cx: i0::Context) {
        // Turn off all lights
        cx.local.pin0.set_low();
        cx.local.pin1.set_low();
        cx.local.pin2.set_low();

        // Turn on the correct light
        if *cx.local.light == 0 {
            cx.local.pin0.set_high();
        } else if *cx.local.light == 1 {
            cx.local.pin1.set_high();
        } else if *cx.local.light == 2 {
            cx.local.pin2.set_high();
        }

        // Increment light to be turned on for next interrupt, mask everything but the lowest 3
        // bits
        *cx.local.light += 1;
        *cx.local.light &= !0x3;
    }
}

#[panic_handler]
fn panic(_: &PanicInfo) -> ! {
    loop {}
}
