# This script was generated automatically by bender.
set ROOT "/home/pawel/hippo-edf/hippomenes"
add_files -norecurse -fileset [current_fileset] [list \
    $ROOT/.bender/git/checkouts/hippomenes-tree-2fcaf897d996810c/hdl/tree.sv \
]
add_files -norecurse -fileset [current_fileset] [list \
    $ROOT/.bender/git/checkouts/edf-ic-1e9ed6b543664f9e/rtl/gateway_cell.sv \
    $ROOT/.bender/git/checkouts/edf-ic-1e9ed6b543664f9e/rtl/edf_ic.sv \
]
add_files -norecurse -fileset [current_fileset] [list \
    $ROOT/./hdl/src/config_pkg.sv \
    $ROOT/./hdl/src/arty_pkg.sv \
    $ROOT/./hdl/src/core/decoder_pkg.sv \
    $ROOT/./hdl/src/mem_pkg.sv \
    $ROOT/./hdl/src/core/csr.sv \
    $ROOT/./hdl/src/core/reg_n.sv \
    $ROOT/./hdl/src/core/pc_branch_mux.sv \
    $ROOT/./hdl/src/core/pc_interrupt_mux.sv \
    $ROOT/./hdl/src/core/pc_adder.sv \
    $ROOT/./hdl/src/core/xilinx_sp_BRAM.sv \
    $ROOT/./hdl/src/core/atl_rom.sv \
    $ROOT/./hdl/src/core/decoder.sv \
    $ROOT/./hdl/src/core/vcsr.sv \
    $ROOT/./hdl/src/core/wt_ctl.sv \
    $ROOT/./hdl/src/core/wt_mux.sv \
    $ROOT/./hdl/src/core/register_file.sv \
    $ROOT/./hdl/src/core/rf_stack.sv \
    $ROOT/./hdl/src/core/branch_logic.sv \
    $ROOT/./hdl/src/core/alu_a_mux.sv \
    $ROOT/./hdl/src/core/alu_b_mux.sv \
    $ROOT/./hdl/src/core/alu.sv \
    $ROOT/./hdl/src/core/mul.sv \
    $ROOT/./hdl/src/core/mono_timer.sv \
    $ROOT/./hdl/src/core/time_stamp.sv \
    $ROOT/./hdl/src/core/timer.sv \
    $ROOT/./hdl/src/core/stack.sv \
    $ROOT/./hdl/src/core/n_clic.sv \
    $ROOT/./hdl/src/core/wb_mux.sv \
    $ROOT/./hdl/src/core/wb_mem_mux.sv \
    $ROOT/./hdl/src/core/atl_sp_bram.sv \
    $ROOT/./hdl/src/core/xilinx_dp_BRAM.sv \
    $ROOT/./hdl/src/ncobs/atl_sdpram_block.sv \
    $ROOT/./hdl/src/d_mem_spram.sv \
    $ROOT/./hdl/src/ncobs/interleaved_memory.sv \
    $ROOT/./hdl/src/top_arty.sv \
]
add_files -norecurse -fileset [current_fileset] [list \
    $ROOT/./hdl/src/fpga_arty.sv \
]

set_property verilog_define [list \
    TARGET_FPGA \
    TARGET_SYNTHESIS \
    TARGET_VIVADO \
    TARGET_XILINX \
] [current_fileset]

set_property verilog_define [list \
    TARGET_FPGA \
    TARGET_SYNTHESIS \
    TARGET_VIVADO \
    TARGET_XILINX \
] [current_fileset -simset]

