core = ../src/core
root = ../src
rust = ../../rust_examples/
register_file = $(root)/config_pkg.sv $(core)/register_file.sv $(core)/tb_register_file.sv
rf_stack = $(root)/config_pkg.sv $(core)/reg_n.sv $(core)/rf_stack.sv $(core)/register_file.sv $(core)/tb_rf_stack.sv

top_dep = \
$(root)/config_pkg.sv \
$(core)/decoder_pkg.sv \
$(root)/mem_pkg.sv \
$(core)/decoder.sv \
$(core)/register_file.sv \
$(core)/branch_logic.sv \
$(core)/alu.sv \
$(core)/reg_n.sv \
$(core)/pc_adder.sv \
$(core)/pc_branch_mux.sv \
$(core)/alu_a_mux.sv \
$(core)/alu_b_mux.sv \
$(root)/mem.sv \
$(root)/rom.sv \
$(core)/csr.sv \
$(core)/csr_pins_in.sv \
$(core)/wb_mux.sv 

top = $(top_dep) $(root)/top.sv $(root)/tb_top.sv

top_n_clic = $(top_dep) $(root)/top_n_clic.sv $(core)/timer.sv $(core)/pc_interrupt_mux.sv $(core)/n_clic.sv $(core)/stack.sv $(core)/rf_stack.sv $(root)/tb_top_n_clic.sv

top_arty =  $(top_dep) $(root)/arty_pkg.sv $(root)/top_arty.sv $(core)/timer.sv $(core)/pc_interrupt_mux.sv $(core)/n_clic.sv $(core)/stack.sv $(core)/rf_stack.sv $(root)/tb_top_arty.sv $(root)/uart/fifo.sv $(root)/uart/uart.sv $(core)/mul.sv

top_branch = $(top_dep) $(root)/top.sv $(root)/tb_top_branch.sv

top_mem = $(top_dep) $(root)/top.sv $(root)/tb_top_mem.sv

n_clic = $(root)/config_pkg.sv $(core)/decoder_pkg.sv $(core)/pc_branch_mux.sv $(core)/reg_n.sv $(core)/stack.sv $(core)/n_clic.sv $(core)/csr.sv $(core)/timer.sv $(core)/tb_n_clic.sv

csr = $(root)/config_pkg.sv $(core)/decoder_pkg.sv $(core)/csr.sv $(core)/tb_csr.sv

stack = $(root)/config_pkg.sv $(core)/decoder_pkg.sv $(core)/stack.sv $(core)/tb_stack.sv

mem = $(root)/config_pkg.sv $(root)/mem_pkg.sv $(root)/mem.sv $(root)/tb_mem.sv

alu = $(root)/config_pkg.sv $(core)/decoder_pkg.sv $(core)/alu.sv $(core)/tb_alu.sv

mul = $(root)/config_pkg.sv $(core)/decoder_pkg.sv $(core)/mul.sv $(core)/tb_mul.sv

time_stamp = $(root)/config_pkg.sv $(core)/decoder_pkg.sv $(core)/csr.sv $(core)/mono_timer.sv $(core)/time_stamp.sv $(core)/tb_time_stamp.sv

timer = $(root)/config_pkg.sv $(core)/decoder_pkg.sv $(core)/csr.sv $(core)/timer.sv $(core)/tb_timer.sv 

branch_logic = $(root)/config_pkg.sv $(core)/decoder_pkg.sv $(core)/branch_logic.sv $(core)/tb_branch_logic.sv

uart = $(root)/config_pkg.sv $(root)/core/decoder_pkg.sv $(root)/uart/uart.sv $(root)/uart/tb_uart.sv

all: \
	tb_alu \
	tb_branch_logic \
	tb_csr \
	tb_register_file \
	tb_rf_stack \
	tb_mem \
	tb_stack \
	tb_n_clic \
	tb_timer \
	tb_time_stamp \
	tb_stack \
	tb_top_arty 
	# tb_top_branch \
	# tb_top_mem \
	# tb_top \
	# tb_fpga_top \

#asm: $(top_n_clic)
#	cp ./asm.s ./riscv_asm/; cp ./memory.x ./riscv_asm/; cd ./riscv_asm; cargo clean; cargo build --release; rm ./asm.s ./memory.x
#	elf2mem -f ./riscv_asm/target/riscv32i-unknown-none-elf/release/riscv_asm -t ./binary.mem -p

tb_uart: 
	verilator --binary $(uart) --top-module tb_uart --trace-fst --assert -y $(rust)
	obj_dir/Vtb_uart

tb_uart_g:
	gtkwave -a uart.gtkw uart.fst

asm: 
#	cd ../../rust_examples/; cargo build --example asm --release; elf2mem -f ./target/riscv32i-unknown-none-elf/release/examples/asm -t ../hdl/verilator/binary.mem -p;

tb_top_arty: $(top_arty)
	verilator --binary $(top_arty) --top-module tb_top_arty --trace-fst --assert -y $(rust) 
	obj_dir/Vtb_top_arty

tb_top_arty_g: 
	gtkwave -a top_arty.gtkw top_arty.fst

tb_top_n_clic: $(top_n_clic)
	make asm
	verilator --binary $(top_n_clic) --top-module tb_top_n_clic --trace-fst --assert -y $(rust) 
	obj_dir/Vtb_top_n_clic

tb_top_n_clic_g: 
	gtkwave -a top_n_clic.gtkw top_n_clic.fst

tb_top: $(top) 
	verilator --binary $(top) --top-module tb_top --trace-fst --assert 
	obj_dir/Vtb_top

tb_top_g: 
	gtkwave -a top.gtkw top.fst

tb_fpga_top: $(fgpa_top) 
	verilator --binary $(fgpa_top) --top-module tb_fpga_top --trace-fst --assert 
	obj_dir/Vtb_fpga_top

tb_fgpa_top_g: 
	gtkwave -a fpga_top.gtkw fpga_top.fst

tb_top_branch: $(test_branch) 
	verilator --binary $(top_branch) --top-module tb_top_branch --trace-fst --assert 
	obj_dir/Vtb_top_branch

tb_top_branch_g: 
	gtkwave -a top_branch.gtkw top_branch.fst

tb_top_mem: $(test_mem) 
	verilator --binary $(top_mem) --top-module tb_top_mem --trace-fst --assert --timing
	obj_dir/Vtb_top_mem

tb_top_mem_g: 
	gtkwave -a top_mem.gtkw top_mem.fst

tb_time_stamp: $(time_stamp)
	verilator --binary $(time_stamp) --top-module tb_time_stamp --trace-fst --assert
	obj_dir/Vtb_time_stamp

tb_time_stamp_g: 
	gtkwave -a time_stamp.gtkw time_stamp.fst

tb_timer: $(timer)
	verilator --binary $(timer) --top-module tb_timer --trace-fst --assert
	obj_dir/Vtb_timer

tb_timer_g: 
	gtkwave -a timer.gtkw timer.fst

tb_csr: $(csr)
	verilator --binary $(csr) --top-module tb_csr --trace-fst --assert
	obj_dir/Vtb_csr

tb_csr_g: 
	gtkwave -a csr.gtkw csr.fst

tb_stack: $(stack)
	verilator --binary $(stack) --top-module tb_stack --trace-fst --assert
	obj_dir/Vtb_stack

tb_stack_g: 
	gtkwave -a stack.gtkw stack.fst

tb_n_clic: $(n_clic)
	verilator --binary $(n_clic) --top-module tb_n_clic --trace-fst --assert
	obj_dir/Vtb_n_clic

tb_n_clic_g: 
	gtkwave -a n_clic.gtkw n_clic.fst

tb_alu: $(alu)
	verilator --binary $(alu) --top-module tb_alu --trace-fst --assert
	obj_dir/Vtb_alu

tb_alu_g: 
	gtkwave -a alu.gtkw alu.fst

tb_mul: $(mul)
	verilator --binary $(mul) --top-module tb_mul --trace-fst --assert
	obj_dir/Vtb_mul

tb_mul_g:
	gtkwave -a mul.gktw mul.fst

tb_branch_logic: $(brach_logic)
	verilator --binary $(branch_logic) --top-module tb_branch_logic --trace-fst --assert
	obj_dir/Vtb_branch_logic

tb_branch_logic_g:
	gtkwave -a branch_logic.gtkw branch_logic.fst

tb_spram: $(spram)
	verilator --binary $(psram) --top-module tb_mem --trace-fst --assert
	obj_dir/Vtb_mem

tb_spram_g:	
	gtkwave -a spram.gtkw spram.fst


tb_mem: $(mem)
	verilator --binary $(mem) --top-module tb_mem --trace-fst --assert
	obj_dir/Vtb_mem

tb_mem_g:	
	gtkwave -a mem.gtkw mem.fst

tb_di_mem: $(di_mem)
	verilator --binary $(di_mem) --top-module tb_di_mem --trace-fst --assert
	obj_dir/Vtb_di_mem

tb_di_mem_g:
	gtkwave -a di_mem.gtkw di_mem.fst

tb_register_file: $(register_file)
	verilator --binary $(register_file) --top-module tb_register_file --trace-fst --assert
	obj_dir/Vtb_register_file 

tb_register_file_g:	
	gtkwave -a register_file.gtkw register_file.fst 

tb_rf_stack: $(rf_stack)
	 verilator --binary $(rf_stack) --top-module tb_rf_stack --trace-fst --assert 
	obj_dir/Vtb_rf_stack

tb_rf_stack_g:	
	gtkwave -a rf_stack.gtkw rf_stack.fst 
	
clean: 
	rm -r obj_dir
