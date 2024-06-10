# FPGA

Currently Hippomenes have been deployed to two different Xilinx FPGA targets, the PYNQ-Z1 and the ARTY. Deployment is non-normative to the RISC-V RT specification, and thus not semantically versioned.

In the following the workflow for ARTY is described, similar workflow for PYNQ-Z1 should be possible.

## ARTY requirements

Workflow tested under Win10 and arch Linux.

- Vivado design suit 2023.2, with Artix 7 support. The tools should be in path.
- [openFPGALoader](https://github.com/trabucayre/openFPGALoader). Available as package under arch Linux.
- Rust toolchain with `riscv32i-unknown-none-elf` target
  - `rustup target add riscv32i-unknown-none-elf`
- `elf2mem`

You can install `elf2mem` either by:

```shell
cargo install --git https://github.com/perlindgren/elf2mem.git`
```

or locally by:
  
```shell
git clone https://github.com/perlindgren/elf2mem
cd elf2mem
cargo install --path . 
```

## Project build

Fork/Clone the project (currently use the ARTY branch but this will be merged to master later). Run following commands:

```shell
cd hippomenes/fpga
vivado -mode tcl -source arty.tcl
```

If the `arty` folder already exists, the script will fail. Remove the `arty` folder first. (This will be automated in later.)

The `arty/arty.xpr` is created you can now open the the project in Vivado and work from there.

```shell
vivado arty/arty.xpr
```

## Deployment

The typical workflow is:

- Run Synthesis
- Run Implementation
- Generate Bitstream
- Open Hardware Manager (the ARTY needs to be connected over USB)
- Program Device (the `fpga\arty\arty.runs\impl_1\fgpa_arty.bit` under Windows or `fpga/arty/arty.runs/impl_1/fgpa_arty.bit` under Linux).

## Structure

To allow Vivado projects to work with git, all Vivado specific files are found in `fpga/arty_top`. Other files generic to Hippomenes are tracked under `hdl/src`.

## Software workflow

Hippomenes programming follows a Rust first approach.

Source file examples are found under `rust_examples`, to build `asm_loop`:

```shell
cargo build --example asm_loop --release
elf2mem -f ./target/riscv32i-unknown-none-elf/release/examples/asm_loop -t binary.mem
```

To patch the generated bitstream with the new binary, run in the `fpga` folder, for Windows:

```shell
./program_arty.cmd
```

or, for Linux

```shell
./program_arty.sh
```

Under Linux, we package all of the above as a `cargo` runner, compiling an example, resynthesizing the memory and reprogramming the target are all done by
```shell
cargo run --example <EXAMPLE> --release
```

<!--In future updates tighter integration with `cargo` will be provided building on the aforementioned tooling.-->

Notice, under Windows we rely on Vivado for the programming which is tremendously slow (several seconds), as it will for each time start the `Hardware Manager` establish a connection to the device, etc. (replicating each action in the gui).

Under Linux we use the `openFPGAloader` which directly connects to the target without the need to start Vivado. It might be possible to use `openFPGAloader` under `wsl`, but this is not yet tested.

For patching the bitstream we currently use the Vivado tool `updatemem`, also here an open source variant would be preferable.
