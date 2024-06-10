#![no_main]
#![no_std]

use core::panic::PanicInfo;

use hippomenes_rt::entry;
#[no_mangle]
#[inline(never)]
unsafe extern "C" fn one_one_x_one() {
    let ptr = 0x5000_0000 as *mut u32;
    let x = 0x0000_00AA;
    core::ptr::write_volatile(ptr, x);
}

#[entry]
fn entry() -> ! {
    unsafe {
        core::hint::black_box(one_one_x_one());
    }
    loop {}
}

#[panic_handler]
fn panic(_: &PanicInfo) -> ! {
    loop {}
}
