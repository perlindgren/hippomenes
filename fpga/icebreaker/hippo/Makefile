PROJ = fpga_icebreaker

PIN_DEF = ../icebreaker.pcf
DEVICE = up5k
PACKAGE = sg48

SRC = ../../../hdl/src
ADD_SRC = \
 $(SRC)/config_pkg.sv \
 $(SRC)/core/decoder_pkg.sv \
 $(SRC)/mem_pkg.sv \
 $(SRC)/core/alu.sv \
 $(SRC)/core/alu_a_mux.sv \
 $(SRC)/core/alu_b_mux.sv \
 $(SRC)/core/branch_logic.sv \
 $(SRC)/core/csr.sv \
 $(SRC)/core/decoder.sv \
 $(SRC)/core/mono_timer.sv \
 $(SRC)/core/n_clic.sv \
 $(SRC)/core/pc_adder.sv \
 $(SRC)/core/pc_branch_mux.sv \
 $(SRC)/core/pc_interrupt_mux.sv \
 $(SRC)/core/reg_n.sv \
 $(SRC)/core/register_file.sv \
 $(SRC)/core/rf_stack.sv \
 $(SRC)/core/stack.sv \
 $(SRC)/core/time_stamp.sv \
 $(SRC)/core/timer.sv \
 $(SRC)/core/wb_mux.sv \
 $(SRC)/rom.sv \
 $(SRC)/mem.sv \
 $(SRC)/icebreaker_top_n_clic.sv 
 
 #$(SRC)/rom.sv \
 
 
# $(SRC)/core/reg_n.sv


# ADD_DEPS = a_pkg.sv

prog: iceprog

include ../main.mk
