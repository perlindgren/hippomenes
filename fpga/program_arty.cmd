call updatemem --meminfo arty/arty.runs/impl_1/fpga_arty.mmi --data ../rust_examples/binary.mem --proc hippo/imem/xpm_memory_spram_inst/xpm_memory_base_inst --bit arty/arty.runs/impl_1/fpga_arty.bit -out arty/arty.runs/impl_1/fpga_arty.bit -force
call vivado -mode tcl -source program_arty.tcl

