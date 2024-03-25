open_hw_manager
connect_hw_server -allow_non_jtag
open_hw_target
set_property PROGRAM.FILE {/home/pawel/hippomenes/hippomenes/fpga/hippomenes/hippomenes.runs/impl_1/fpga_top_n_clic.bit} [get_hw_devices xc7z020_1]
current_hw_device [get_hw_devices xc7z020_1]
refresh_hw_device -update_hw_probes false [lindex [get_hw_devices xc7z020_1] 0]
set_property PROBES.FILE {} [get_hw_devices xc7z020_1]
set_property FULL_PROBES.FILE {} [get_hw_devices xc7z020_1]
set_property PROGRAM.FILE {/home/pawel/hippomenes/hippomenes/fpga/hippomenes/hippomenes.runs/impl_1/fpga_top_n_clic.bit} [get_hw_devices xc7z020_1]
program_hw_devices [get_hw_devices xc7z020_1]
refresh_hw_device [lindex [get_hw_devices xc7z020_1] 0]
close_hw_target
disconnect_hw_server localhost:3121
close_hw_manager
exit





