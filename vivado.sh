#!/usr/bin/env -S vivado -mode batch -source
# Vivado in project mode is less bad
create_project arty ./fpga/arty -force -part xc7a35ticsg324-1L;
# Generate file list in Vivado format and add the files to the project
exec bender script vivado -t fpga > vivado_temp.tcl
source vivado_temp.tcl

# set given top as top, and generate a reasonable compile order
# set_property top ${TOP} [get_filesets sim_1] 
#update_compile_order -fileset [current_fileset]

#launch_simulation

# this should make xsim log all of the signals in the model. it is probably required to
# launch the simulation after.
#log_wave -r *

# view wdb
#exec xsim ./test.sim/sim_1/behav/xsim/${TOP}_behav.wdb -gui
