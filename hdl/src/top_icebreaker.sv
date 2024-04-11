// top_n_clic
`timescale 1ns / 1ps

module top_icebreaker
  import icebreaker_pkg::*;
  import decoder_pkg::*;
  import mem_pkg::*;
(
    input logic clk,
    input logic reset,
    input BtnT  btn,

    output logic pb1,
    output logic pb2,
    output logic pb3,
    output logic pb4,
    output logic pb7,
    output logic pb8,
    output logic pb9,
    // output logic pb10,

    output logic led1,
    output logic led2,
    output logic led3,
    output logic led4
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

  // `ifdef VERILATOR
  rom imem (
      // in
      .clk(clk),
      .address(pc_reg_out[IMemAddrWidth-1:0]),
      // out
      .data_out(imem_data_out)
  );
  // `else
  //   rom imem (
  //       // in
  //       .clk(clk),
  //       .address(pc_interrupt_mux_out[IMemAddrWidth-1:0]),
  //       // out
  //       .data_out(imem_data_out)
  //   );
  // `endif

  // decoder
  wb_mux_t decoder_wb_mux_sel;
  alu_a_mux_t decoder_alu_a_mux_sel;
  alu_b_mux_t decoder_alu_b_mux_sel;
  alu_op_t decoder_alu_op;
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
      .wb_write_enable(decoder_wb_write_enable)
  );

  // register file
  word  wb_mux_out;
  word  rf_rs1;
  word  rf_rs2;
  logic n_clic_interrupt_out;
  word  rf_stack_ra;

  PrioT n_clic_level_out;
  rf_stack rf (
      // in
      .clk,
      .reset,
      .writeEn(decoder_wb_write_enable),
      .writeRaEn(n_clic_interrupt_out),
      .level(n_clic_level_out),
      .writeAddr(decoder_rd),
      .writeData(wb_mux_out),
      .readAddr1(decoder_rs1),
      .readAddr2(decoder_rs2),
      // out
      .readData1(rf_rs1),
      .readData2(rf_rs2)
  );

  // branch logic
  branch_logic branch_logic (
      // in
      .a(rf_rs1),
      .b(rf_rs2),
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
      .rs1 (rf_rs1),
      .zero(32'(0)),
      // out
      .out (alu_a_mux_out)
  );

  word alu_b_mux_out;
  alu_b_mux alu_b_mux (
      // in
      .sel      (decoder_alu_b_mux_sel),
      // out
      .rs2      (rf_rs2),
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

  word  dmem_data_out;
  logic dmem_alignment_error;
  mem dmem (
      // in
      .clk(clk),
      .write_enable(decoder_dmem_write_enable),
      .width(decoder_dmem_width),
      .sign_extend(decoder_dmem_sign_extend),
      .address(alu_res[DMemAddrWidth-1:0]),
      .data_in(rf_rs2),
      // out
      .data_out(dmem_data_out),
      .alignment_error(dmem_alignment_error)
  );


  // led
  word csr_led_out;
  word csr_led_direct_out;  // not used
  csr #(
      .CsrWidth(1),  // Number of leds
      .Addr(0)  // LED address
  ) csr_led (
      // in
      .clk,
      .reset,
      .csr_enable(decoder_csr_enable),
      .csr_addr(decoder_csr_addr),
      .rs1_zimm(decoder_rs1),
      .rs1_data(rf_rs1),
      .csr_op(decoder_csr_op),
      .ext_data(0),
      .ext_write_enable(0),
      // out
      .direct_out(csr_led_direct_out),  // not used
      .out(csr_led_out)
  );

  assign led1 = pc_reg_out[2];
  assign led2 = pc_reg_out[3];
  assign led3 = pc_reg_out[4];
  assign led4 = pc_reg_out[5];

  // assign pb1  = pc_reg_out[2];  // csr_led_out[0];
  //   assign pb1  = imem_data_out[0];
  //   assign pb2  = imem_data_out[1];
  //   assign pb3  = imem_data_out[2];
  //   assign pb4  = imem_data_out[3];
  //   assign pb7  = imem_data_out[4];
  //   assign pb8  = imem_data_out[5];
  //   assign pb9  = imem_data_out[6];
  //  assign pb10 = imem_data_out[7];

  assign pb1  = pc_reg_out[2];
  assign pb2  = pc_reg_out[3];
  assign pb3  = pc_reg_out[4];
  assign pb4  = pc_reg_out[5];
  assign pb7  = pc_reg_out[6];
  assign pb8  = pc_reg_out[7];
  assign pb9  = csr_led_out[0];



  word n_clic_csr_out;
  n_clic n_clic (
      // in
      .clk,
      .reset,
      .csr_enable(decoder_csr_enable),
      .csr_addr(decoder_csr_addr),
      .rs1_zimm(decoder_rs1),
      .rs1_data(rf_rs1),
      //.rd(decoder_rd),
      .csr_op(decoder_csr_op),
      .pc_in(pc_branch_mux_out),
      // out
      .csr_out(n_clic_csr_out),
      .int_addr(n_clic_interrupt_addr),
      .pc_interrupt_sel(n_clic_pc_interrupt_sel),
      .level_out(n_clic_level_out),
      .interrupt_out(n_clic_interrupt_out)
  );

  word csr_out;
  // match CSR addresses
  always_comb begin
    csr_out = n_clic_csr_out;
    // TODO: GPIO
    // if (decoder_csr_addr == GpioCsrData) csr_out = csr_gpio_dir_out;
    // else if (decoder_csr_addr == GpioCsrDir) csr_out = csr_gpio_data_out;
    // else csr_out = n_clic_csr_out;
    // // TODO: should we return 0 on reads for non existing CSRs.
    // // Using safe Rust user code, this will never occur so perhaps not then.
  end

  wb_mux wb_mux (
      .sel(decoder_wb_mux_sel),
      .dm(dmem_data_out),
      .alu(alu_res),
      .csr(csr_out),
      .pc_plus_4(32'($signed(pc_adder_out))),  // should we sign extend?
      .out(wb_mux_out)
  );
endmodule
