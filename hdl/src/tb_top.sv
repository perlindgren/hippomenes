// top module

module tb_top;
  import config_pkg::*;
  import decoder_pkg::*;

  reg  clk;
  reg  reset;

  // registers
  word pc_reg_out;
  // reg_n pc_reg (
  //     .clk(clk),
  //     .reset(reset),
  //     .in(pc_reg_in),
  //     .out(pc_reg_out)
  // );

  word wb_data_reg_out;
  // reg_n wb_data_reg (
  //     .clk(clk),
  //     .reset(reset),
  //     .in(wb_data_reg_in),
  //     .out(wb_data_reg_out)
  // );

  word wb_reg_reg_out;
  // reg_n wb_reg_reg (
  //     .clk(clk),
  //     .reset(reset),
  //     .in(wb_reg_reg_in),
  //     .out(wb_reg_reg_out)
  // );

  word wb_enable_reg_out;
  // reg_n wb_enable_reg (
  //     .clk(clk),
  //     .reset(reset),
  //     .in(wb_enable_reg_in),
  //     .out(wb_enable_reg_out)
  // );

  // pc related
  word pc_mux_out;
  // pc_mux pc_mux (
  //     .sel(pc_mux_sel),
  //     .pc_next(pc_mux_pc_next),
  //     .pc_branch(pc_mux_branch),
  //     .out(pc_mux_out)
  // );

  word pc_adder_out;
  // pc_adder pc_adder (
  //     .in (pc_adder_in),
  //     .out(pc_adder_out)
  // );

  // Alu related
  word alu_a_mux_out;
  // alu_a_mux alu_a_mux (
  //     .sel (alu_a_sel),
  //     .imm (alu_a_imm),
  //     .rs1 (alu_a_rs1),
  //     .zero(32'(0)),
  //     .out (alu_a_mux_out)
  // );

  word alu_b_mux_out;
  // alu_b_mux alu_b_mux (
  //     // in
  //     .sel(alu_b_mux_sel),
  //     // out
  //     .rs2(alu_b_mux_rs2),
  //     .imm(alu_b_mux_imm),
  //     .pc_plus_4(alu_b_mux_pc_plus_4),
  //     .pc(alu_b_mux_pc),
  //     .out(alu_b_mux_out)
  // );

  word imem_data_out;
  reg  imem_alignment_error;
  mem imem (
      // in
      .clk(clk),
      .write_enable(0),  // we never write to instruction memory
      .width(mem_pkg::WORD),  // always read words
      .sign_extend(0),  // not used
      .address(pc_reg_out[IMemAddrWidth-1:0]),
      .data_in(0),
      // out
      .data_out(imem_data_out),
      .alignment_error(imem_alignment_error)
  );

  word dmem_data_out;
  reg  dmem_alignment_error;
  // mem dmem (
  //     // in
  //     .clk(clk),
  //     .write_enable(0),  // we never write to instruction memory
  //     .width(mem_pkg::WORD),  // always read words
  //     .sign_extend(0),  // not used
  //     .address(pc_imem),
  //     .data_in(0),
  //     // out
  //     .data_out(dmem_data_out),
  //     .alignment_error(dmem_alignment_error)
  // );

  wire decoder_pc_mux_sel;
  wire decoder_wb_data_mux_sel;
  wire decoder_wb_reg;
  wire decoder_wb_enable;
  wire decoder_alu_a_mux_sel;
  wire decoder_alu_b_mux_sel;
  // decoder decoder (
  //     // in
  //     .instr(instr),
  //     // out
  //     .pc_mux_sel(decoder_pc_mux_sel),
  //     .wb_data_mux_sel(decoder_wb_data_mux_sel),
  //     .wb_reg(decoder_wb_reg),
  //     .wb_enable(decoder_wb_enable),
  //     .alu_a_mux_sel(decoder_alu_a_mux_sel),
  //     .alu_b_mux_sel(decoder_alu_b_mux_sel)
  // );

  wire wb_mux_out;
  // wb_mux wb_mux (
  //     .sel(decoder.wb_data_mux_sel),
  //     .dm (dmem.data_out),
  //     .alu(alu.out),
  //     .out(wb_mux_out)
  // );

  // clock and reset
  initial begin
    $display($time, " << Starting the Simulation >>");

    // notice raw access to memory is in words
    imem.mem[0] = 'h50000117;  // LUI
    imem.mem[1] = 'h50010113;  // ADDI
    imem.mem[2] = 'h35015073;  // CSR
    imem.mem[3] = 'h01000337;  // lui     t1,0x1000

    reset = 1;
    clk = 0;
    #5 reset = 0;
  end

  always #10 clk = ~clk;

  initial begin
    $dumpfile("top.fst");
    $dumpvars;

    // #10;

    #100 $finish;
  end

endmodule
