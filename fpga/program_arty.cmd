call updatemem --bit arty/arty.runs/impl_1/fpga_arty.bit --meminfo arty/arty.runs/impl_1/fpga_arty.mmi --data ../rust_examples/text.mem   --proc hippo/imem/xpm_memory_spram_inst/xpm_memory_base_inst --data ../rust_examples/data_0.mem --proc hippo/dmem/block_0/xpm_memory_spram_inst/xpm_memory_base_inst --data ../rust_examples/data_1.mem --proc hippo/dmem/block_1/xpm_memory_spram_inst/xpm_memory_base_inst --data ../rust_examples/data_2.mem --proc hippo/dmem/block_2/xpm_memory_spram_inst/xpm_memory_base_inst --data ../rust_examples/data_3.mem --proc hippo/dmem/block_3/xpm_memory_spram_inst/xpm_memory_base_inst -out arty/arty.runs/impl_1/fpga_arty.bit -force
call vivado -mode tcl -source program_arty.tcl
