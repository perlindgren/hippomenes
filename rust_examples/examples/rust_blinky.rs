#![no_std]
#![no_main]

use core::panic::PanicInfo;
use hippomenes_core::Peripherals;
// use hippomenes_hal::*;
// use hippomenes_rt as _;
use hippomenes_core::OutputPin; // trait
                                // use hippomenes_rt as _;
use hippomenes_rt::entry;
#[panic_handler]
fn panic(_info: &PanicInfo) -> ! {
    loop {}
}

#[entry]
fn main() -> ! {
    let p = unsafe { Peripherals::steal() };
    let led = p.gpo.split().pout0;
    loop {
        led.set_low();
        led.set_high();
    }
}
