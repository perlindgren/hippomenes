#![no_std]
#![no_main]

use core::panic::PanicInfo;
use hippomenes_core::Peripherals;
// use hippomenes_hal::*;
// use hippomenes_rt as _;
use hippomenes_core::{InputPin, OutputPin}; // traits
                                            // use hippomenes_rt as _;
use hippomenes_rt::entry;
#[panic_handler]
fn panic(_info: &PanicInfo) -> ! {
    loop {}
}

#[entry]
fn main() -> ! {
    let p = unsafe { Peripherals::steal() };
    let led = p.gpo.split();
    let btn = p.gpi.split();
    let mut counter: u32 = 0;
    loop {
        counter += 1;
        if (counter >> 20) & 1 == 1 {
            led.pout3.set_high()
        } else {
            led.pout3.set_low()
        }

        if btn.pin0.is_high() {
            led.pout0.set_high();
        } else {
            led.pout0.set_low();
        }

        if btn.pin1.is_high() {
            led.pout1.set_high();
        } else {
            led.pout1.set_low();
        }

        if btn.pin2.is_high() {
            led.pout2.set_high();
        } else {
            led.pout2.set_low();
        }
    }
}
