core = ../src/core
register_file = $(core)/register_file.sv $(core)/tb_register_file.sv

top_ = $(register_file) $(core)/pc_adder.sv $(core)/pc_mux.sv $(core)/tb_top.sv

all: top

top: $(top_) 
	verilator --binary $(top_) --top-module tb_top --trace-fst --assert
	obj_dir/Vtb_top
	gtkwave -a top.gtkw top.fst

rf: $(register_file)
	verilator --binary $(register_file) --top-module tb_register_file --trace-fst --assert
	obj_dir/Vtb_register_file 
	gtkwave -a register_file.gtkw register_file.fst 

lint_rf: $(register_file) 
	verilator --lint-only $(register_file)--top-module tb_p_clic --timing
	
clean: 
	rm -r obj_dir