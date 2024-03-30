# TOOLING

Hippomenes is formatted according to Verible (`verible-verilog-format`) standard template. For contributing to Hippomenes sources should be formatted accordingly (to avoid excessive git-diffs).

You might find the following setup useful for VSCODE based development:

## Verible

A set tools for working with (System)Verilog development.

[Verible](https://github.com/chipsalliance/verible/)comes packaged in arch Linux [verible-bin](https://aur.archlinux.org/packages/verible-bin). The tools can be also be compiled from source or installed from pre-built releases for both Windows and Linux.

Make sure the Verible tools are in path when starting `code`.

## Verilog-HDL VSCODE extension.

Does most of the heavy lifting, syntax highlighting, indexing, format on-save etc.. Will use the Verible language server, to do syntax checking on the go.

The Verilog-HDL plugin is very capable, supporting various formats (including TCL scripts used by Vivado). 

To check that the setup is working as intended:

- View Output (OUTPUT) and check the dropdown to the right. You should have both `Verilog` and `veribleVerilogLs`.

For `Verilog` the output should be something like:
```shell
2024-03-30 21:55:19.295 [info] [VerilogDocumentSymbolProvider] 0 top-level symbols returned
2024-03-30 21:55:28.105 [info] on save
```

For `veribleVerilogLs` the output should be something like:

```shell
Verible Verilog Language Server built at v0.0-3624-gd256d779
commandline: /opt/verible/verible-verilog-ls 
```

Path and version according to your install. 

## Vivado

If you want to target Xilinx FPGAs you need to install the [Vivado](https://www.xilinx.com/support/download.html) tool suit. On install make sure that Zynq/Artix 7000 is checked. Hippomenes does not depend on any non-free (licensed) IPs. 

## Verilator

[Verilator](https://github.com/verilator/verilator) comes packaged for many Linux distributions. It is also possible to install from source. If running Windows, you may find it easier to run Verilator under WSL (see below).

Verilator test-benches are provided for non-target specific modules. In the future we plan to provide a Verilator based git-hub CI.

## GtkWave

[GtkWave](https://github.com/gtkwave/gtkwave) comes packaged for many Linux distributions. 

## WSL

If using Windows, you may install the Verible/Verilator and GtkWave tools under WSL. In case of precompiled distribution of tools (e.g. Verible), remember to add the folder containing the binaries to your path (e.g., `/opt/verible`).

For this type of setup, you might want to run the Verilator flow under WSL while running Vivado under native Windows.

If you start `code` from WSL in the `hippomenes` Windows folder. Opening a Terminal in `code` will give you a WSL prompt from which you can run the Verilator test benches etc.

You can install WSL versions of the extensions to use e.g., Verible tooling installed under WSL.

## ... or not WSL

Alternatively you may start `code` natively under Windows and have the extensions and associated tools running natively.

## Your workflow

Please let us know if you run into some tooling problems and/or have suggestions on how the workflow could/should be improved.

https://github.com/perlindgren/hippomenes/issues/10












