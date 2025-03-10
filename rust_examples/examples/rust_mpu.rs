#![no_std]
#![no_main]

use core::panic::PanicInfo;
use hippomenes_core::Interrupt;
use hippomenes_core::Interrupt1 as interrupt_1;
use hippomenes_core::Peripherals;
use hippomenes_rt::entry;
#[panic_handler]
fn panic(_info: &PanicInfo) -> ! {
    loop {}
}

#[entry]
fn main() -> ! {
    // rodata region, preformatted strings are kept here
    hippomenes_core::mpu::MPUConfig::Region0Permissions::set(3);
    hippomenes_core::mpu::MPUConfig::Region0Address::set(0x5000_0000);
    hippomenes_core::mpu::MPUConfig::Region0Width::set(0x64);

    hippomenes_core::mpu::Interrupt1Config::Region0Permissions::set(3);
    hippomenes_core::mpu::Interrupt1Config::Region0Address::set(0x5000_0000);
    hippomenes_core::mpu::Interrupt1Config::Region0Width::set(0x3);

    hippomenes_core::mpu::Interrupt1Config::Region1Permissions::set(3);
    hippomenes_core::mpu::Interrupt1Config::Region1Address::set(*keystore as usize);
    hippomenes_core::mpu::Interrupt1Config::Region1Width::set(3);
    
    unsafe {
        interrupt_1::set_priority(1);
        interrupt_1::enable_int();
        interrupt_1::pend_int();
    }
    // enable global interrupts
    hippomenes_core::mstatus::MIE::set();
    loop {}
}
use core::fmt::Write;
#[allow(non_snake_case)]
#[no_mangle]
fn Interrupt1() {
    let key: u32 = unsafe { core::ptr::read_volatile(*keystore as *const _) };

    let key_2: u32 = unsafe { core::ptr::read_volatile(*keystore.byte_offset(4) as *const _) };
    let mut uart = unsafe { Peripherals::steal() }.uart;
    write!(uart, "Uart").ok();
}

#[no_mangle]
fn _memex() -> ! {
    let mut p = unsafe { Peripherals::steal() };
    write!(p.uart, "Memory Exception").ok();
    // disable interrupts
    hippomenes_core::mstatus::MIE::clear();
    // close frame by lowering priority threshold
    unsafe {
        hippomenes_core::mintthresh::Bits::write(1);
    }
    loop {}
}

#[allow(non_upper_case_globals)]
#[link_section = ".keystore"]
#[no_mangle]
pub static keystore: Keystore = Keystore {
    key_0: 0x12345678,
    key_1: 0x6B657931,
};

#[repr(C)]
#[derive(Copy, Clone)]
pub struct Keystore {
    key_0: u32,
    key_1: u32,
}

use core::ops::Deref;

impl Deref for Keystore {
    type Target = *const u32;

    fn deref(&self) -> &Self::Target {
        &(0x5000_2000 as *const _)
    }
}
