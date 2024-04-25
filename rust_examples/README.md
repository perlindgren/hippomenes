# Hippomenes Rust Examples

This crate contains simple code examples for Hippomenes.

## Disclaimer

Some of the steps described in the `Tooling` and `Compiling` sections assume a Vivado-based workflow.
Most of the steps can be applied to any target and workflow, however the `elf2mem` utility and associated scripts (runner, ``../fpga/program_arty.sh``, ``../fpga/program_arty.cmd``) are intended to be used with Vivado.
If you are aware of an open-source alternative to `updatemem`, let us know!

## Tooling

This crate requires the Rust compiler for compiling, and the ``elf2mem`` utility for generating the binary dump file that SystemVerilog uses to populate the ROM and RAM components.

To set up the Rust toolchain, consult [Install Rust](https://www.rust-lang.org/tools/install).

On Linux, this amounts to running:

```shell
curl --proto '=https' --tlsv1.2 -sSf https://sh.rustup.rs | sh
```

Hippomenes implements the ``riscv32i`` instruction set, so to compile for Hippomenes, we must set-up the toolchain for that specific target. This can be done by

```shell
rustup target add riscv32i-unknown-none-elf
```
With the Rust toolchain set up, ``elf2mem`` can be installed by cloning the ``elf2mem`` repository, and installing the tool via ``cargo``:

```shell
git clone git@github.com:perlindgren/elf2mem.git
```

```shell
cargo install --path ./elf2mem
```

To reprogram the FPGA, we use ``openFPGALoader``. On Arch Linux, this comes nicely packaged in the AUR.


```shell
yay -S openFPGALoader-git
```

For other distros, pre-built release binaries are available on [GitHub](https://github.com/trabucayre/openFPGALoader/releases). Running under Windows is also possible, albeit more involved, consult the excellent guide [here](https://fpga.mit.edu/6205/F22/documentation/openFPGA).


The final prerequisite for using the default workflow is Vivado. Make sure to also add the Vivado bin path (typically ``/home/<USER>/.local/bin/Xilinx/Vivado/<VERSION>/bin``) to your `PATH` variable, we use the Vivado `updatemem` CLI to replace the Block RAM on the fly.

## Compiling

To compile one of the examples use:

```shell
cargo build --example <EXAMPLE> --release
```

To dump the generated binary as a SystemVerilog ``.mem`` file use:

```shell
elf2mem -f ./target/riscv32i-unknown-none-elf/release/examples/<EXAMPLE> -t binary.mem 
```

To resynthesize, and replace the Hippomenes memory component, and reprogram your Arty board under Linux or Windows, the ``../fpga/program_arty.sh`` and ``../fpga/program_arty.cmd`` scripts can be used respectively.

Under Linux, all of the above steps can be performed via the runner, so running one of the examples on your board amounts to

```shell
cargo run --example <EXAMPLE> --release
```

## The examples

The examples are generally split into three categories: very simple pure assembly sanity checks, more advanced Rust examples, and fully-fledged RTIC applications.
The source code of each example contains a simple explanation along with expected behavior.
Because the Rust-based examples take advantage of the ``hippomenes-rt`` runtime crate, there is quite a lot of setup before ``main()`` is hit.
It is therefore recommended to first ensure the assembly examples are working as intended before moving on to trying the Rust examples when working on changes to Hippomenes.

### RTIC disclaimer

Currently, the Hippomenes fork of the RTIC framework is an early WiP, ONLY supporting hardware tasks WITH shared resources.
