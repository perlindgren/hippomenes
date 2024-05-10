#!/bin/bash
elf2mem -f $1 
updatemem --meminfo ../fpga/arty/arty.runs/impl_1/fpga_arty.mmi --data ./text.mem --proc hippo/imem/xpm_memory_spram_inst/xpm_memory_base_inst --bit ../fpga/arty/arty.runs/impl_1/fpga_arty.bit -out ../fpga/arty/arty.runs/impl_1/fpga_arty.bit -force
openFPGALoader -b  arty ../fpga/arty/arty.runs/impl_1/fpga_arty.bit
