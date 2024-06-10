#!/bin/bash
updatemem --meminfo arty/arty.runs/impl_1/fpga_arty.mmi --data ../rust_examples/binary.mem --proc hippo/imem/xpm_memory_spram_inst/xpm_memory_base_inst --bit arty/arty.runs/impl_1/fpga_arty.bit -out arty/arty.runs/impl_1/fpga_arty.bit -force
updatemem --meminfo arty/arty.runs/impl_1/fpga_arty.mmi --data ../rust_examples/data.mem --proc hippo/rom/xpm_memory_spram_inst/xpm_memory_base_inst --bit arty/arty.runs/impl_1/fpga_arty.bit -out arty/arty.runs/impl_1/fpga_arty.bit -force
openFPGALoader -b  arty arty/arty.runs/impl_1/fpga_arty.bit

