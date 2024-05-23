#![no_std]
#![no_main]

use core::panic::PanicInfo;
use hippomenes_rt as _;
pub mod app {
    /// ================================== user includes ====================================
    use core::fmt::Write;
    /// Include peripheral crate that defines the vector table
    use hippomenes_core as _;
    use hippomenes_core::UART;
    /// ==================================== rtic traits ====================================
    pub use rtic_traits::*;
    /// Module defining rtic traits
    mod rtic_traits {
        /// Trait for a hardware task
        pub trait RticTask {
            /// Task local variables initialization routine
            fn init() -> Self;
            /// Function to be bound to a HW Interrupt
            fn exec(&mut self);
        }
        /// Trait for an idle task
        pub trait RticIdleTask {
            /// Task local variables initialization routine
            fn init() -> Self;
            /// Function to be executing when no other task is running
            fn exec(&mut self) -> !;
        }
        pub trait RticMutex {
            type ResourceType;
            fn lock(&mut self, f: impl FnOnce(&mut Self::ResourceType));
        }
    }
    /// ================================== rtic functions ===================================
    /// critical section function
    #[inline]
    pub fn __rtic_interrupt_free<F, R>(f: F) -> R
    where
        F: FnOnce() -> R,
    {
        rtic::export::interrupt_disable();
        let r = f();
        unsafe {
            rtic::export::interrupt_enable();
        }
        r
    }
    /// ==================================== User code ======================================
    static mut __rtic_internal__Sw1__INPUTS: rtic::export::Queue<
        <Sw1 as RticSwTask>::SpawnInput,
        2,
    > = rtic::export::Queue::new();
    impl Sw1 {
        pub fn spawn(
            input: <Sw1 as RticSwTask>::SpawnInput,
        ) -> Result<(), <Sw1 as RticSwTask>::SpawnInput> {
            // let mut inputs_producer = unsafe { __rtic_internal__Sw1__INPUTS.split().0 };
            // let mut ready_producer = unsafe { __rtic_internal__Core0Prio1Tasks__RQ.split().0 };
            //__rtic_interrupt_free(|| -> Result<(), <Sw1 as RticSwTask>::SpawnInput> {
            // inputs_producer.enqueue(input)?;
            // unsafe { ready_producer.enqueue_unchecked(Core0Prio1Tasks::Sw1) };
            __rtic_sc_pend(hippomenes_core::Interrupt2);
            Ok(())
            // })
        }
    }
    /// Dispatchers of
    /// Core 0
    #[doc(hidden)]
    pub enum Core0Prio1Tasks {
        Sw1,
    }
    #[automatically_derived]
    impl ::core::clone::Clone for Core0Prio1Tasks {
        #[inline]
        fn clone(&self) -> Core0Prio1Tasks {
            *self
        }
    }
    #[automatically_derived]
    impl ::core::marker::Copy for Core0Prio1Tasks {}
    #[doc(hidden)]
    #[allow(non_upper_case_globals)]
    static mut __rtic_internal__Core0Prio1Tasks__RQ: rtic::export::Queue<Core0Prio1Tasks, 2usize> =
        rtic::export::Queue::new();
    /// RTIC Software task trait
    /// Trait for an idle task
    pub trait RticSwTask {
        type SpawnInput;
        /// Task local variables initialization routine
        fn init() -> Self;
        /// Function to be executing when the scheduled software task is dispatched
        fn exec(&mut self, input: Self::SpawnInput);
    }
    /// Core local interrupt pending
    #[doc(hidden)]
    #[inline]
    pub fn __rtic_sc_pend<T: rtic::export::Interrupt>(irq_nbr: T) {
        rtic::export::pend(irq_nbr);
    }
    /// ====================================
    /// CORE 0
    /// ====================================
    static mut SHARED: core::mem::MaybeUninit<Shared> = core::mem::MaybeUninit::uninit();
    struct Shared {
        uart: UART,
    }
    fn init() -> Shared {
        let peripherals = unsafe { hippomenes_core::Peripherals::steal() };
        let timer = peripherals.timer;
        let mut uart = peripherals.uart;
        uart.write_fmt(format_args!("init")).ok();
        timer.write(0x400F);
        Shared { uart }
    }
    static mut SOME_TASK: core::mem::MaybeUninit<SomeTask> = core::mem::MaybeUninit::uninit();
    struct SomeTask;
    impl RticTask for SomeTask {
        fn init() -> Self {
            Self
        }
        fn exec(&mut self) {
            self.shared().uart.lock(|uart| {
                uart.write_fmt(format_args!("T")).ok();
                uart.write_fmt(format_args!("1")).ok();
            });
            Sw1::spawn(()).ok();
            self.shared().uart.lock(|uart| {
                uart.write_fmt(format_args!("T")).ok();
                uart.write_fmt(format_args!("2")).ok();
            });
        }
    }
    impl SomeTask {
        pub const fn priority() -> u16 {
            2u16
        }
    }
    impl SomeTask {
        pub fn shared(&self) -> __some_task_shared_resources {
            const TASK_PRIORITY: u16 = 2u16;
            __some_task_shared_resources::new(TASK_PRIORITY)
        }
    }
    struct __some_task_shared_resources {
        pub uart: __uart_mutex,
    }
    impl __some_task_shared_resources {
        #[inline(always)]
        pub fn new(priority: u16) -> Self {
            Self {
                uart: __uart_mutex::new(priority),
            }
        }
    }
    impl SomeTask {
        const fn current_core() -> __rtic__internal__Core0 {
            unsafe { __rtic__internal__Core0::new() }
        }
    }
    static mut SW1: core::mem::MaybeUninit<Sw1> = core::mem::MaybeUninit::uninit();
    /// Software tasks of
    /// Core 0
    struct Sw1;
    impl RticSwTask for Sw1 {
        type SpawnInput = ();
        fn init() -> Self {
            Self
        }
        fn exec(&mut self, p: ()) {
            self.shared().uart.lock(|uart| {
                uart.write_fmt(format_args!("SW")).ok();
            });
        }
    }
    impl Sw1 {
        pub const fn priority() -> u16 {
            1u16
        }
    }
    impl Sw1 {
        pub fn shared(&self) -> __sw1_shared_resources {
            const TASK_PRIORITY: u16 = 1u16;
            __sw1_shared_resources::new(TASK_PRIORITY)
        }
    }
    struct __sw1_shared_resources {
        pub uart: __uart_mutex,
    }
    impl __sw1_shared_resources {
        #[inline(always)]
        pub fn new(priority: u16) -> Self {
            Self {
                uart: __uart_mutex::new(priority),
            }
        }
    }
    impl Sw1 {
        const fn current_core() -> __rtic__internal__Core0 {
            unsafe { __rtic__internal__Core0::new() }
        }
    }
    static mut CORE0_PRIORITY1_DISPATCHER: core::mem::MaybeUninit<Core0Priority1Dispatcher> =
        core::mem::MaybeUninit::uninit();
    #[doc(hidden)]
    pub struct Core0Priority1Dispatcher;
    impl RticTask for Core0Priority1Dispatcher {
        fn init() -> Self {
            Self
        }
        fn exec(&mut self) {
            unsafe {
                //     let mut ready_consumer = __rtic_internal__Core0Prio1Tasks__RQ.split().1;
                //     while let Some(task) = ready_consumer.dequeue() {
                //         match task {
                //             Core0Prio1Tasks::Sw1 => {
                //                 let mut input_consumer = __rtic_internal__Sw1__INPUTS.split().1;
                //                 let input = input_consumer.dequeue_unchecked();
                SW1.assume_init_mut().exec(());
                //             }
                //         }
                //     }
            }
        }
    }
    impl Core0Priority1Dispatcher {
        pub const fn priority() -> u16 {
            1u16
        }
    }
    impl Core0Priority1Dispatcher {
        const fn current_core() -> __rtic__internal__Core0 {
            unsafe { __rtic__internal__Core0::new() }
        }
    }
    #[allow(non_snake_case)]
    #[no_mangle]
    fn Interrupt0() {
        unsafe { SOME_TASK.assume_init_mut().exec() };
    }
    #[allow(non_snake_case)]
    #[no_mangle]
    fn Interrupt2() {
        unsafe { CORE0_PRIORITY1_DISPATCHER.assume_init_mut().exec() };
    }
    struct __uart_mutex {
        #[doc(hidden)]
        task_priority: u16,
    }
    impl __uart_mutex {
        #[inline(always)]
        pub fn new(task_priority: u16) -> Self {
            Self { task_priority }
        }
    }
    impl RticMutex for __uart_mutex {
        type ResourceType = UART;
        fn lock(&mut self, f: impl FnOnce(&mut Self::ResourceType)) {
            const CEILING: u16 = 2u16;
            let task_priority = self.task_priority;
            let resource_ptr = unsafe { &mut SHARED.assume_init_mut().uart } as *mut _;
            unsafe {
                rtic::export::lock(resource_ptr, task_priority as u8, CEILING as u8, f);
            }
        }
    }
    ///Unique type for core 0
    pub use core0_type_mod::__rtic__internal__Core0;
    mod core0_type_mod {
        struct __rtic__internal__Core0Inner;
        pub struct __rtic__internal__Core0(__rtic__internal__Core0Inner);
        impl __rtic__internal__Core0 {
            pub const unsafe fn new() -> Self {
                __rtic__internal__Core0(__rtic__internal__Core0Inner)
            }
        }
    }
    /// Entry of
    /// CORE 0
    #[no_mangle]
    pub fn main() -> ! {
        __rtic_interrupt_free(|| {
            unsafe {
                SOME_TASK.write(SomeTask::init());
                SW1.write(Sw1::init());
                CORE0_PRIORITY1_DISPATCHER.write(Core0Priority1Dispatcher::init());
            }
            let shared_resources = init();
            unsafe {
                SHARED.write(shared_resources);
            }
            unsafe {
                rtic::export::enable(hippomenes_core::Interrupt0, 2u16 as u8);
                rtic::export::enable(hippomenes_core::Interrupt2, 1u16 as u8);
            }
        });
        loop {}
    }
}
#[panic_handler]
fn p(_: &PanicInfo) -> ! {
    loop {}
}
