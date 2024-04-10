#!/usr/bin/tclsh

# set src_files [glob "hippo/a_pkg.sv" "hippo/adder.sv" "hippo/fpga_icebreaker.sv" ]
set src_files [glob "hippo/adder.sv" "hippo/fpga_icebreaker.sv" ]
puts $src_files

set synth_top top

#yosys "plugin -i systemverilog"
# yosys "help read_systemverilog"
#yosys "read_systemverilog -defer $src_files"
#yosys "read_systemverilog $src_files"
#yosys "read_systemverilog -link" 
yosys "read_verilog -sv $src_files"
#yosys "hierarchy -check -top $synth_top"

yosys "proc"
yosys "opt"
yosys "write_verilog synth/rt_top_netlist.v"
