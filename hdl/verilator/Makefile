core = ../src/core
root = ../src

register_file = $(core)/register_file.sv $(core)/tb_register_file.sv

top_dep = \
$(root)/config_pkg.sv \
$(core)/decoder_pkg.sv \
$(root)/mem_pkg.sv \
$(root)/top.sv \
$(core)/decoder.sv \
$(register_file) \
$(core)/branch_logic.sv \
$(core)/alu.sv \
$(core)/reg_n.sv \
$(core)/pc_adder.sv \
$(core)/pc_mux.sv \
$(core)/alu_a_mux.sv \
$(core)/alu_b_mux.sv \
$(root)/mem.sv \
$(core)/csr.sv \
$(core)/wb_mux.sv 

top = $(top_dep) $(root)/tb_top.sv

test_branch = $(top_dep) $(root)/tb_test_branch.sv

test_mem = $(top_dep) $(root)/tb_test_mem.sv

csr = $(core)/decoder_pkg.sv $(core)/csr.sv $(core)/tb_csr.sv

mem = $(root)/config_pkg.sv $(root)/mem_pkg.sv $(root)/mem.sv $(root)/tb_mem.sv

di_mem = $(root)/config_pkg.sv $(root)/mem_pkg.sv $(root)/mem.sv $(root)/tb_di_mem.sv

alu = $(core)/decoder_pkg.sv $(core)/alu.sv $(core)/tb_alu.sv

branch_logic = $(core)/decoder_pkg.sv $(core)/branch_logic.sv $(core)/tb_branch_logic.sv

all: top test_branch test_mem

top: $(top) 
	verilator --binary $(top) --top-module tb_top --trace-fst --assert 
	obj_dir/Vtb_top

top_g: 
	gtkwave -a top.gtkw top.fst

test_branch: $(test_branch) 
	verilator --binary $(test_branch) --top-module tb_test_branch --trace-fst --assert 
	obj_dir/Vtb_test

test_branch_g: 
	gtkwave -a test_branch.gtkw test_branch.fst

test_mem: $(test_mem) 
	verilator --binary $(test_mem) --top-module tb_test_mem --trace-fst --assert --timing
	obj_dir/Vtb_test_mem

test_mem_g: 
	gtkwave -a test_mem.gtkw test_mem.fst

csr: $(csr)
	verilator --binary $(csr) --top-module tb_csr --trace-fst --assert
	obj_dir/Vtb_csr

alu: $(alu)
	verilator --binary $(alu) --top-module tb_alu --trace-fst --assert
	obj_dir/Vtb_alu

alu_g: 
	gtkwave -a alu.gtkw alu.fst

branch_logic: $(brach_logic)
	verilator --binary $(branch_logic) --top-module tb_branch_logic --trace-fst --assert
	obj_dir/Vtb_branch_logic

branch_logic_g:
	gtkwave -a branch_logic.gtkw branch_logic.fst

mem: $(mem)
	verilator --binary $(mem) --top-module tb_mem --trace-fst --assert
	obj_dir/Vtb_mem

mem_g:	
	gtkwave -a mem.gtkw mem.fst

di_mem: $(di_mem)
	verilator --binary $(di_mem) --top-module tb_di_mem --trace-fst --assert
	obj_dir/Vtb_di_mem

di_mem_g:
	gtkwave -a di_mem.gtkw di_mem.fst

register_file: $(register_file)
	verilator --binary $(register_file) --top-module tb_register_file --trace-fst --assert
	obj_dir/Vtb_register_file 

register_file_g:	
	gtkwave -a register_file.gtkw register_file.fst 
	
clean: 
	rm -r obj_dir