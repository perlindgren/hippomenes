// tb_top test bench

module tb_top;
  import config_pkg::*;
  import decoder_pkg::*;

  reg  clk;
  reg  reset;

  word dummy;

  // registers
  word pc_reg_out;
  reg_n pc_reg (
      .clk(clk),
      .reset(reset),
      .in(pc_adder_out),
      .out(pc_reg_out)
  );

  word wb_data_reg_out;
  reg_n wb_data_reg (
      .clk(clk),
      .reset(reset),
      .in(wb_mux_out),
      .out(wb_data_reg_out)
  );

  // 5 bit register
  r wb_rd_reg_out;
  reg_n #(
      .DataWidth(5)
  ) wb_rd_reg (
      .clk(clk),
      .reset(reset),
      .in(decoder_rd),
      .out(wb_rd_reg_out)
  );

  reg wb_enable_reg_out;
  reg_n #(
      .DataWidth(1)
  ) wb_write_enable_reg (
      .clk(clk),
      .reset(reset),
      .in(decoder_wb_write_enable),
      .out(wb_enable_reg_out)
  );

  // pc related
  word pc_mux_out;
  pc_mux pc_mux (
      .sel(branch_logic_out),
      .pc_next(pc_adder_out),
      .pc_branch(alu_res),
      .out(pc_mux_out)
  );

  // adder
  word pc_adder_out;
  pc_adder pc_adder (
      .in (pc_reg_out),
      .out(pc_adder_out)
  );

  // instruction memory
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

  // decoder
  wb_mux_t decoder_wb_mux_sel;
  reg decoder_wb_write_enable;
  alu_a_mux_t decoder_alu_a_mux_sel;
  alu_b_mux_t decoder_alu_b_mux_sel;
  alu_op_t decoder_alu_op;
  reg decoder_sub_arith;
  word decoder_imm;
  r decoder_rs1;
  r decoder_rs2;
  r decoder_rd;
  reg decoder_dmem_write_enable;
  reg decoder_branch_instr;
  branch_op_t decoder_branch_op;
  // csr_t decoder_csr_op;
  reg decoder_csr_enable;

  decoder decoder (
      // in
      .instr(imem_data_out),
      // out
      //   // pc
      //   .pc_mux_sel(decoder_pc_mux_sel),
      // register files
      .rs1(decoder_rs1),
      .rs2(decoder_rs2),
      .imm(decoder_imm),
      // branch logic
      .branch_instr(decoder_branch_instr),
      .branch_op(decoder_branch_op),
      // alu
      .alu_a_mux_sel(decoder_alu_a_mux_sel),
      .alu_b_mux_sel(decoder_alu_b_mux_sel),
      .alu_op(decoder_alu_op),
      .sub_arith(decoder_sub_arith),
      // data memory
      .dmem_write_enable(decoder_dmem_write_enable),
      // csr
      .csr_enable(decoder_csr_enable),
      // write back
      .wb_mux_sel(decoder_wb_mux_sel),
      .rd(decoder_rd),
      .wb_write_enable(decoder_wb_write_enable)
  );

  // register file
  word rf_rs1;
  word rf_rs2;
  RegisterFile rf (
      // in
      .clk(clk),
      .reset(reset),
      .writeEn(wb_enable_reg_out),
      .writeAddr(wb_rd_reg_out),
      .writeData(wb_data_reg_out),
      .readAddr1(decoder_rs1),
      .readAddr2(decoder_rs2),
      // out
      .readData1(rf_rs1),
      .readData2(rf_rs2)
  );

  // branch logic
  branch_op_t branch_logic_out;
  branch_logic branch_logic (
      // in
      .a(rf_rs1),
      .b(rf_rs2),
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
      .sel(decoder_alu_b_mux_sel),
      // out
      .rs2(rf_rs2),
      .imm(decoder_imm),
      .pc_plus_4(pc_adder_out),
      .pc(pc_reg_out),
      .out(alu_b_mux_out)
  );

  word alu_res;
  alu alu (
      .a(alu_a_mux_out),
      .b(alu_b_mux_out),
      .sub_arith(decoder_sub_arith),
      .op(decoder_alu_op),
      .res(alu_res)
  );

  word dmem_data_out;
  reg  dmem_alignment_error;
  mem dmem (
      // in
      .clk(clk),
      .write_enable(decoder_dmem_write_enable),
      .width(mem_pkg::WORD),  // TODO
      .sign_extend(0),  // TODO
      .address(alu_res[DMemAddrWidth-1:0]),
      .data_in(rf_rs2),
      // out
      .data_out(dmem_data_out),
      .alignment_error(dmem_alignment_error)
  );

  word csr_old;
  csr csr (
      // in
      .clk(clk),
      .reset(reset),
      .en(decoder_csr_enable),
      .rs1(decoder_rs1),
      .rd(decoder_rd),
      .op(csr_t'(decoder_rs2)),
      .in(alu_res),
      // out
      .old(csr_old)
  );

  word wb_mux_out;
  wb_mux wb_mux (
      .sel(decoder_wb_mux_sel),
      .dm (dmem_data_out),
      .alu(alu_res),
      .csr(csr_old),
      .out(wb_mux_out)
  );

  // clock and reset
  initial begin
    $display($time, " << Starting the Simulation >>");

    // notice raw access to memory is in words
    imem.mem[0] = 'h50000117;  // auipc   sp,0x50000
    imem.mem[1] = 'h50010113;  // addi    sp,sp,1280 # 50000500
    imem.mem[2] = 'h35015073;  // CSR
    imem.mem[3] = 'h01000337;  // lui     t1,0x1000
    imem.mem[4] = 'h10030313;  // addi    t1,t1,256 # 1000100
    imem.mem[5] = 'h020003b7;  // lui     t2,0x2000
    imem.mem[6] = 'h10038393;  // addi    t2,t2,256 # 2000100
    imem.mem[7] = 'h03000e37;  // lui     t3,0x3000
    imem.mem[8] = 'h100e0e13;  // addi    t3,t3,256 # 3000100
    imem.mem[9] = 'h04000eb7;  // lui     t4,0x4000
    imem.mem[10] = 'h100e8e93;  // addi    t4,t4,256 # 4000100
    imem.mem[11] = 'h05000f37;  // lui     t5,0x5000
    imem.mem[12] = 'h100f0f13;  // addi    t5,t5,256 # 5000100
    imem.mem[13] = 'h06000fb7;  // lui     t6,0x6000
    imem.mem[14] = 'h100f8f93;  // addi    t6,t6,256 # 6000100
    imem.mem[15] = 'h070005b7;  // lui     a1,0x7000
    imem.mem[16] = 'h10058593;  // addi    a1,a1,256 # 7000100
    imem.mem[17] = 'h08000637;  // lui     a2,0x8000
    imem.mem[18] = 'h10060613;  // addi    a2,a2,256 # 8000100
    imem.mem[19] = 'h090006b7;  // lui     a3,0x9000
    imem.mem[20] = 'h10068693;  // addi    a3,a3,256 # 9000100
    imem.mem[21] = 'hb0131073;  // csrrw   b01, t1, zero
    imem.mem[22] = 'hb0239073;  // csrrw   b02, t2, zero
    imem.mem[23] = 'hb03e1073;  // csrrw   b03, t3, zero
    imem.mem[24] = 'hb04e9073;  // csrrw   b04, t4, zero
    imem.mem[25] = 'hb05f1073;  // csrrw   b05, t5, zero
    imem.mem[26] = 'hb06f9073;  // csrrw   b06, t6, zero
    imem.mem[27] = 'hb0759073;  // csrrw   b07, a1, zero
    imem.mem[28] = 'hb0861073;  // csrrw   b08, a2, zero
    imem.mem[29] = 'hb0969073;  // csrrw   b09, a3, zero
    imem.mem[30] = 'h00005337;  // lui     t1,0x5
    imem.mem[31] = 'h00830313;  // addi    t1,t1,8 # 5008
    imem.mem[32] = 'h03200393;  // li      t2,50
    imem.mem[33] = 'h00732023;  // sw      t2,0(t1)

    // just to force update mem
    imem.mem[34] = 'hb0969073;  // csrrw   b09, a3, zero


    reset = 1;
    clk = 0;
    #5 reset = 0;
  end

  always #10 clk = ~clk;

  initial begin
    $dumpfile("top.fst");
    $dumpvars;

    #10;  // auipc   sp,0x50000
    $warning("auipc   sp,0x50000");
    $display("rf_rs1 %h rf_rs2 %h", rf_rs1, rf_rs2);
    $display("wb_data_reg.in %h", wb_data_reg.in);
    assert (pc_reg.out == 0);
    assert (wb_data_reg.in == 'h5000_0000);
    assert (wb_rd_reg.in == 2);  // sp
    assert (wb_write_enable_reg.in == 1);  // should write to rf

    #20;  // addi sp,sp,1280 # 50000500 // sign ext
    $warning("addi sp,sp,1280 # 50000500");
    $display("rf_rs1 %h rf_rs2 %h", rf_rs1, rf_rs2);
    $display("wb_data_reg.in %h", wb_data_reg.in);

    assert (pc_reg.out == 4);
    assert (wb_data_reg.in == 'h5000_0500);
    assert (wb_rd_reg.in == 2);  // sp
    assert (wb_write_enable_reg.in == 1);  // should write to rf

    #20;  // csrrw 350 2 zero
    $warning("csrrw 350 2 zero");
    $display("rf_rs1 %h rf_rs2 %h", rf_rs1, rf_rs2);
    assert (pc_reg.out == 8);

    #20;  // lui     t1,0x1000
    $warning("lui t1,0x1000");
    $display("rf_rs1 %h rf_rs2 %h", rf_rs1, rf_rs2);
    $display("alu %h", alu.res);
    assert (pc_reg.out == 12);

    #20;  //  addi    t1,t1,256 # 1000100
    $warning("addi t1,t1,256 # 1000100");
    $display("rf_rs1 %h rf_rs2 %h", rf_rs1, rf_rs2);
    $display("alu %h", alu.res);
    assert (pc_reg.out == 16);

    #20;  //  lui     t2,0x2000
    $warning("lui t2,0x2000");
    $display("rf_rs1 %h rf_rs2 %h", rf_rs1, rf_rs2);
    $display("alu %h", alu.res);
    assert (pc_reg.out == 20);

    #20;  //  addi    t2,t2,256 # 2000100
    $warning("addi  t2,t2,256 # 2000100");
    $display("rf_rs1 %h rf_rs2 %h", rf_rs1, rf_rs2);
    $display("alu %h", alu.res);
    assert (pc_reg.out == 24);

    #20;  //  lui     t3,0x3000
    $warning("lui     t3,0x3000");
    $display("rf_rs1 %h rf_rs2 %h", rf_rs1, rf_rs2);
    $display("alu %h", alu.res);
    assert (pc_reg.out == 28);

    #20;  //  addi    t3,t3,256 # 3000100
    $warning("addi    t3,t3,256 # 3000100");
    $display("rf_rs1 %h rf_rs2 %h", rf_rs1, rf_rs2);
    $display("alu %h", alu.res);
    assert (pc_reg.out == 32);

    #20;  //  lui     t4,0x4000
    $warning("lui     t4,0x4000");
    $display("rf_rs1 %h rf_rs2 %h", rf_rs1, rf_rs2);
    $display("alu %h", alu.res);
    assert (pc_reg.out == 36);

    #20;  //  addi    t4,t4,256 # 4000100
    $warning("addi    t4,t4,256 # 40001000");
    $display("rf_rs1 %h rf_rs2 %h", rf_rs1, rf_rs2);
    $display("alu %h", alu.res);
    assert (pc_reg.out == 40);

    #20;  //  lui     t5,0x5000
    $warning("lui     t5,0x5000");
    $display("rf_rs1 %h rf_rs2 %h", rf_rs1, rf_rs2);
    $display("alu %h", alu.res);
    assert (pc_reg.out == 44);

    #20;  //  addi    t5,t5,256 # 5000100
    $warning("addi    t5,t5,256 # 5000100");
    $display("rf_rs1 %h rf_rs2 %h", rf_rs1, rf_rs2);
    $display("alu %h", alu.res);
    assert (pc_reg.out == 48);

    #20;  //  lui     t6,0x6000
    $warning("lui     t6,0x6000");
    $display("rf_rs1 %h rf_rs2 %h", rf_rs1, rf_rs2);
    $display("alu %h", alu.res);
    assert (pc_reg.out == 52);

    #20;  //  addi    t6,t6,256 # 6000100
    $warning("addi    t6,t6,256 # 60001000");
    $display("rf_rs1 %h rf_rs2 %h", rf_rs1, rf_rs2);
    $display("alu %h", alu.res);
    assert (pc_reg.out == 56);

    #20;  //  lui     a0,0x7000
    $warning("lui     a0,0x7000");
    $display("rf_rs1 %h rf_rs2 %h", rf_rs1, rf_rs2);
    $display("alu %h", alu.res);
    assert (pc_reg.out == 60);

    #20;  //  addi    a0,a0,256 # 7000100
    $warning("addi    a0,a0,256 # 7000100");
    $display("rf_rs1 %h rf_rs2 %h", rf_rs1, rf_rs2);
    $display("alu %h", alu.res);
    assert (pc_reg.out == 64);

    #20;  //  lui     a1,0x8000
    $warning("lui     a1,0x8000");
    $display("rf_rs1 %h rf_rs2 %h", rf_rs1, rf_rs2);
    $display("alu %h", alu.res);
    assert (pc_reg.out == 17 * 4);

    #20;  //  addi    a1,a1,256 # 8000100
    $warning("addi    a1,a1,256 # 8000100");
    $display("rf_rs1 %h rf_rs2 %h", rf_rs1, rf_rs2);
    $display("alu %h", alu.res);
    assert (pc_reg.out == 18 * 4);

    #20;  //  lui     a3,0x9000
    $warning("lui     a3,0x9000");
    $display("rf_rs1 %h rf_rs2 %h", rf_rs1, rf_rs2);
    $display("alu %h", alu.res);
    assert (pc_reg.out == 19 * 4);

    #20;  //  addi    a3,a3,256 # 9000100
    $warning("addi    a3,a3,256 # 90001000");
    $display("rf_rs1 %h rf_rs2 %h", rf_rs1, rf_rs2);
    $display("alu %h", alu.res);
    assert (pc_reg.out == 20 * 4);

    #20;  //  csrrw   b01, t1, zero
    $warning("csrrw   b01, t1, zero");
    $display("rf_rs1 %h rf_rs2 %h", rf_rs1, rf_rs2);
    $display("alu %h", alu.res);
    assert (pc_reg.out == 21 * 4);

    #20;  //  csrrw   b02, t2, zero
    $warning("csrrw   b02, t2, zero");
    $display("rf_rs1 %h rf_rs2 %h", rf_rs1, rf_rs2);
    $display("alu %h", alu.res);
    assert (pc_reg.out == 22 * 4);

    #20;  // csrrw   b03, t3, zero
    $warning("csrrw   b03, t2, zero");
    $display("rf_rs1 %h rf_rs2 %h", rf_rs1, rf_rs2);
    $display("alu %h", alu.res);
    assert (pc_reg.out == 23 * 4);

    #20;  // csrrw   b04, t4, zero
    $warning("csrrw   b04, t2, zero");
    $display("rf_rs1 %h rf_rs2 %h", rf_rs1, rf_rs2);
    $display("alu %h", alu.res);
    assert (pc_reg.out == 24 * 4);

    #20;  //  csrrw   b05, t5, zero
    $warning("csrrw   b02, t2, zero");
    $display("rf_rs1 %h rf_rs2 %h", rf_rs1, rf_rs2);
    $display("alu %h", alu.res);
    assert (pc_reg.out == 25 * 4);

    #20;  //  csrrw   b06, t6, zero
    $warning("csrrw   b06, t6, zero");
    $display("rf_rs1 %h rf_rs2 %h", rf_rs1, rf_rs2);
    $display("alu %h", alu.res);
    assert (pc_reg.out == 26 * 4);

    #20;  //  csrrw   b07, a1, zero
    $warning("csrrw   b07, t2, zero");
    $display("rf_rs1 %h rf_rs2 %h", rf_rs1, rf_rs2);
    $display("alu %h", alu.res);
    assert (pc_reg.out == 27 * 4);

    #20;  //  csrrw   b08, a2, zero
    $warning("csrrw   b08, a2, zero");
    $display("rf_rs1 %h rf_rs2 %h", rf_rs1, rf_rs2);
    $display("alu %h", alu.res);
    assert (pc_reg.out == 28 * 4);

    #20;  //  csrrw   b09, a3, zero
    $warning("csrrw   b09, a3, zero");
    $display("rf_rs1 %h rf_rs2 %h", rf_rs1, rf_rs2);
    $display("alu %h", alu.res);
    assert (pc_reg.out == 29 * 4);

    $display("---   rf[t1 6] %h", rf.regs[6]);

    #20;  //  lui     t1,0x5
    $warning("lui     t1,0x5");
    $display("rf_rs1 %h rf_rs2 %h", rf_rs1, rf_rs2);
    $display("alu %h", alu.res);
    assert (pc_reg.out == 30 * 4);

    #20;  //  addi    t1,t1,8 # 5008
    $warning("addi    t1,t1,8 # 5008");
    $display("rf_rs1 %h rf_rs2 %h", rf_rs1, rf_rs2);
    $display("alu %h", alu.res);
    assert (pc_reg.out == 31 * 4);

    #20;  //  li      t2,50
    $warning("li      t2,50");
    $display("rf_rs1 %h rf_rs2 %h", rf_rs1, rf_rs2);
    $display("alu %h", alu.res);
    assert (pc_reg.out == 32 * 4);

    #20;  //  sw      t2,0(t1)
    $warning("sw      t2,0(t1)");
    $display("rf_rs1 %h rf_rs2 %h", rf_rs1, rf_rs2);
    $display("alu %h", alu.res);
    assert (pc_reg.out == 33 * 4);

    #20;  // --- nop ---

    assert (pc_reg.out == 34 * 4);
    // dump registers
    $display("rf[t1 6] %h", rf.regs[6]);
    $display("rf[t2 7] %h", rf.regs[7]);
    $display("rf[t3 28] %h", rf.regs[28]);
    $display("rf[t4 29] %h", rf.regs[29]);
    $display("rf[t5 30] %h", rf.regs[30]);
    $display("rf[t6 31] %h", rf.regs[31]);
    $display("rf[a1 11] %h", rf.regs[11]);
    $display("rf[a2 12] %h", rf.regs[12]);
    $display("rf[a3 13] %h", rf.regs[13]);

    // dump csr
    $display("csr %h", csr.data);

    $display("dmem.mem[5008] %h", dmem.mem[0008]);

    $finish;
  end

endmodule
