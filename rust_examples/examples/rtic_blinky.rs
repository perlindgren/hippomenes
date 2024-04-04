#![no_std]
#![no_main]
use core::panic::PanicInfo;
use hippomenes_rt as _;
#[rtic::app(device = hippomenes_core)]
mod app {
    use hippomenes_core::*;
    #[shared]
    struct Shared {
        dummy: u8,
    }

    #[local]
    struct Local {
        pin: Pin0,
        toggled: bool,
    }

    #[init]
    fn init(cx: init::Context) -> (Shared, Local) {
        let peripherals = cx.device;
        let pin = peripherals.gpio.pins().pin0;
        let toggled = false;
        let timer = peripherals.timer;
        //pin.set_high();
        timer.write(0b100000000001110); // interrupt every (1024 << 14) cycles, at 20Mhz yields
                                        // ~1.19Hz
        (Shared { dummy: 0 }, Local { pin, toggled })
    }

    #[idle]
    fn idle(_: idle::Context) -> ! {
        loop {}
    }

    #[task(binds = Interrupt0, priority = 3, shared = [dummy], local = [pin, toggled])]
    fn i0(cx: i0::Context) {
        if *cx.local.toggled {
            cx.local.pin.set_low();
            *cx.local.toggled = false;
        } else {
            cx.local.pin.set_high();
            *cx.local.toggled = true;
        }
    }
}

#[panic_handler]
fn panic(_: &PanicInfo) -> ! {
    loop {}
}
