// tb_rf_stack
`timescale 1ns / 1ps

module tb_rf_stack;
  import config_pkg::*;

  logic clk;
  logic reset;
  logic writeEn;
  logic writeRaEn;
  PrioT level;
  RegAddrT writeAddr;
  RegT writeData;
  RegAddrT readAddr1;
  RegAddrT readAddr2;
  RegT readData1;
  RegT readData2;

  rf_stack dut (
      .clk,
      .reset(reset),
      .writeEn(writeEn),
      .writeRaEn(writeRaEn),
      .level(level),
      .writeAddr(writeAddr),
      .writeData(writeData),
      .readAddr1(readAddr1),
      .readAddr2(readAddr2),
      .readData1(readData1),
      .readData2(readData2)
  );

  always #10 clk = ~clk;

  initial begin
    $dumpfile("rf_stack.fst");
    $dumpvars;

    clk   = 0;
    reset = 1;
    #15;
    reset = 0;

    level = 1;
    writeRaEn = 0;

    readAddr1 = Zero;
    readAddr2 = Sp;
    writeEn = 1;
    writeAddr = Sp;  // shared sp
    writeData = 'h12345678;

    #20;

    assert (readData1 == 0);
    assert (readData2 == 'h12345678);

    writeAddr = 31;
    readAddr1 = 31;
    writeData = 'hAAAA_0000;

    #20;

    assert (readData1 == 'hAAAA_0000);
    assert (readData2 == 'h12345678);

    level   = 2;
    writeEn = 0;

    #20;

    assert (readData1 == 0);
    assert (readData2 == 'h12345678);

    writeRaEn = 1;
    writeEn   = 1;
    writeAddr = Ra;
    writeData = 'h0000_FFFF;
    readAddr1 = Ra;

    #20;

    $display("r1 %h", readData1);
    assert (readData1 == 'h0000_FFFF);
    $display("r2 %h", readData2);

    level = 1;

    #20;

    $display("r1 %h", readData1);
    assert (readData1 == 'hFFFF_FFFF);

    $finish;

  end
endmodule
