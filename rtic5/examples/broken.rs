#![no_std]
#![no_main]
use hippomenes_rt::entry;
use hippomenes_core::Peripherals;
use core::fmt::Write;
use core::panic::PanicInfo;
#[entry]
fn main() -> ! {
    let mut uart = unsafe{Peripherals::steal()}.uart;
    write!(uart, "Hi!").ok();
    let v = 8;
    let c = unsafe{core::ptr::read_volatile(&v)};
    write!(uart, "Bye{}", c).ok();
    loop{}
}

#[panic_handler]
fn p(_:&PanicInfo) -> ! {
    loop {}
}

