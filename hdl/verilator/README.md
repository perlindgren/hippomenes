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

The HippoMenes design is modular, with separate test benches for each larger module. Useage:

```
make <tb> # to run test
make <tb>_g # to open corresponding gtkwave
```


Testbenches for the `core`.

- `alu` 
- `branch_logic`
- `csr`
- `register_file`

And at `top` level:
- `top` (test the top modul)
- `test_mem` (test storage operations)
- `test_branch` (test branching operations)
- `mem` (tests the generic memory module)
- `di_mem` (tests separation of memory banks)


