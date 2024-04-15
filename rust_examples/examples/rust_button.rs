#![no_std]
#![no_main]

use core::panic::PanicInfo;
use hippomenes_core::Peripherals;
use hippomenes_core::{InputPin, OutputPin}; // traits

use hippomenes_rt::entry;
#[panic_handler]
fn panic(_info: &PanicInfo) -> ! {
    let p = unsafe { Peripherals::steal() };
    let led = p.gpo;

    loop {
        for _ in 0..1000_0000 {
            led.write(0);
        }
        for _ in 0..1000_0000 {
            led.write(0xf);
        }
    }
}

const DATA: [usize; 16] = [
    0x4142_4344,
    0x4546_4848,
    0x495A_5B5C,
    0x5D5E_5F60,
    0x4142_4344,
    0x4546_4848,
    0x495A_5B5C,
    0x5D5E_5F60,
    0x4142_4344,
    0x4546_4848,
    0x495A_5B5C,
    0x5D5E_5F60,
    0x4142_4344,
    0x4546_4848,
    0x495A_5B5C,
    0x5D5E_5F60,
];
#[entry]
fn main() -> ! {
    let p = unsafe { Peripherals::steal() };
    let led = p.gpo.split();
    let btn = p.gpi.split();
    let uart = p.uart;
    let mut counter: u32 = 0;
    let mut flag: bool = false;
    loop {
        counter += 1;

        if (counter >> 20) & 1 == 1 {
            if flag {
                uart.write(DATA[counter as usize % 16]);
                flag = false;
            }
            led.pout3.set_low()
        } else {
            flag = true;
            led.pout3.set_high()
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
