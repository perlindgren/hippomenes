// tb_test_mem
`timescale 1ns / 1ps

module tb_test_mem;
  import config_pkg::*;
  import decoder_pkg::*;

  reg clk;
  reg reset;

  top top (
      .clk  (clk),
      .reset(reset)
  );

  // clock and reset
  initial begin
    $display($time, " << Starting the Simulation >>");

    // notice raw access to memory is in words, le byte order

    // istruction memory
    top.imem.mem[0] = 'h50000117;  //    auipc   sp, 327680
    top.imem.mem[1] = 'h50010113;  //    addi    sp, sp, 1280

    top.imem.mem[2] = 'h50000517;  //    auipc   a0, 327680
    top.imem.mem[3] = 'hff850513;  //    addi    a0, a0, -8

    top.imem.mem[4] = 'h00050283;  //    lb  t0, 0(a0)
    top.imem.mem[5] = 'h00150303;  //    lb  t1, 1(a0)
    top.imem.mem[6] = 'h00250383;  //    lb  t2, 2(a0)
    top.imem.mem[7] = 'h00350e03;  //    lb  t3, 3(a0)
    top.imem.mem[8] = 'h00051e83;  //    lh  t4, 0(a0)
    top.imem.mem[9] = 'h00251f03;  //    lh  t5, 2(a0)
    top.imem.mem[10] = 'h00052f83;  //    lw  t6, 0(a0)
    top.imem.mem[11] = 'h00054283;  //    lbu t0, 0(a0)
    top.imem.mem[12] = 'h00154303;  //    lbu t1, 1(a0)
    top.imem.mem[13] = 'h00254383;  //    lbu t2, 2(a0)
    top.imem.mem[14] = 'h00354e03;  //    lbu t3, 3(a0)
    top.imem.mem[15] = 'h00055e83;  //    lhu t4, 0(a0)
    top.imem.mem[16] = 'h00255f03;  //    lhu t5, 2(a0)
    top.imem.mem[17] = 'h00550223;  //    sb  t0, 4(a0)
    top.imem.mem[18] = 'h006502a3;  //    sb  t1, 5(a0)
    top.imem.mem[19] = 'h00750323;  //    sb  t2, 6(a0)
    top.imem.mem[20] = 'h01c503a3;  //    sb  t3, 7(a0)
    top.imem.mem[21] = 'h01d51423;  //    sh  t4, 8(a0)
    top.imem.mem[22] = 'h01e51523;  //    sh  t5, 10(a0)

    top.imem.mem[23] = 'h0000006f;  //    j   0x5c <s>

    // data memory
    top.dmem.mem[0] = 'hf4f3f201;  // .byte   0x01, 0xf2, 0xf3, 0xf4
    top.dmem.mem[1] = 'h01020304;  // .word   0x01020304
    top.dmem.mem[2] = 'h12345678;  // .word   0x12345678
    top.dmem.mem[3] = 'hf1f2f3f4;  // .word   0xF1F2F3F4

    reset = 1;
    clk = 0;
    #5 reset = 0;
  end

  always #10 clk = ~clk;

  initial begin
    $dumpfile("test_mem.fst");
    $dumpvars;

    #10;  // auipc   sp,0x50000

    $display("auipc   a0, 327680", $time);

    #20;
    $display("addi    sp, sp, 1280", $time);

    #20;
    $display("auipc   a0, 327680", $time);

    #20;
    $display("addi    a0, a0, -8", $time);

    #20;
    $display("lb  t0, 0(a0)", $time);
    $warning("dmem address %h", top.dmem.address);
    $warning("dmem signed_extend  %b", top.dmem.sign_extend);
    $warning("dmem out %h", top.dmem.data_out);
    #20;
    $display("lb  t1, 1(a0)", $time);
    $warning("dmem address %h", top.dmem.address);
    $warning("dmem signed_extend  %b", top.dmem.sign_extend);
    $warning("dmem out %h", top.dmem.data_out);

    #20;
    $display("lb  t2, 2(a0)", $time);

    #20;
    $display("lb  t3, 3(a0)", $time);

    #20;
    $display("lh  t4, 0(a0)", $time);
    $warning("dmem address %h", top.dmem.address);
    $warning("dmem signed_extend  %b", top.dmem.sign_extend);
    $warning("dmem out %h", top.dmem.data_out);

    #20;
    $display("lh  t5, 2(a0)", $time);

    #20;
    $display("lw  t6, 0(a0)", $time);

    $warning("dmem address %h", top.dmem.address);
    $warning("dmem signed_extend  %b", top.dmem.sign_extend);
    $warning("dmem out %h", top.dmem.data_out);

    $warning("rf[t0 x5] %h", top.rf.regs[5]);
    $warning("rf[t1 x6] %h", top.rf.regs[6]);
    $warning("rf[t2 x7] %h", top.rf.regs[7]);
    $warning("rf[t3 x28] %h", top.rf.regs[28]);
    $warning("rf[t4 x29] %h", top.rf.regs[29]);
    $warning("rf[t5 x30] %h", top.rf.regs[30]);
    $warning("rf[t6 x31] %h", top.rf.regs[31]);

    #20;
    $display("lbu t0, 0(a0)", $time);
    $warning("rf[t5 x30] %h", top.rf.regs[30]);
    $warning("rf[t6 x31] %h", top.rf.regs[31]);

    #20;
    $display("lbu t1, 1(a0)", $time);
    $warning("rf[t5 x30] %h", top.rf.regs[30]);
    $warning("rf[t6 x31] %h", top.rf.regs[31]);

    #20;
    $display("lbu t2, 2(a0)", $time);

    #20;
    $display("lbu t3, 3(a0)", $time);

    #20;
    $display("lhu t4, 0(a0)", $time);

    #20;
    $display("lhu t5, 2(a0)", $time);

    #20;
    $display("sb  t0, 4(a0)", $time);
    $warning("rf[a0 x10] %h", top.rf.regs[10]);
    $warning("dmem address %h", top.dmem.address);
    $warning("alu_op %h", top.alu.op);
    $warning("alu_a_mux_out %h", top.alu_a_mux_out);
    $warning("alu_b_mux_out %h", top.alu_b_mux_out);

    $warning("alu_res %h", top.alu.res);

    $warning("dmem width %h", top.dmem.width);
    $warning("dmem write_enable %h", top.dmem.write_enable);
    $warning("dmem in  %b", top.dmem.data_in);
    $warning("rf[t0 x5] %h", top.rf.regs[5]);
    $warning("dmem out %h", top.dmem.data_out);

    $warning("dmem.mem %h", top.dmem.mem[0]);  // in words
    $warning("dmem.mem %h", top.dmem.mem[1]);  // in words

    #20;
    $display("sb  t1, 5(a0)", $time);

    #20;
    $display("sb  t2, 6(a0)", $time);

    #20;
    $display("sb  t3, 7(a0)", $time);

    #20;
    $display("sh  t4, 8(a0)", $time);

    #20;
    $display("sh  t5, 10(a0)", $time);

    #20;
    $display(" j   0x5c <s>", $time);

    #20;

    $warning("dmem.mem %h", top.dmem.mem[0]);  // in words
    $warning("dmem.mem %h", top.dmem.mem[1]);  // in words
    $warning("dmem.mem %h", top.dmem.mem[2]);  // in words
    $warning("dmem.mem %h", top.dmem.mem[3]);  // in words


    #120;
    $finish;
  end

endmodule
