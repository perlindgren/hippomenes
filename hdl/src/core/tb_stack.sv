// tb_stack
`timescale 1ns / 1ps

module tb_stack;
  parameter integer unsigned StackDepth = 4;
  localparam integer StackDepthWidth = $clog2(StackDepth);  // derived
  parameter integer unsigned DataWidth = 8;

  logic                       clk;
  logic                       reset;
  logic                       push;
  logic                       pop;

  logic [      DataWidth-1:0] data_in;
  logic [      DataWidth-1:0] data_out;
  logic [StackDepthWidth-1:0] index_out;

  stack #(
      .StackDepth,
      .DataWidth
  ) dut (
      // in
      .clk,
      .reset,
      .push,
      .pop,
      .data_in,
      // out,
      .data_out,
      .index_out
  );

  always #10 clk = ~clk;

  initial begin
    $dumpfile("stack.fst");
    $dumpvars;

    clk   = 0;
    reset = 1;
    #15;
    reset = 0;
    push  = 0;
    pop   = 0;

    #20;
    $display("index_out %d, data_out %d", index_out, data_out);
    assert (index_out == 3 && data_out == 0);

    // push
    data_in = 1;
    push = 1;
    #20;
    $display("index_out %d, data_out %d", index_out, data_out);
    assert (index_out == 2 && data_out == 1);

    // no push
    push = 0;
    #20;
    $display("index_out %d, data_out %d", index_out, data_out);
    assert (index_out == 2 && data_out == 1);

    // push
    push = 1;
    data_in = 2;
    #20;
    $display("index_out %d, data_out %d", index_out, data_out);
    assert (index_out == 1 && data_out == 2);

    // push
    push = 1;
    data_in = 3;
    #20;
    $display("index_out %d, data_out %d", index_out, data_out);
    assert (index_out == 0 && data_out == 3);

    // push
    push = 1;
    data_in = 4;
    #20;
    $display("index_out %d, data_out %d", index_out, data_out);
    assert (index_out == 3 && data_out == 4);

    // nothing
    push = 0;
    data_in = 4;
    #20;
    $display("index_out %d, data_out %d", index_out, data_out);
    assert (index_out == 3 && data_out == 4);

    // pop
    pop = 1;
    #20;
    $display("index_out %d, data_out %d", index_out, data_out);
    assert (index_out == 0 && data_out == 3);

    // pop
    pop = 1;
    #20;
    $display("index_out %d, data_out %d", index_out, data_out);
    assert (index_out == 1 && data_out == 2);

    // pop
    pop = 1;
    #20;
    $display("index_out %d, data_out %d", index_out, data_out);
    assert (index_out == 2 && data_out == 1);



    // writeRaEn = 0;

    // readAddr1 = 0;
    // readAddr2 = 2;
    // writeEn = 1;
    // writeAddr = 2;  // shared sp
    // writeData = 'h12345678;

    // $warning();
    // $display("-- level %d, writeAddr %d, writeData %h", level, writeAddr, writeData);
    // $display("regs[0][2] %h", dut.regs[0][2]);
    // $display("regs[1][2] %h", dut.regs[1][2]);
    // assert (dut.regs[0][2] == 'h00000000);
    // assert (dut.regs[1][2] == 'h00000000);
    // $display("-- level %d, writeAddr %d, writeData %h", level, writeAddr, writeData);

    // #20;
    // $warning();
    // $display("regs[0][2] %h", dut.regs[0][2]);
    // $display("regs[1][2] %h", dut.regs[1][2]);
    // assert (dut.regs[0][2] == 'h12345678);
    // assert (dut.regs[1][2] == 'h00000000);

    // writeAddr = 3;  // non shared register
    // writeData = 'h00001111;
    // $display("-- level %d, writeAddr %d, writeData %h", level, writeAddr, writeData);

    // #20;
    // $warning();
    // $display("regs[0][2] %h", dut.regs[0][2]);
    // $display("regs[1][2] %h", dut.regs[1][2]);
    // $display("regs[0][3] %h", dut.regs[0][3]);
    // $display("regs[1][3] %h", dut.regs[1][3]);
    // assert (dut.regs[0][2] == 'h12345678);
    // assert (dut.regs[1][2] == 'h00000000);
    // assert (dut.regs[0][3] == 'h00000000);
    // assert (dut.regs[1][3] == 'h00001111);


    // // test write through
    // level = 2;
    // readAddr1 = 3;
    // readAddr2 = 2;  // sp
    // writeAddr = 3;
    // writeData = 'h11110000;

    // $display("\n-- level %d, writeEn %d, writeAddr %d, writeData %h", level, writeEn, writeAddr,
    //          writeData);
    // #1;  // wait to force Verilator update
    // $display("readAddr1 %d, readData1 %h", readAddr1, readData1);
    // $display("readAddr2 %d, readData2 %h", readAddr2, readData2);
    // assert (readData1 == 'h11110000);
    // assert (readData2 == 'h12345678);

    // writeEn = 0;
    // $display("\n-- level %d, writeEn %d, writeAddr %d, writeData %h", level, writeEn, writeAddr,
    //          writeData);
    // #1;  // wait to force Verilator update
    // $display("readAddr1 %d, readData1 %h", readAddr1, readData1);
    // $display("readAddr2 %d, readData2 %h", readAddr2, readData2);
    // assert (readData1 == 'h00000000);  // never written to, so 0
    // assert (readData2 == 'h12345678);

    // // test ra
    // writeRaEn = 1;
    // writeRaData = 'heeeeffff;
    // writeEn = 1;
    // writeAddr = 1;  // ra register;
    // writeData = 'hffffeeee;

    // $display("\n-- level %d, writeEn %d, writeAddr %d, writeData %h", level, writeEn, writeAddr,
    //          writeData);
    // $display("-- level %d, writeRaEn %d,  writeRaData %h", level, writeRaEn, writeRaData);

    // #18;

    // $display("regs[1][1] %h", dut.regs[2][1]);  // current level
    // $display("regs[0][1] %h", dut.regs[1][1]);  // preempt level

    $finish;

  end
endmodule
