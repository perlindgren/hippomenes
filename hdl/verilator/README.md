# Verilator workflow

The verilator workflow has been tested under `arch` linux, and Windows `wsl` (running ubuntu 22).

## Dependencies

You need to have 

- [verilator](https://verilator.org/guide/latest/install.html), and
- [GTKWave](https://gtkwave.sourceforge.net/)

If you change/update the `verilator` version please make sure to:

```shell
make clean
```

This will remove the `obj_dir` where compilation artifacts are stored. (Not doing so may yield weird compilation errors.)

## Makefile structure

The HippoMenes design is modular, with separate test benches for each larger module.

Separately testable modules in the `core`.

- `tb_alu` 
- `tb_branch_logic`
- `tb_decoder` (may be superseded by `top`)

And at `top` level:
- `tb_mem` (tests the generic memory module)
- `tb_di_mem` (tests separation of memory banks)
- `tb_top`

## Running tests

```shell
make <test>_g # runs tests and opens gtkwave
make <test>   # runs just the test
```

