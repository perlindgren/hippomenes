# Hippomenes Rust Examples

This crate contains simple code examples for Hippomenes

# Tooling

This crate requires the Rust compiler for compiling, and the ``elf2mem`` utility for generating the binary dump file Verilog uses to populate the ROM component.

To set up the Rust toolchain, consult [Install Rust](https://www.rust-lang.org/tools/install)

On Linux, this amounts to running

```curl --proto '=https' --tlsv1.2 -sSf https://sh.rustup.rs | sh```


With the Rust toolchain set up, ``elf2mem`` can be installed by cloning the ``elf2mem`` repository, and installing the tool via ``cargo``

```git clone git@github.com:perlindgren/elf2mem.git```
```cargo install --path ./elf2mem```

# Compiling

To compile one of the examples use

```cargo build --example <EXAMPLE> --release```

# The examples

## ``asm``
 The ``asm`` example emits the contents of ``asm.s`` as a global assembly block, and links it using ``memory.x``.
## ``rtic``
 This is a simple example of running the [RTIC](https://github.com/rtic-rs/rtic) framework.
 Currently, the hippomenes fork of the framework ONLY supports hardware tasks WITH shared resources.
 The linker script ``memory.x.rtic`` must be used by renaming it to ``memory.x``. This step can probably be done automatically,
 so this is a temporary workaround until that is figured out.
