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
    let mut q: rtic::export::Queue<u8, 2> = rtic::export::Queue::new();
    q.enqueue(8).ok();
    let c = q.dequeue().unwrap();
    write!(uart, "Bye{}", c).ok();
    loop{}
}

#[panic_handler]
fn p(_:&PanicInfo) -> ! {
    loop {}
}

