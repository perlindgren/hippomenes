core = ../src/core
root = ../src

register_file = $(core)/register_file.sv $(core)/tb_register_file.sv

top_dep = \
$(root)/config_pkg.sv \
$(core)/decoder_pkg.sv \
$(core)/decoder.sv \
$(register_file) \
$(core)/branch_logic.sv \
$(root)/mem_pkg.sv \
$(core)/alu.sv \
$(core)/reg_n.sv \
$(core)/pc_adder.sv \
$(core)/pc_mux.sv \
$(core)/alu_a_mux.sv \
$(core)/alu_b_mux.sv \
$(root)/mem.sv \
$(core)/csr.sv \
$(core)/wb_mux.sv 

top_tb_ = $(top_dep) $(root)/tb_top.sv

tb_test = $(top_dep) $(root)/top.sv $(root)/tb_test.sv

csr_ = $(core)/decoder_pkg.sv $(core)/csr.sv $(core)/tb_csr.sv

mem_ = $(root)/config_pkg.sv $(root)/mem_pkg.sv $(root)/mem.sv $(root)/tb_mem.sv

di_mem_ = $(root)/config_pkg.sv $(root)/mem_pkg.sv $(root)/mem.sv $(root)/tb_di_mem.sv

decoder = $(core)/decoder_pkg.sv $(core)/decoder.sv $(core)/tb_decoder.sv

alu_ = $(core)/decoder_pkg.sv $(core)/alu.sv $(core)/tb_alu.sv

branch_logic_ = $(core)/decoder_pkg.sv $(core)/branch_logic.sv $(core)/tb_branch_logic.sv

all: top

top: $(top_tb_) 
	verilator --binary $(top_tb_) --top-module tb_top --trace-fst --assert --timing
	obj_dir/Vtb_top

top_g: 
	gtkwave -a top.gtkw top.fst

test: $(tb_test) 
	verilator --binary $(tb_test) --top-module tb_test --trace-fst --assert --timing
	obj_dir/Vtb_test


csr: $(csr_)
	verilator --binary $(csr_) --top-module tb_csr --trace-fst --assert
	obj_dir/Vtb_csr

dec: $(decoder)
	verilator --binary $(decoder) --top-module tb_decoder --trace-fst --assert
	obj_dir/Vtb_decoder

dec_g: dec
	gtkwave -a decoder.gtkw decoder.fst

alu: $(alu_)
	verilator --binary $(alu_) --top-module tb_alu --trace-fst --assert
	obj_dir/Vtb_alu

alu_g: alu
	gtkwave -a alu.gtkw alu.fst

bl: $(brach_logic_)
	verilator --binary $(branch_logic_) --top-module tb_branch_logic --trace-fst --assert
	obj_dir/Vtb_branch_logic

bl_g: bl
	gtkwave -a branch_logic.gtkw branch_logic.fst

	
	
mem: $(mem_)
	verilator --binary $(mem_) --top-module tb_mem --trace-fst --assert
	obj_dir/Vtb_mem

mem_g:	
	gtkwave -a mem.gtkw mem.fst

di_mem: $(di_mem_)
	verilator --binary $(di_mem_) --top-module tb_di_mem --trace-fst --assert
	obj_dir/Vtb_di_mem
	gtkwave -a di_mem.gtkw di_mem.fst

rf: $(register_file)
	verilator --binary $(register_file) --top-module tb_register_file --trace-fst --assert
	obj_dir/Vtb_register_file 
	gtkwave -a register_file.gtkw register_file.fst 

lint_rf: $(register_file) 
	verilator --lint-only $(register_file) --top-module tb_p_clic --timing
	
clean: 
	rm -r obj_dir