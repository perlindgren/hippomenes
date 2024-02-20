core = ../src/core
register_file = $(core)/register_file.sv $(core)/tb_register_file.sv

all: rf

rf: $(register_file)
	verilator --binary $(register_file) --top-module tb_register_file --trace --assert
	obj_dir/Vtb_register_file 
	gtkwave -a register_file.gtkw register_file.vcd 

lint_rf: $(register_file) 
	verilator --lint-only $(register_file)--top-module tb_p_clic --timing
	
clean: 
	rm -r obj_dir