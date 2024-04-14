#![feature(prelude_import)]
#![no_std]
#![no_main]
#[prelude_import]
use core::prelude::rust_2021::*;
#[macro_use]
extern crate core;
extern crate compiler_builtins as _;
use core::panic::PanicInfo;
use hippomenes_rt as _;
/// The RTIC application module
pub mod app {
    /// Always include the device crate which contains the vector table
    use hippomenes_core as you_must_enable_the_rt_feature_for_the_pac_in_your_cargo_toml;
    /// Holds the maximum priority level for use by async HAL drivers.
    #[no_mangle]
    static RTIC_ASYNC_MAX_LOGICAL_PRIO: u8 = 2u8;
    use hippomenes_core::*;
    /// User code end
    ///Shared resources
    struct Shared {
        dummy: u8,
    }
    ///Local resources
    struct Local {
        pin: Pin0,
        toggled: bool,
    }
    /// Execution context
    #[allow(non_snake_case)]
    #[allow(non_camel_case_types)]
    pub struct __rtic_internal_init_Context<'a> {
        #[doc(hidden)]
        __rtic_internal_p: ::core::marker::PhantomData<&'a ()>,
        /// Core peripherals
        pub core: rtic::export::Peripherals,
        /// Device peripherals (PAC)
        pub device: hippomenes_core::Peripherals,
        /// Critical section token for init
        pub cs: rtic::export::CriticalSection<'a>,
    }
    impl<'a> __rtic_internal_init_Context<'a> {
        #[inline(always)]
        #[allow(missing_docs)]
        pub unsafe fn new(core: rtic::export::Peripherals) -> Self {
            __rtic_internal_init_Context {
                __rtic_internal_p: ::core::marker::PhantomData,
                device: hippomenes_core::Peripherals::steal(),
                cs: rtic::export::CriticalSection::new(),
                core,
            }
        }
    }
    #[allow(non_snake_case)]
    ///Initialization function
    pub mod init {
        #[doc(inline)]
        pub use super::__rtic_internal_init_Context as Context;
    }
    #[inline(always)]
    #[allow(non_snake_case)]
    fn init(cx: init::Context) -> (Shared, Local) {
        let peripherals = cx.device;
        let pin = peripherals.gpio.pins().pin0;
        let toggled = false;
        let timer = peripherals.timer;
        pin.set_high();
        timer.write(0b100000000001110);
        (Shared { dummy: 0 }, Local { pin, toggled })
    }
    /// Execution context
    #[allow(non_snake_case)]
    #[allow(non_camel_case_types)]
    pub struct __rtic_internal_idle_Context<'a> {
        #[doc(hidden)]
        __rtic_internal_p: ::core::marker::PhantomData<&'a ()>,
    }
    impl<'a> __rtic_internal_idle_Context<'a> {
        #[inline(always)]
        #[allow(missing_docs)]
        pub unsafe fn new() -> Self {
            __rtic_internal_idle_Context {
                __rtic_internal_p: ::core::marker::PhantomData,
            }
        }
    }
    #[allow(non_snake_case)]
    ///Idle loop
    pub mod idle {
        #[doc(inline)]
        pub use super::__rtic_internal_idle_Context as Context;
    }
    #[allow(non_snake_case)]
    fn idle(_: idle::Context) -> ! {
        use rtic::Mutex as _;
        use rtic::mutex::prelude::*;
        loop {}
    }
    #[allow(non_snake_case)]
    #[no_mangle]
    unsafe fn Interrupt0() {
        const PRIORITY: u8 = 3u8;
        rtic::export::run(
            PRIORITY,
            || { i0(i0::Context::new(&rtic::export::Priority::new(PRIORITY))) },
        );
    }
    impl<'a> __rtic_internal_i0LocalResources<'a> {
        #[inline(always)]
        #[allow(missing_docs)]
        pub unsafe fn new() -> Self {
            __rtic_internal_i0LocalResources {
                pin: &mut *(&mut *__rtic_internal_local_resource_pin.get_mut())
                    .as_mut_ptr(),
                toggled: &mut *(&mut *__rtic_internal_local_resource_toggled.get_mut())
                    .as_mut_ptr(),
                __rtic_internal_marker: ::core::marker::PhantomData,
            }
        }
    }
    impl<'a> __rtic_internal_i0SharedResources<'a> {
        #[inline(always)]
        #[allow(missing_docs)]
        pub unsafe fn new(priority: &'a rtic::export::Priority) -> Self {
            __rtic_internal_i0SharedResources {
                dummy: shared_resources::dummy_that_needs_to_be_locked::new(priority),
                __rtic_internal_marker: core::marker::PhantomData,
                priority: priority,
            }
        }
    }
    #[allow(non_snake_case)]
    #[allow(non_camel_case_types)]
    ///Local resources `i0` has access to
    pub struct __rtic_internal_i0LocalResources<'a> {
        #[allow(missing_docs)]
        pub pin: &'a mut Pin0,
        #[allow(missing_docs)]
        pub toggled: &'a mut bool,
        #[doc(hidden)]
        pub __rtic_internal_marker: ::core::marker::PhantomData<&'a ()>,
    }
    #[allow(non_snake_case)]
    #[allow(non_camel_case_types)]
    ///Shared resources `i0` has access to
    pub struct __rtic_internal_i0SharedResources<'a> {
        #[allow(missing_docs)]
        pub dummy: shared_resources::dummy_that_needs_to_be_locked<'a>,
        #[doc(hidden)]
        pub __rtic_internal_marker: core::marker::PhantomData<&'a ()>,
        pub priority: &'a rtic::export::Priority,
    }
    /// Execution context
    #[allow(non_snake_case)]
    #[allow(non_camel_case_types)]
    pub struct __rtic_internal_i0_Context<'a> {
        #[doc(hidden)]
        __rtic_internal_p: ::core::marker::PhantomData<&'a ()>,
        /// Local Resources this task has access to
        pub local: i0::LocalResources<'a>,
        /// Shared Resources this task has access to
        pub shared: i0::SharedResources<'a>,
        pub priority: &'a rtic::export::Priority,
    }
    impl<'a> __rtic_internal_i0_Context<'a> {
        #[inline(always)]
        #[allow(missing_docs)]
        pub unsafe fn new(priority: &'a rtic::export::Priority) -> Self {
            __rtic_internal_i0_Context {
                __rtic_internal_p: ::core::marker::PhantomData,
                local: i0::LocalResources::new(),
                priority,
                shared: i0::SharedResources::new(priority),
            }
        }
    }
    #[allow(non_snake_case)]
    ///Hardware task
    pub mod i0 {
        #[doc(inline)]
        pub use super::__rtic_internal_i0LocalResources as LocalResources;
        #[doc(inline)]
        pub use super::__rtic_internal_i0SharedResources as SharedResources;
        #[doc(inline)]
        pub use super::__rtic_internal_i0_Context as Context;
    }
    #[allow(non_snake_case)]
    fn i0(cx: i0::Context) {
        use rtic::Mutex as _;
        use rtic::mutex::prelude::*;
        if *cx.local.toggled {
            cx.local.pin.set_low();
            *cx.local.toggled = false;
        } else {
            cx.local.pin.set_high();
            *cx.local.toggled = true;
        }
    }
    #[allow(non_camel_case_types)]
    #[allow(non_upper_case_globals)]
    #[doc(hidden)]
    #[link_section = ".uninit.rtic0"]
    static __rtic_internal_shared_resource_dummy: rtic::RacyCell<
        core::mem::MaybeUninit<u8>,
    > = rtic::RacyCell::new(core::mem::MaybeUninit::uninit());
    impl<'a> rtic::Mutex for shared_resources::dummy_that_needs_to_be_locked<'a> {
        type T = u8;
        #[inline(always)]
        fn lock<RTIC_INTERNAL_R>(
            &mut self,
            f: impl FnOnce(&mut u8) -> RTIC_INTERNAL_R,
        ) -> RTIC_INTERNAL_R {
            /// Priority ceiling
            const CEILING: u8 = 3u8;
            unsafe {
                rtic::export::lock(
                    __rtic_internal_shared_resource_dummy.get_mut() as *mut _,
                    self.priority,
                    CEILING,
                    f,
                )
            }
        }
    }
    mod shared_resources {
        #[doc(hidden)]
        #[allow(non_camel_case_types)]
        pub struct dummy_that_needs_to_be_locked<'a> {
            __rtic_internal_p: ::core::marker::PhantomData<&'a ()>,
            pub priority: &'a rtic::export::Priority,
        }
        impl<'a> dummy_that_needs_to_be_locked<'a> {
            #[inline(always)]
            pub unsafe fn new(priority: &'a rtic::export::Priority) -> Self {
                dummy_that_needs_to_be_locked {
                    __rtic_internal_p: ::core::marker::PhantomData,
                    priority,
                }
            }
        }
    }
    #[allow(non_camel_case_types)]
    #[allow(non_upper_case_globals)]
    #[doc(hidden)]
    #[link_section = ".uninit.rtic1"]
    static __rtic_internal_local_resource_pin: rtic::RacyCell<
        core::mem::MaybeUninit<Pin0>,
    > = rtic::RacyCell::new(core::mem::MaybeUninit::uninit());
    #[allow(non_camel_case_types)]
    #[allow(non_upper_case_globals)]
    #[doc(hidden)]
    #[link_section = ".uninit.rtic2"]
    static __rtic_internal_local_resource_toggled: rtic::RacyCell<
        core::mem::MaybeUninit<bool>,
    > = rtic::RacyCell::new(core::mem::MaybeUninit::uninit());
    #[doc(hidden)]
    #[no_mangle]
    unsafe extern "C" fn main() -> ! {
        rtic::export::assert_send::<u8>();
        rtic::export::interrupt::disable();
        let mut core: rtic::export::Peripherals = rtic::export::Peripherals::steal()
            .into();
        const _: () = if (15usize) <= 3u8 as usize {
            {
                ::core::panicking::panic_fmt(
                    format_args!(
                        "Maximum priority used by interrupt vector \'Interrupt0\' is more than supported by hardware",
                    ),
                );
            };
        };
        rtic::export::enable(
            you_must_enable_the_rt_feature_for_the_pac_in_your_cargo_toml::Interrupt0,
            3u8,
        );
        #[inline(never)]
        fn __rtic_init_resources<F>(f: F)
        where
            F: FnOnce(),
        {
            f();
        }
        __rtic_init_resources(|| {
            let (shared_resources, local_resources) = init(
                init::Context::new(core.into()),
            );
            __rtic_internal_shared_resource_dummy
                .get_mut()
                .write(core::mem::MaybeUninit::new(shared_resources.dummy));
            __rtic_internal_local_resource_pin
                .get_mut()
                .write(core::mem::MaybeUninit::new(local_resources.pin));
            __rtic_internal_local_resource_toggled
                .get_mut()
                .write(core::mem::MaybeUninit::new(local_resources.toggled));
            rtic::export::interrupt::enable();
        });
        idle(idle::Context::new())
    }
}
#[panic_handler]
fn panic(_: &PanicInfo) -> ! {
    loop {}
}
