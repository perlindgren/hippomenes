# Hippomenes, in love with Atalanta

Experimental RISC-V RT extension implementation.

Architectural design follows the submitted proposal (contact per.lindgren@ltu.se for pre-print).
The design goal of RISC-V RT is to provide a specification for light-weight MCU implementations enabling the implementation of (hard) real-time systems. RISC-V RT currently features:

- N-CLIC 
    - zero-latency interrupt selection and dispatch
    - zero-overhead interrupt execution (handler run as normal function)
    - zero-latency tail-chaining
- Hardware time stamping
    - cycle accurate monotonic timer
    - configurable pre-scaler
    - configurable precision
- CSR mapped registers (thus the overhead of MMIO accesses eliminated)
- Timer peripheral
    - cycle accurate
    - configurable pre-scaler
- Example GPIO
    - Led-array indicating set condition


Design elements are scaled with the selected number of priority levels, thus allowing to trade scheduling flexibility against hardware implementation cost.

The design acts a reference implementation for the RISC-V RT extension, and should be consider the specification. 

## Versioning

The design follows semantic versioning (regarding expected behavior) along the triple, $x.y.z$:

- $x$, major version, indicates breaking API changes (requires update of run-time system and in cases applications)
- $y$, minor version, indicates backwards compatible feature additions. Run-time system/application updates required only for leveraging added features.
- $z$, patch level, indicates backwards compatible changes, e.g., bug-fixes, and non-user facing improvements to the implementation such internal names, tests, and synthesis flow.

As the RISC-V RT (and its reference implementation) is not yet considered feature complete:

- $0$, major version is zero
- $y$, indicates breaking API changes (requires update of run-time system and in cases applications)
- $z$, indicates backwards compatible feature additions. Run-time system/application updates required only for leveraging added features as well as patch level.

See [CHANGELOG.md](/CHANGELOG.md) for current status.

## Structure

The repository is structured as follows:

- `fpga`, backend workflow (currently targeting Vivado/Xinix Pynq-Z1, more targets will follow)
- `hdl`
  - `src`, System Verilog design sources and test benches. 
  - `verilator`, simulation setup.

## Simulation

The design can be simulated using the Verilator tool, see [Simulation](/hdl/verilator/README.md).

## Synthesis

The design can be synthesized to the entry level Pynq-Z1 platform using the Vivado tool, see [Synthesis](/fpga/README.md).

Resource usage for a configuration with 4 priority levels (as the ARM Cortex M0) and 4K of SRAM is depicted below:

The data memory (`dmem`) stands for the majority of the required resources, while the stacked register file (`rf`) and (`n-clic`) together amounts to a third of the resources used.

![RISC-V RT](fpga_synth.png)

Looking closer at the resource utilization:
![FPGA-STATS](fpga_stats.png)

And in comparison to resources available for the entry level Pynq-Z1:

![FPGA-STATS-COMP](fpga_stats_comp.png)

Interesting here is that the total design amounts to less than 4 percent of the logic resources, thus the design can be considered ultra light-weight.

This is also reflected by the modest synthesis time, less than 2 minutes for a clean build flow (synthesis, implementation, bitmap generation and target deployment) on a standard desktop (Amd-7950x3d, 32 gig-ram, running arch linux 6.9 and Vivado 2023-2). (Iterative builds are typically faster.)

## Prototyping

The RISC-RT and its implementation has been modelled using the [SyncRim](https://github.com/perlindgren/syncrim/tree/hippomenes) tool. The high-level SyncRim model and its implementation is in 1-1 functional correspondence, thus providing an interactive, cycle accurate, high-level simulation model of the proposed RISC-V RT specification.

![RISC-V RT](SyncRim.png)

## Example

The below example showcase prominent features of the RISC-V RT, and the Hippomenes reference implementation:

```assembly
            .option  norvc
            .text
init:       la      sp, _stack_start        # set stack pointer
main:       csrwi   0x300, 8                # enable global interrupts
            la      t1, isr_0
            srl     t1, t1, 2
            csrw    0xB00, t1               # setup isr_0 address

            li      t2, 0b11110000          # interrupt every 15 cycles, cmp value 0b1111 = 15, prescaler 0b0000                                           
            csrw    0x400, t2               # timer.counter_top CSR
            la t1,  0b1110                  # prio 0b11, enable, 0b1, pend 0b0
            csrw    0xB20, t1               # write above to interrupt 0 (timer interrupt)
stop:       j       stop                    # wait for interrupt

isr_0:      la      t0, .toggled            # &static mut toggled state
            lw      t1, 0(t0)               # deref toggled
            xori    t1, t1, 1               # toggle bit 0
            csrw    0x0, t1                 # set bit 0 (t1 = 1) in GPIO CSR (LED on/off)
            sw      t1, 0(t0)               # store toggled value
            csrr    t3, 0xB40               # read captured timestamp
            sw      t3, 4(t0)               # store timestamp
            jr      ra                      # return 

            .data
.toggled:   .word   0x0                     # state
            .word   0x0                     # time-stamp
```

The run-time (`.init`) for this case is a single instruction to setup the (shared) stack pointer. The application (`.main`) starts by enabling global interrupts (`0x300`), setting up the interrupt vector address (`0xb00`) for `isr_0` (the vector table does not store the two least significant bits so we shift right by 2). We then configure the timer peripheral (`x400`) to generate an interrupt each 15 cycles. Finally we configure the interrupt control (`xb20`), setting priority to 3, and the enable bit to 1, and wait in a busy loop for interrupts to occur.

The interrupt handler (`isr_0`) reads the local resource (`.toggled`), toggles bit 0, updates the gpio (`0x0`) and stores the toggled value back to the local resource. It then reads the timestamp the interrupt (`0xB40`) and stores that to the local resource.

A SyncRim simulation is show below:
![RISC-V RT](asm_timer_sim.png)


At the end of the `isr_0`, the register `ra` has the value `0xFFFFFFFF` indicating to the `n-clic` to return to the preempted task (`.stop` in this case). The `.toggled.led_state` is `00000001` (as indicated by the LED bit 0 being lit red). The `.toggled.timestamp` value is `00000019`, indicate the *global* monotonic time when the interrupt was captured.

State at next interrupt return is shown below:
![RISC-V RT](asm_timer_sim2.png)
At this point we see that the `.toggled.led_state` is `00000000` (as indicated by the LED bit 0 being grey). The `.toggled.timestamp` value is `0000002a`, indicate the *global* monotonic time when the interrupt was captured. The timer re-load has for this implementation a latency of 1.


## License

To be determined, contact per.lindgren@ltu.se for licensing questions.










