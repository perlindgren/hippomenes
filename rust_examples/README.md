# Hippomenes Rust Examples

This crate contains simple code examples for Hippomenes.

## Tooling

This crate requires the Rust compiler for compiling, and the ``elf2mem`` utility for generating the binary dump file Verilog uses to populate the ROM component.

To set up the Rust toolchain, consult [Install Rust](https://www.rust-lang.org/tools/install).

On Linux, this amounts to running:

```shell
curl --proto '=https' --tlsv1.2 -sSf https://sh.rustup.rs | sh
```

With the Rust toolchain set up, ``elf2mem`` can be installed by cloning the ``elf2mem`` repository, and installing the tool via ``cargo``:

```shell
git clone git@github.com:perlindgren/elf2mem.git
```

```shell
cargo install --path ./elf2mem
```

## Compiling

To compile one of the examples use:

```shell
cargo build --example <EXAMPLE> --release
```

To dump the generated binary as a Verilog ``.mem`` file use:

```shell
elf2mem -f ./target/riscv32i-unknown-none-elf/release/examples/<EXAMPLE> -t binary.mem 
```

To resynthesize, and replace the Hippomenes memory component, and reprogram your Arty board under Linux or Windows, the ``../fpga/program_arty.sh`` and ``../fpga/program_arty.cmd`` scripts can be used respectively.

Under Linux, all of the above steps can be performed via the runner, so running one of the examples on your board amounts to

```shell
cargo run --example <EXAMPLE> --release
```

## The examples

### ``asm``

The ``asm`` example emits the contents of ``asm.s`` as a global assembly block, and links it using ``memory.x``.

### ``rtic``

This is a simple example of running the [RTIC](https://github.com/rtic-rs/rtic) framework.

Currently, the hippomenes fork of the framework ONLY supports hardware tasks WITH shared resources.
