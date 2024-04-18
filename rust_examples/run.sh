#!/bin/bash
elf2mem -f $1
updatemem --meminfo ../spram/spram.runs/impl_1/fpga_arty.mmi --data ./text.mem --proc hippo/imem/xpm_memory_spram_inst/xpm_memory_base_inst --bit ../spram/spram.runs/impl_1/fpga_arty.bit -out ../spram/spram.runs/impl_1/fpga_arty.bit -force
updatemem --meminfo ../spram/spram.runs/impl_1/fpga_arty.mmi --data ./data_0.mem --proc hippo/dmem/block_0/xpm_memory_spram_inst/xpm_memory_base_inst --bit ../spram/spram.runs/impl_1/fpga_arty.bit --out ../spram/spram.runs/impl_1/fpga_arty.bit --force
updatemem --meminfo ../spram/spram.runs/impl_1/fpga_arty.mmi --data ./data_1.mem --proc hippo/dmem/block_1/xpm_memory_spram_inst/xpm_memory_base_inst --bit ../spram/spram.runs/impl_1/fpga_arty.bit --out ../spram/spram.runs/impl_1/fpga_arty.bit --force
updatemem --meminfo ../spram/spram.runs/impl_1/fpga_arty.mmi --data ./data_2.mem --proc hippo/dmem/block_2/xpm_memory_spram_inst/xpm_memory_base_inst --bit ../spram/spram.runs/impl_1/fpga_arty.bit --out ../spram/spram.runs/impl_1/fpga_arty.bit --force
updatemem --meminfo ../spram/spram.runs/impl_1/fpga_arty.mmi --data ./data_3.mem --proc hippo/dmem/block_3/xpm_memory_spram_inst/xpm_memory_base_inst --bit ../spram/spram.runs/impl_1/fpga_arty.bit --out ../spram/spram.runs/impl_1/fpga_arty.bit --force



openFPGALoader -b  arty ../spram/spram.runs/impl_1/fpga_arty.bit
