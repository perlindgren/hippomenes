#![no_std]
#![no_main]
use core::panic::PanicInfo;
use hippomenes_rt as _;
use hippomenes_rt::entry;
#[rtic::app(device = hippomenes_core)]
mod app {
    use core::arch::asm;
    use hippomenes_core::{interrupt1, interrupt2, Pin, Pins};
    #[shared]
    struct Shared {
        r: u8,
        l: u8,
    }

    #[local]
    struct Local {
        pins: Pins,
    }

    #[init]
    fn init(cx: init::Context) -> (Shared, Local) {
        rtic::export::pend(interrupt1::Interrupt1);
        rtic::export::pend(interrupt2::Interrupt2);
        let p = cx.device;
        let pins = p.gpio.pins();
        let r = 5;
        let l = 2;
        (Shared { r, l }, Local { pins })
    }

    #[idle]
    fn idle(_: idle::Context) -> ! {
        loop {}
    }

    #[task(binds = Interrupt1, priority = 2, shared = [r,l])]
    fn i1(mut cx: i1::Context) {
        cx.shared.r.lock(|r| {
            cx.shared.l.lock(|l| {
                *l = *l * *r;
            });
        });
        for _ in 0..50_000 {
            unsafe { asm!("nop") };
        }
    }
    #[task(binds = Interrupt2, priority = 1, shared=[l,r], local=[pins])]
    fn i2(mut cx: i2::Context) {
        let val = cx.shared.l.lock(|l| *l);
        if val & 0b1 == 1 {
            cx.local.pins.pin0.set_high();
        } else {
            cx.local.pins.pin0.set_low();
        }
        if val & 0b10 == 0b10 {
            cx.local.pins.pin1.set_high();
        } else {
            cx.local.pins.pin1.set_low();
        }
        if val & 0b100 == 0b100 {
            cx.local.pins.pin2.set_high();
        } else {
            cx.local.pins.pin2.set_low();
        }
        if val & 0b1000 == 0b1000 {
            cx.local.pins.pin3.set_high();
        } else {
            cx.local.pins.pin3.set_low();
        }
        cx.shared.l.lock(|l| *l = 5);
        cx.shared.r.lock(|r| *r = 10);
    }
    #[task(binds = Interrupt3, priority = 3, shared = [r])]
    fn i3(mut cx: i3::Context) {
        cx.shared.r.lock(|r| {
            // *r += 1;
        });
    }
}

#[panic_handler]
fn panic(_: &PanicInfo) -> ! {
    loop {}
}
