#!/bin/bash
updatemem --meminfo hippomenes/imem.mmi --data ../rust_examples/binary.mem --proc hippo/imem/xpm_memory_spram_inst/xpm_memory_base_inst --bit hippomenes/hippomenes.runs/impl_1/fpga_top_n_clic.bit -out hippomenes/hippomenes.runs/impl_1/fpga_top_n_clic.bit -force
vivado -mode tcl -source program.tcl
