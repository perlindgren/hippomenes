// top_arty
`timescale 1ns / 1ps

import config_pkg::*;
import arty_pkg::*;
import decoder_pkg::*;
import mem_pkg::*;

module top_arty (
    input  logic clk,
    input  logic reset,
    input  BtnT  btn,
    output LedT  led,
    output logic tx
    // TODO: gpio
);
  IMemAddrT pc_interrupt_mux_out;
  // registers
  IMemAddrT pc_reg_out;
  reg_n #(
      .DataWidth(IMemAddrWidth)
  ) pc_reg (
      .clk(clk),
      .reset(reset),
      .in(pc_interrupt_mux_out),
      .out(pc_reg_out)
  );

  // pc related
  word alu_res;
  pc_branch_mux_t branch_logic_out;
  IMemAddrT pc_adder_out;
  IMemAddrT pc_branch_mux_out;
  pc_branch_mux #(
      .AddrWidth(IMemAddrWidth)
  ) pc_branch_mux (
      .sel(branch_logic_out),
      .pc_next(pc_adder_out),
      .pc_branch(IMemAddrWidth'(alu_res)),
      .out(pc_branch_mux_out)
  );

  IMemAddrT n_clic_interrupt_addr;
  pc_interrupt_mux_t n_clic_pc_interrupt_sel;
  pc_interrupt_mux #(
      .AddrWidth(IMemAddrWidth)
  ) pc_interrupt_mux (
      .sel(n_clic_pc_interrupt_sel),
      .pc_normal(pc_branch_mux_out),
      .pc_interrupt(n_clic_interrupt_addr),
      .out(pc_interrupt_mux_out)
  );

  // adder
  pc_adder #(
      .AddrWidth(IMemAddrWidth)
  ) pc_adder (
      .in (pc_reg_out),
      .out(pc_adder_out)
  );

  // instruction memory
  word imem_data_out;

`ifdef VERILATOR
  rom imem (
      // in
      .clk(clk),
      .address(pc_reg_out[IMemAddrWidth-1:0]),
      // out
      .data_out(imem_data_out)
  );
`else
  spram imem (
      // in
      .clk(clk),
      // used with 1-cycle latency spram read
      .address(pc_interrupt_mux_out[IMemAddrWidth-1:0]),
      // used with combinational 0-cycle latency spram read
      // .address(pc_reg_out[IMemAddrWidth-1:0]),
      .reset,
      // out
      .data_out(imem_data_out)
  );
`endif

  // decoder
  wb_mux_t decoder_wb_mux_sel;
  alu_a_mux_t decoder_alu_a_mux_sel;
  alu_b_mux_t decoder_alu_b_mux_sel;
  alu_op_t decoder_alu_op;
  mul_op_t decoder_mul_op;
  logic decoder_sub_arith;
  word decoder_imm;
  r decoder_rs1;
  r decoder_rs2;

  // mem
  logic decoder_dmem_write_enable;
  logic decoder_dmem_sign_extend;
  mem_width_t decoder_mem_with;

  // branch
  logic decoder_branch_instr;
  branch_op_t decoder_branch_op;
  logic decoder_branch_always;

  // csr
  logic decoder_csr_enable;
  csr_op_t decoder_csr_op;
  CsrAddrT decoder_csr_addr;
  mem_width_t decoder_dmem_width;
  r decoder_rd;

  // write back
  logic decoder_wb_write_enable;

  wb_mem_mux_t decoder_mem_mux_sel_out;
  logic [6:0] op_code;
  decoder decoder (
      // in
      .instr(imem_data_out),
      // out
      .csr_addr(decoder_csr_addr),
      // register file
      .rs1(decoder_rs1),
      .rs2(decoder_rs2),
      .imm(decoder_imm),
      // branch logic
      .branch_always(decoder_branch_always),
      .branch_instr(decoder_branch_instr),
      .branch_op(decoder_branch_op),
      // alu
      .alu_a_mux_sel(decoder_alu_a_mux_sel),
      .alu_b_mux_sel(decoder_alu_b_mux_sel),
      .alu_op(decoder_alu_op),
      .sub_arith(decoder_sub_arith),
      .mul_op(decoder_mul_op),
      // data memory
      .dmem_write_enable(decoder_dmem_write_enable),
      .dmem_sign_extend(decoder_dmem_sign_extend),
      .dmem_width(decoder_dmem_width),
      // csr
      .csr_enable(decoder_csr_enable),
      .csr_op(decoder_csr_op),
      // write back
      .wb_mux_sel(decoder_wb_mux_sel),
      .rd(decoder_rd),
      .wb_write_enable(decoder_wb_write_enable),
      .wb_mem_mux_sel(decoder_mem_mux_sel_out),
      // pmp
      .op_o(op_code)
  );
  csr_op_t vcsr_op;
  CsrAddrT vcsr_addr;
  vcsr_offset_t vcsr_offset;
  vcsr_width_t vcsr_width;
  vcsr vcsr_i (
      .clk,
      .reset,
      .rs1_data(rs1_wt_mux_out),
      .csr_addr(decoder_csr_addr),
      .rs1_zimm(decoder_rs1),
      .csr_enable(csr_enable),
      .csr_op(decoder_csr_op),
      .out_addr(vcsr_addr),
      .out_offset(vcsr_offset),
      .out_width(vcsr_width)
  );
  wt_mux_sel_t wt_ctl_rs1_sel_out;
  wt_mux_sel_t wt_ctl_rs2_sel_out;
  wt_ctl wt_ctl_i (
      .clk,
      .reset,
      .rs1(decoder_rs1),
      .rs2(decoder_rs2),
      .rd(rd_reg_out),
      .writeRaEn(writeRaEn_reg_out),
      .writeEn(we_reg_out),
      .rs1_sel(wt_ctl_rs1_sel_out),
      .rs2_sel(wt_ctl_rs2_sel_out)

  );
  word rf_rs1;
  word rf_rs2;
  word rs1_wt_mux_out;
  word rs2_wt_mux_out;
  wt_mux rs1_wt_mux (
      .sel(wt_ctl_rs1_sel_out),
      .rf_data(rf_rs1),
      .wt_data(wb_mem_mux_out),
      .out(rs1_wt_mux_out)
  );
  wt_mux rs2_wt_mux (
      .sel(wt_ctl_rs2_sel_out),
      .rf_data(rf_rs2),
      .wt_data(wb_mem_mux_out),
      .out(rs2_wt_mux_out)
  );

  // register file
  word  wb_mux_out;
  logic n_clic_interrupt_out;
  word  rf_stack_ra;
  RegT sp;
  PrioT n_clic_level_out;
  rf_stack rf (
      // in
      .clk,
      .reset,
      .writeEn(we_reg_out),
      .writeRaEn(writeRaEn_reg_out),
      .level(n_clic_level_out),
      .writeAddr(rd_reg_out),
      .writeData(wb_mem_mux_out),
      .readAddr1(decoder_rs1),
      .readAddr2(decoder_rs2),
      // out
      .readData1(rf_rs1),
      .readData2(rf_rs2),
      .sp_out(sp)
  );
  logic writeRaEn_reg_out;
  reg_n #(
      .DataWidth(1)
  ) writeRaEn_reg (
      .clk(clk),
      .reset(reset),
      .in(n_clic_interrupt_out),
      .out(writeRaEn_reg_out)
  );
  logic we_reg_out;
  reg_n #(
      .DataWidth(1)
  ) we_reg (
      .clk(clk),
      .reset(reset),
      .in(decoder_wb_write_enable),
      .out(we_reg_out)
  );
  r rd_reg_out;
  reg_n #(
      .DataWidth(5)
  ) rd_reg (
      .clk(clk),
      .reset(reset),
      .in(decoder_rd),
      .out(rd_reg_out)
  );
  // branch logic
  branch_logic branch_logic (
      // in
      .a(rs1_wt_mux_out),
      .b(rs2_wt_mux_out),
      .branch_always(decoder_branch_always),
      .branch_instr(decoder_branch_instr),
      .op(decoder_branch_op),
      // out
      .out(branch_logic_out)
  );

  // Alu related
  word alu_a_mux_out;
  alu_a_mux alu_a_mux (
      // in
      .sel (decoder_alu_a_mux_sel),
      .imm (decoder_imm),
      .rs1 (rs1_wt_mux_out),
      .zero(32'(0)),
      // out
      .out (alu_a_mux_out)
  );

  word alu_b_mux_out;
  alu_b_mux alu_b_mux (
      // in
      .sel      (decoder_alu_b_mux_sel),
      // out
      .rs2      (rs2_wt_mux_out),
      .imm      (decoder_imm),
      .pc_plus_4(32'($signed(pc_adder_out))),  // Should we sign extend?
      .pc       (32'($signed(pc_reg_out))),    //
      .out      (alu_b_mux_out)
  );


  alu alu (
      .a(alu_a_mux_out),
      .b(alu_b_mux_out),
      .sub_arith(decoder_sub_arith),
      .op(decoder_alu_op),
      .res(alu_res)
  );
  word mul_res;
  mul mul (
      .a  (alu_a_mux_out),
      .b  (alu_b_mux_out),
      .op (decoder_mul_op),
      .res(mul_res)
  );

  word  dmem_data_out;
  word  dmem_data;
  logic dmem_alignment_error;
  logic write_enable;
  assign write_enable = decoder_dmem_write_enable && !memory_interrupt;
  d_mem_spram dmem (
      // in
      .clk(clk),
      .reset,
      .addr(alu_res[DMemAddrWidth-1:0]),
      .width(decoder_dmem_width),
      .sign_extend(decoder_dmem_sign_extend),
      .write_enable(write_enable),
      .data_in(rs2_wt_mux_out),
      // out
      //.data_temp(dmem_data_out)
      .data_out(dmem_data_out)
  );

  always_comb begin
    if (memory_interrupt_ff) begin
        dmem_data = '0;
    end else begin
        dmem_data = dmem_data_out;
    end
  end
 
  // led out
  word csr_led_out;
  word csr_led_direct_out;  // currently not used
  csr #(
      .CsrWidth(LedWidth),
      .Addr(LedAddr)
  ) csr_led (
      // in
      .clk,
      .reset,
      .csr_enable(csr_enable),
      .csr_addr(decoder_csr_addr),
      .rs1_zimm(decoder_rs1),
      .rs1_data(rs1_wt_mux_out),
      .csr_op(decoder_csr_op),
      .ext_data(0),
      .ext_write_enable(0),
      // out
      .direct_out(csr_led_direct_out),
      .out(csr_led_out),
      .vcsr_addr(vcsr_addr),
      .vcsr_width(vcsr_width),
      .vcsr_offset(vcsr_offset)
  );
  assign led = LedT'(csr_led_out[LedWidth-1:0]);
  // assign rx = csr_led_out[LedWidth-1];  //last pin is RX

  // Button input
  word csr_btn_out;
  word csr_btn_direct_out;  // currently not used
  csr #(
      .CsrWidth(BtnWidth),
      .Addr(BtnAddr),
      .Write(0)  // only readable register
  ) csr_btn (
      // in
      .clk,
      .reset,
      .csr_enable(csr_enable),
      .csr_addr(decoder_csr_addr),
      .rs1_zimm(decoder_rs1),
      .rs1_data(rs1_wt_mux_out),
      .csr_op(decoder_csr_op),
      .ext_data(0),
      .ext_write_enable(0),
      // out
      .direct_out(csr_btn_direct_out),
      .out(csr_btn_out),

      .vcsr_addr  (vcsr_addr),
      .vcsr_width (vcsr_width),
      .vcsr_offset(vcsr_offset)
  );
  assign csr_btn.data = btn;


  // TODO: GPIO
  //   word csr_gpio_dir_out;
  //   word csr_gpio_direct_out;  // not used
  //   assign gpio_dir = GpioT'(csr_gpio_dir_out);
  //   csr #(
  //       .CsrWidth(GpioNum),  // Number of GPIOs
  //       .Addr(GpioCsrDir)  // Direction register
  //   ) csr_gpio_dir (
  //       // in
  //       .clk,
  //       .reset,
  //       .csr_enable(csr_enable),
  //       .csr_addr(decoder_csr_addr),
  //       .rs1_zimm(decoder_rs1),
  //       .rs1_data(rf_rs1),
  //       .csr_op(decoder_csr_op),
  //       .ext_data(0),
  //       .ext_write_enable(0),
  //       // out
  //       .direct_out(csr_gpio_direct_out),  // not used
  //       .out(csr_gpio_dir_out)
  //   );

  //   word csr_gpio_data_out;
  //   csr_gpio csr_gpio_data (
  //       // in
  //       .clk,
  //       .reset,
  //       .csr_enable(csr_enable),
  //       .csr_addr(decoder_csr_addr),
  //       .rs1_zimm(decoder_rs1),
  //       .rs1_data(rf_rs1),
  //       .csr_op(decoder_csr_op),
  //       .ext_data(0),
  //       .ext_write_enable(0),
  //       .direction(GpioT'(csr_gpio_dir_out)),
  //       // out
  //       .out(csr_gpio_data_out),
  //       // gpi
  //       .gpio_in,
  //       .gpio_out
  //   );

  word n_clic_csr_out;
  logic [7:0] n_clic_int_id_out;
  logic [7:0] n_clic_int_prio_out;
  logic n_clic_tail_chain_out;
  n_clic n_clic (
      // in
      .clk,
      .reset,
      .csr_enable(csr_enable),
      .csr_addr(decoder_csr_addr),
      .rs1_zimm(decoder_rs1),
      .rs1_data(rs1_wt_mux_out),
      .interrupt_in(memory_interrupt),
      //.rd(decoder_rd),
      .csr_op(decoder_csr_op),
      .pc_in(pc_branch_mux_out),
      // out
      .csr_out(n_clic_csr_out),
      .int_addr(n_clic_interrupt_addr),
      .pc_interrupt_sel(n_clic_pc_interrupt_sel),
      .level_out(n_clic_level_out),
      .int_prio(n_clic_int_prio_out),
      .int_id(n_clic_int_id_out),
      .interrupt_out(n_clic_interrupt_out),
      .vcsr_addr(vcsr_addr),
      .vcsr_width(vcsr_width),
      .vcsr_offset(vcsr_offset),
      .tail_chain(n_clic_tail_chain_out)
  );

  word d_in;
  logic uart_next;
  logic [7:0] fifo_data_out;
  word fifo_csr_data_out;
  logic fifo_have_next_out;
  MonoTimerT mono_timer_out;
  logic [FifoEntryWidthBits-1:0] enc_write_data_out;
  logic [FifoEntryWidthSize:0] enc_write_width_out;
  logic enc_write_enable_out;
  logic uart_ack_out;
  mono_timer timer (
      .clk(clk),
      .reset(reset),
      .mono_timer(mono_timer_out)
  );
  n_cobs_encoder enc (
      .clk_i(clk),
      .reset_i(reset),
      .csr_enable(csr_enable),
      .csr_addr(decoder_csr_addr),
      .timer(mono_timer_out),

      .id(n_clic_int_id_out),
      .rs1_data(rs1_wt_mux_out),

      .level(n_clic_int_prio_out),
      .write_data(enc_write_data_out),
      .write_width(enc_write_width_out),
      .write_enable(enc_write_enable_out),
      .tail_chain(n_clic_tail_chain_out)
  );
  fifo_interleaved fifo_i (
      .clk_i  (clk),
      .reset_i(reset),

      .write_enable(enc_write_enable_out),
      .write_data  (enc_write_data_out),
      .write_width (enc_write_width_out),


      .ack(uart_ack_out),
      .data(fifo_data_out),
      .have_next(fifo_have_next_out)
  );
  uart i_uart (
      .clk_i(clk),
      .reset_i(reset),
      .prescaler(0),
      .d_in(fifo_data_out),
      .rts(fifo_have_next_out),
      .tx,
      .next(uart_ack_out)
  );

  word csr_out;
  // match CSR addresses
  always_comb begin
    // TODO: for now only btn
    case (decoder_csr_addr)
      BtnAddr: csr_out = csr_btn_out;
      default: csr_out = 0;
    endcase
  end


  wb_mux wb_mux (
      .sel(decoder_wb_mux_sel),
      .alu(alu_res),
      .csr(n_clic_csr_out),
      .pc_plus_4(32'($signed(pc_adder_out))),  // should we sign extend?
      .mul(mul_res),
      .out(wb_mux_out)
  );
  word wb_mux_reg_out;
  reg_n #(
      .DataWidth(32)
  ) wb_mux_reg (
      .clk(clk),
      .reset(reset),
      .in(wb_mux_out),
      .out(wb_mux_reg_out)
  );

  logic mem_mux_sel_reg_out;
  reg_n #(
      .DataWidth(1)
  ) mem_mux_sel_reg (
      .clk(clk),
      .reset(reset),
      .in(decoder_mem_mux_sel_out),
      .out(mem_mux_sel_reg_out)
  );


  word wb_mem_mux_out;
  wb_mem_mux wb_mem_mux_i (
      .sel(mem_mux_sel_reg_out),
      .other_data(wb_mux_reg_out),
      .memory_data(dmem_data),
      .out(wb_mem_mux_out)
  );
    
  logic memory_interrupt;
  logic memory_interrupt_ff;
  mpu mpu (
    .clk(clk),
    .reset(reset),
    
    .mem_address(alu_res), 
    .sp(sp),
    .op(op_code),
    .interrupt_prio(n_clic_int_prio_out),
    .id(n_clic_int_id_out),


    //csr
    .csr_enable(csr_enable),
    .csr_addr(decoder_csr_addr),
    .rs1_zimm(decoder_rs1),
    .rs1_data(rs1_wt_mux_out),
    .csr_op(decoder_csr_op),

    // VSCR
    .vcsr_addr(vcsr_addr),
    .vcsr_width(vcsr_width),
    .vcsr_offset(vcsr_offset),
    
    //out
    .mem_fault_out(memory_interrupt),
    .mem_fault_out_ff(memory_interrupt_ff)
  );
logic csr_enable;
csr_block csr_block(
    .clk(clk),
    .reset(reset),
    
    //csr
    .csr_enable(decoder_csr_enable),
    .csr_addr(decoder_csr_addr),
    .rs1_zimm(decoder_rs1),
    .rs1_data(rs1_wt_mux_out),
    .csr_op(decoder_csr_op),

    // VSCR
    .vcsr_addr(vcsr_addr),
    .vcsr_width(vcsr_width),
    .vcsr_offset(vcsr_offset),
    
    .csr_enable_out(csr_enable)
);
endmodule
