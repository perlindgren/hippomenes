# Hippomenes, in love with Atalanta

Experimental RISC-V RT extension implementation.

Architectural design follows the submitted proposal (contact per.lindgren@ltu.se for pre-print).
The design goal of RISC-V RT is to enable light weight implementations enabling the implementation of (hard) real-time systems. RISC-V RT currently features:

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

The design follows semantic versioning (regarding expected behavior) along the triple, $x$.$y$.$z$:

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

## Prototyping

The RISC-RT and its implementation has been modelled using the [SyncRim](https://github.com/perlindgren/syncrim/tree/hippomenes) tool. The high-level SyncRim model and its implementation is in 1-1 functional correspondence, thus providing an interactive, cycle accurate, high-level simulation model of the proposed RISC-V RT specification.

![RISC-V RT](SyncRim.png)

## License

To be determined, contact per.lindgren@ltu.se for licensing questions.










