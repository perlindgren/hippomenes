#![no_std]
#![no_main]
use core::panic::PanicInfo;
use hippomenes_core::Peripherals;
use hippomenes_rt as _;
#[rtic::app(device = hippomenes_core)]
mod app {
    use core::fmt::Write;
    use hippomenes_core::*;
    #[shared]
    struct Shared {
        shared: bool,
    }

    #[local]
    struct Local {
        gpo: PinOut,
        toggled: bool,
        uart: UART,
    }

    #[init]
    fn init(cx: init::Context) -> (Shared, Local) {
        let peripherals = cx.device;
        let gpo = peripherals.gpo.split();
        let toggled = false;
        let timer = peripherals.timer;
        let mut uart = peripherals.uart;
        //pins.pin0.set_high();
        write!(uart, "init").ok();
        //pins.pin1.set_high();
        //pin.set_high();
        timer.write(0b100000000001110); // interrupt every (1024 << 15) cycles, at 20Mhz yields
                                        // ~1.19Hz
        (Shared { shared: true }, Local { gpo, toggled, uart })
    }

    #[idle]
    fn idle(_: idle::Context) -> ! {
        loop {}
    }

    #[task(binds = Interrupt0, priority = 2, shared = [shared], local = [gpo, toggled, uart])]
    fn i0(mut cx: i0::Context) {
        if *cx.local.toggled {
            cx.local.gpo.pout0.set_low();
            cx.local.gpo.pout1.set_low();
            cx.local.gpo.pout2.set_low();
            cx.local.gpo.pout3.set_low();
            *cx.local.toggled = false;
        } else {
            cx.local.gpo.pout0.set_high();
            cx.local.gpo.pout1.set_high();
            cx.local.gpo.pout2.set_high();
            cx.local.gpo.pout3.set_high();
            *cx.local.toggled = true;
        }
        cx.shared.shared.lock(|shared| *shared = !*shared)
    }

    #[task(binds = Interrupt1, priority = 3, shared = [shared])]
    fn i1(mut cx: i1::Context) {
        cx.shared.shared.lock(|shared| *shared = false);
    }
}

#[panic_handler]
fn panic(_: &PanicInfo) -> ! {
    use hippomenes_core::OutputPin;
    let p = unsafe { Peripherals::steal() };
    let pins = p.gpo.split();
    pins.pout0.set_high();
    pins.pout1.set_low();
    pins.pout2.set_low();
    pins.pout3.set_high();
    //pins.pin4.set_high();
    loop {}
}
