// tb_top
`timescale 1ns / 1ps

module tb_top;
  import config_pkg::*;
  import decoder_pkg::*;

  logic clk;
  logic reset;
  logic led;

  top top (
      .clk  (clk),
      .reset(reset),
      .led  (led)
  );

  // clock and reset
  initial begin
    $display($time, " << Starting the Simulation >>");

    // notice raw access to memory is in words
    top.imem.mem[0] = 'h50000117;  // auipc   sp,0x50000
    top.imem.mem[1] = 'h50010113;  // addi    sp,sp,1280 # 50000500
    top.imem.mem[2] = 'h35015073;  // CSR
    top.imem.mem[3] = 'h01000337;  // lui     t1,0x1000
    top.imem.mem[4] = 'h10030313;  // addi    t1,t1,256 # 1000100
    top.imem.mem[5] = 'h020003b7;  // lui     t2,0x2000
    top.imem.mem[6] = 'h10038393;  // addi    t2,t2,256 # 2000100
    top.imem.mem[7] = 'h03000e37;  // lui     t3,0x3000
    top.imem.mem[8] = 'h100e0e13;  // addi    t3,t3,256 # 3000100
    top.imem.mem[9] = 'h04000eb7;  // lui     t4,0x4000
    top.imem.mem[10] = 'h100e8e93;  // addi    t4,t4,256 # 4000100
    top.imem.mem[11] = 'h05000f37;  // lui     t5,0x5000
    top.imem.mem[12] = 'h100f0f13;  // addi    t5,t5,256 # 5000100
    top.imem.mem[13] = 'h06000fb7;  // lui     t6,0x6000
    top.imem.mem[14] = 'h100f8f93;  // addi    t6,t6,256 # 6000100
    top.imem.mem[15] = 'h070005b7;  // lui     a1,0x7000
    top.imem.mem[16] = 'h10058593;  // addi    a1,a1,256 # 7000100
    top.imem.mem[17] = 'h08000637;  // lui     a2,0x8000
    top.imem.mem[18] = 'h10060613;  // addi    a2,a2,256 # 8000100
    top.imem.mem[19] = 'h090006b7;  // lui     a3,0x9000
    top.imem.mem[20] = 'h10068693;  // addi    a3,a3,256 # 9000100
    top.imem.mem[21] = 'hb0131073;  // csrrw   b01, t1, zero
    top.imem.mem[22] = 'hb0239073;  // csrrw   b02, t2, zero
    top.imem.mem[23] = 'hb03e1073;  // csrrw   b03, t3, zero
    top.imem.mem[24] = 'hb04e9073;  // csrrw   b04, t4, zero
    top.imem.mem[25] = 'hb05f1073;  // csrrw   b05, t5, zero
    top.imem.mem[26] = 'hb06f9073;  // csrrw   b06, t6, zero
    top.imem.mem[27] = 'hb0759073;  // csrrw   b07, a1, zero
    top.imem.mem[28] = 'hb0861073;  // csrrw   b08, a2, zero
    top.imem.mem[29] = 'hb0969073;  // csrrw   b09, a3, zero
    top.imem.mem[30] = 'h00005337;  // lui     t1,0x5
    top.imem.mem[31] = 'h00830313;  // addi    t1,t1,8 # 5008
    top.imem.mem[32] = 'h03200393;  // li      t2,50
    top.imem.mem[33] = 'h00732023;  // sw      t2,0(t1)

    // just to force update mem
    top.imem.mem[34] = 'hb0969073;  // csrrw   b09, a3, zero

    reset = 1;
    clk = 0;
    #15 reset = 0;
  end

  always #10 clk = ~clk;

  initial begin
    $dumpfile("top.fst");
    $dumpvars;
    $display("vals: %h, %h, ", top.imem.mem[0], top.imem.mem[1]);
    #30;  // auipc   sp,0x50000

    $warning("auipc   sp,0x50000");
    $display("rf_rs1 %h rf_rs2 %h", top.rf_rs1, top.rf_rs2);
    $display("wb_data_reg.in %h", top.wb_data_reg.in);
    assert (top.pc_reg.out == 0) $display("ok"); else $warning("fail");
    assert (top.wb_data_reg.in == 'h5000_0000) $display("ok"); else $warning("fail %d", top.wb_data_reg.in);
    assert (top.wb_rd_reg.in == 2) $display("ok"); else $warning("fail");  // sp
    assert (top.wb_write_enable_reg.in == 1) $display("ok"); else $warning("fail");  // should write to rf

    #20;  // addi sp,sp,1280 # 50000500 // sign ext
    $warning("addi sp,sp,1280 # 50000500");
    $display("rf_rs1 %h rf_rs2 %h", top.rf_rs1, top.rf_rs2);
    $display("wb_data_reg.in %h", top.wb_data_reg.in);

    assert (top.pc_reg.out == 4);
    assert (top.wb_data_reg.in == 'h5000_0500);
    assert (top.wb_rd_reg.in == 2);  // sp
    assert (top.wb_write_enable_reg.in == 1);  // should write to rf

    #20;  // csrrw 350 2 zero
    $warning("csrrw 350 2 zero");
    $display("rf_rs1 %h rf_rs2 %h", top.rf_rs1, top.rf_rs2);
    assert (top.pc_reg.out == 8);

    #20;  // lui     t1,0x1000
    $warning("lui t1,0x1000");
    $display("rf_rs1 %h rf_rs2 %h", top.rf_rs1, top.rf_rs2);
    $display("alu %h", top.alu.res);
    assert (top.pc_reg.out == 12);

    #20;  //  addi    t1,t1,256 # 1000100
    $warning("addi t1,t1,256 # 1000100");
    $display("rf_rs1 %h rf_rs2 %h", top.rf_rs1, top.rf_rs2);
    $display("alu %h", top.alu.res);
    assert (top.pc_reg.out == 16);

    #20;  //  lui     t2,0x2000
    $warning("lui t2,0x2000");
    $display("rf_rs1 %h rf_rs2 %h", top.rf_rs1, top.rf_rs2);
    $display("alu %h", top.alu.res);
    assert (top.pc_reg.out == 20);

    #20;  //  addi    t2,t2,256 # 2000100
    $warning("addi  t2,t2,256 # 2000100");
    $display("rf_rs1 %h rf_rs2 %h", top.rf_rs1, top.rf_rs2);
    $display("alu %h", top.alu.res);
    assert (top.pc_reg.out == 24);

    #20;  //  lui     t3,0x3000
    $warning("lui     t3,0x3000");
    $display("rf_rs1 %h rf_rs2 %h", top.rf_rs1, top.rf_rs2);
    $display("alu %h", top.alu.res);
    assert (top.pc_reg.out == 28);

    #20;  //  addi    t3,t3,256 # 3000100
    $warning("addi    t3,t3,256 # 3000100");
    $display("rf_rs1 %h rf_rs2 %h", top.rf_rs1, top.rf_rs2);
    $display("alu %h", top.alu.res);
    assert (top.pc_reg.out == 32);

    #20;  //  lui     t4,0x4000
    $warning("lui     t4,0x4000");
    $display("rf_rs1 %h rf_rs2 %h", top.rf_rs1, top.rf_rs2);
    $display("alu %h", top.alu.res);
    assert (top.pc_reg.out == 36);

    #20;  //  addi    t4,t4,256 # 4000100
    $warning("addi    t4,t4,256 # 40001000");
    $display("rf_rs1 %h rf_rs2 %h", top.rf_rs1, top.rf_rs2);
    $display("alu %h", top.alu.res);
    assert (top.pc_reg.out == 40);

    #20;  //  lui     t5,0x5000
    $warning("lui     t5,0x5000");
    $display("rf_rs1 %h rf_rs2 %h", top.rf_rs1, top.rf_rs2);
    $display("alu %h", top.alu.res);
    assert (top.pc_reg.out == 44);

    #20;  //  addi    t5,t5,256 # 5000100
    $warning("addi    t5,t5,256 # 5000100");
    $display("rf_rs1 %h rf_rs2 %h", top.rf_rs1, top.rf_rs2);
    $display("alu %h", top.alu.res);
    assert (top.pc_reg.out == 48);

    #20;  //  lui     t6,0x6000
    $warning("lui     t6,0x6000");
    $display("rf_rs1 %h rf_rs2 %h", top.rf_rs1, top.rf_rs2);
    $display("alu %h", top.alu.res);
    assert (top.pc_reg.out == 52);

    #20;  //  addi    t6,t6,256 # 6000100
    $warning("addi    t6,t6,256 # 60001000");
    $display("rf_rs1 %h rf_rs2 %h", top.rf_rs1, top.rf_rs2);
    $display("alu %h", top.alu.res);
    assert (top.pc_reg.out == 56);

    #20;  //  lui     a0,0x7000
    $warning("lui     a0,0x7000");
    $display("rf_rs1 %h rf_rs2 %h", top.rf_rs1, top.rf_rs2);
    $display("alu %h", top.alu.res);
    assert (top.pc_reg.out == 60);

    #20;  //  addi    a0,a0,256 # 7000100
    $warning("addi    a0,a0,256 # 7000100");
    $display("rf_rs1 %h rf_rs2 %h", top.rf_rs1, top.rf_rs2);
    $display("alu %h", top.alu.res);
    assert (top.pc_reg.out == 64);

    #20;  //  lui     a1,0x8000
    $warning("lui     a1,0x8000");
    $display("rf_rs1 %h rf_rs2 %h", top.rf_rs1, top.rf_rs2);
    $display("alu %h", top.alu.res);
    assert (top.pc_reg.out == 17 * 4);

    #20;  //  addi    a1,a1,256 # 8000100
    $warning("addi    a1,a1,256 # 8000100");
    $display("rf_rs1 %h rf_rs2 %h", top.rf_rs1, top.rf_rs2);
    $display("alu %h", top.alu.res);
    assert (top.pc_reg.out == 18 * 4);

    #20;  //  lui     a3,0x9000
    $warning("lui     a3,0x9000");
    $display("rf_rs1 %h rf_rs2 %h", top.rf_rs1, top.rf_rs2);
    $display("alu %h", top.alu.res);
    assert (top.pc_reg.out == 19 * 4);

    #20;  //  addi    a3,a3,256 # 9000100
    $warning("addi    a3,a3,256 # 90001000");
    $display("rf_rs1 %h rf_rs2 %h", top.rf_rs1, top.rf_rs2);
    $display("alu %h", top.alu.res);
    assert (top.pc_reg.out == 20 * 4);

    #20;  //  csrrw   b01, t1, zero
    $warning("csrrw   b01, t1, zero");
    $display("rf_rs1 %h rf_rs2 %h", top.rf_rs1, top.rf_rs2);
    $display("alu %h", top.alu.res);
    assert (top.pc_reg.out == 21 * 4);

    #20;  //  csrrw   b02, t2, zero
    $warning("csrrw   b02, t2, zero");
    $display("rf_rs1 %h rf_rs2 %h", top.rf_rs1, top.rf_rs2);
    $display("alu %h", top.alu.res);
    assert (top.pc_reg.out == 22 * 4);

    #20;  // csrrw   b03, t3, zero
    $warning("csrrw   b03, t2, zero");
    $display("rf_rs1 %h rf_rs2 %h", top.rf_rs1, top.rf_rs2);
    $display("alu %h", top.alu.res);
    assert (top.pc_reg.out == 23 * 4);

    #20;  // csrrw   b04, t4, zero
    $warning("csrrw   b04, t2, zero");
    $display("rf_rs1 %h rf_rs2 %h", top.rf_rs1, top.rf_rs2);
    $display("alu %h", top.alu.res);
    assert (top.pc_reg.out == 24 * 4);

    #20;  //  csrrw   b05, t5, zero
    $warning("csrrw   b02, t2, zero");
    $display("rf_rs1 %h rf_rs2 %h", top.rf_rs1, top.rf_rs2);
    $display("alu %h", top.alu.res);
    assert (top.pc_reg.out == 25 * 4);

    #20;  //  csrrw   b06, t6, zero
    $warning("csrrw   b06, t6, zero");
    $display("rf_rs1 %h rf_rs2 %h", top.rf_rs1, top.rf_rs2);
    $display("alu %h", top.alu.res);
    assert (top.pc_reg.out == 26 * 4);

    #20;  //  csrrw   b07, a1, zero
    $warning("csrrw   b07, t2, zero");
    $display("rf_rs1 %h rf_rs2 %h", top.rf_rs1, top.rf_rs2);
    $display("alu %h", top.alu.res);
    assert (top.pc_reg.out == 27 * 4);

    #20;  //  csrrw   b08, a2, zero
    $warning("csrrw   b08, a2, zero");
    $display("rf_rs1 %h rf_rs2 %h", top.rf_rs1, top.rf_rs2);
    $display("alu %h", top.alu.res);
    assert (top.pc_reg.out == 28 * 4);

    #20;  //  csrrw   b09, a3, zero
    $warning("csrrw   b09, a3, zero");
    $display("rf_rs1 %h rf_rs2 %h", top.rf_rs1, top.rf_rs2);
    $display("alu %h", top.alu.res);
    assert (top.pc_reg.out == 29 * 4);

    $display("---   rf[t1 6] %h", top.rf.regs[6]);

    #20;  //  lui     t1,0x5
    $warning("lui     t1,0x5");
    $display("rf_rs1 %h rf_rs2 %h", top.rf_rs1, top.rf_rs2);
    $display("alu %h", top.alu.res);
    assert (top.pc_reg.out == 30 * 4);

    #20;  //  addi    t1,t1,8 # 5008
    $warning("addi    t1,t1,8 # 5008");
    $display("rf_rs1 %h rf_rs2 %h", top.rf_rs1, top.rf_rs2);
    $display("alu %h", top.alu.res);
    assert (top.pc_reg.out == 31 * 4);

    #20;  //  li      t2,50
    $warning("li      t2,50");
    $display("rf_rs1 %h rf_rs2 %h", top.rf_rs1, top.rf_rs2);
    $display("alu %h", top.alu.res);
    assert (top.pc_reg.out == 32 * 4);

    #20;  //  sw      t2,0(t1)
    $warning("sw      t2,0(t1)");
    $display("rf_rs1 %h rf_rs2 %h", top.rf_rs1, top.rf_rs2);
    $display("alu %h", top.alu.res);
    assert (top.pc_reg.out == 33 * 4);

    #20;  // --- nop ---

    assert (top.pc_reg.out == 34 * 4);
    // dump registers
    $display("rf[t1 6] %h", top.rf.regs[6]);
    $display("rf[t2 7] %h", top.rf.regs[7]);
    $display("rf[t3 28] %h", top.rf.regs[28]);
    $display("rf[t4 29] %h", top.rf.regs[29]);
    $display("rf[t5 30] %h", top.rf.regs[30]);
    $display("rf[t6 31] %h", top.rf.regs[31]);
    $display("rf[a1 11] %h", top.rf.regs[11]);
    $display("rf[a2 12] %h", top.rf.regs[12]);
    $display("rf[a3 13] %h", top.rf.regs[13]);

    // dump csr
    $display("csr_led %h", top.csr_led.csr_led.data);
    $display("led %h", led);

    $display("dmem.mem[5008] %h", top.dmem.mem[0008]);

    $finish;
  end

endmodule
