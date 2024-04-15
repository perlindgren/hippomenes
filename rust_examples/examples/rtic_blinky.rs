#![no_std]
#![no_main]
use core::panic::PanicInfo;
use hippomenes_core::{Peripherals, Pin};
use hippomenes_rt as _;
#[rtic::app(device = hippomenes_core)]
mod app {
    use core::fmt::Write;
    use hippomenes_core::*;
    #[shared]
    struct Shared {
        dummy: u8,
    }

    #[local]
    struct Local {
        pins: Pins,
        toggled: bool,
        uart: UART,
    }

    #[init]
    fn init(cx: init::Context) -> (Shared, Local) {
        let peripherals = cx.device;
        let pins = peripherals.gpio.pins();
        let toggled = false;
        let timer = peripherals.timer;
        let mut uart = peripherals.UART;
        pins.pin0.set_high();
        write!(uart, "init").ok();
        pins.pin1.set_high();
        //pin.set_high();
        timer.write(0b100000000001110); // interrupt every (1024 << 14) cycles, at 20Mhz yields
                                        // ~1.19Hz
        (
            Shared { dummy: 0 },
            Local {
                pins,
                toggled,
                uart,
            },
        )
    }

    #[idle]
    fn idle(_: idle::Context) -> ! {
        loop {}
    }

    #[task(binds = Interrupt0, priority = 3, shared = [dummy], local = [pins, toggled, uart])]
    fn i0(cx: i0::Context) {
        write!(*cx.local.uart, "hello :)").ok();
        if *cx.local.toggled {
            cx.local.pins.pin0.set_low();
            cx.local.pins.pin1.set_low();
            cx.local.pins.pin2.set_low();
            cx.local.pins.pin3.set_low();
            *cx.local.toggled = false;
        } else {
            cx.local.pins.pin0.set_high();
            cx.local.pins.pin1.set_high();
            cx.local.pins.pin2.set_high();
            cx.local.pins.pin3.set_high();
            *cx.local.toggled = true;
        }
    }
}

#[panic_handler]
fn panic(_: &PanicInfo) -> ! {
    let p = unsafe { Peripherals::steal() };
    let pins = p.gpio.pins();
    pins.pin0.set_high();
    pins.pin1.set_high();
    pins.pin4.set_high();
    loop {}
}
