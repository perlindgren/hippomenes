# Verilator workflow

The Verilator workflow has been tested under `arch` linux, and Windows `wsl` (running ubuntu 22).

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

The HippoMenes design is modular, with separate test benches for each larger module. Usage:

```
make <tb> # to run test
make <tb>_g # to open corresponding gtkwave
```

Test benches for the `core`.

- `tb_alu` 
- `tb_branch_logic`
- `tb_csr`
- `tb_nc_lic`
- `tb_register_file` (single register file)
- `tb_rf_stack` (stacked `register_file` instances)
- `tb_stack` (general stack used by the `n_clic`)
- `tb_timer`
- `tb_time_stamp`

And at `top` level:
- `tb_di_mem` (tests separation of memory banks)
- `tb_mem` (test generic data memory)
- `tb_top_n_clic` (testing the whole Hippo)

