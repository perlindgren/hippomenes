
all: sv

sv: ../src/core/register_file.sv ../src/core/tb_register_file.sv 
	verilator --binary ../src/core/register_file.sv ../src/core/tb_register_file.sv --top-module tb_register_file --trace --assert
	obj_dir/Vtb_register_file 
	gtkwave -a register_file.gtkw register_file.vcd 

lint: p_clic.sv tb_p_clic.sv 
	verilator --lint-only p_clic.sv tb_p_clic.sv --top-module tb_p_clic --timing
	
clean: 
	rm -r obj_dir