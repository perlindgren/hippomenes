#![no_std]
#![no_main]
use core::panic::PanicInfo;
use hippomenes_rt as _;

#[rtic::app(device = hippomenes_core)]
mod app {
    use hippomenes_core::Interrupt0 as int0;
    use hippomenes_core::{Interrupt, Interrupt2, Pin, Pin0, Pin4, Timer};
    use hippomenes_hal::UART;
    #[shared]
    struct Shared {
        dummy: bool,
    }

    #[local]
    struct Local {
        pin: Pin0,
        timer: Timer,
        buffer: [u8; 8],
        start: bool,
        baud: usize,
        interval: usize,
        byte_ptr: usize,
        buffer_ptr: usize,
        buf_width: usize,
    }

    #[init]
    fn init(cx: init::Context) -> (Shared, Local) {
        let peripherals = cx.device;
        let pin = peripherals.gpio.pins().pin0;
        let timer = peripherals.timer;
        let buffer = [65, 66, 67, 68, 69, 70, 71, 72];
        let start = true;
        let baud = 20_000_000 / 119_200;
        let interval = 10_000;
        let byte_ptr = 0;
        let buffer_ptr = 0;
        let buf_width = 8;
        timer.counter_top().write(baud);
        (
            Shared { dummy: true },
            Local {
                pin,
                timer,
                buffer,
                start,
                baud,
                interval,
                byte_ptr,
                buffer_ptr,
                buf_width,
            },
        )
    }

    #[idle]
    fn idle(_: idle::Context) -> ! {
        loop {}
    }

    #[task(binds = Interrupt0, priority=3, shared=[dummy], local=[pin, timer, buffer, start, baud, interval, byte_ptr, buffer_ptr, buf_width])]
    fn uart_done(cx: uart_done::Context) {
        let pin = cx.local.pin;
        let timer = cx.local.timer;
        let baud = *cx.local.baud;
        let interval = *cx.local.interval;
        let buf_width = *cx.local.buf_width;
        if *cx.local.start {
            timer.counter_top().write(baud);
            pin.set_low(); //start bit
            *cx.local.start = false;
            return;
        }
        if *cx.local.byte_ptr == 8 {
            pin.set_high(); //stop bit
            *cx.local.start = true;
            if *cx.local.buffer_ptr < buf_width - 1 {
                *cx.local.buffer_ptr += 1;
                *cx.local.byte_ptr = 0;
                timer.counter_top().write(interval as usize);
                return;
            } else {
                *cx.local.buffer_ptr = 0;
                *cx.local.byte_ptr = 0;
                unsafe {
                    // int0::disable_int();
                    // Interrupt2::pend_int();
                }
                return;
            }
        } else {
            if ((cx.local.buffer[*cx.local.buffer_ptr] >> *cx.local.byte_ptr) & 0b1) == 1 {
                *cx.local.byte_ptr += 1;
                pin.set_high()
            } else {
                *cx.local.byte_ptr += 1;
                pin.set_low()
            }
        }
    }
}

#[panic_handler]
fn p(_: &PanicInfo) -> ! {
    loop {}
}
