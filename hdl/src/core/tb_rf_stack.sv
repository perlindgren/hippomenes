// tb_rf_stack
`timescale 1ns / 1ps

module tb_rf_stack;
  import config_pkg::*;
  // localparam integer unsigned DataWidth = 32;
  // localparam integer unsigned NumRegs = 32;
  // localparam integer unsigned NumLevels = 4;
  // localparam integer unsigned RegsWidth = $clog2(NumRegs);
  // localparam integer unsigned LevelsWidth = $clog2(NumLevels);

  // localparam type DataT = logic [DataWidth-1:0];
  // localparam type LevelT = logic [LevelsWidth-1:0];
  // localparam type AddrT = logic [RegsWidth-1:0];

  localparam RegAddrT Zero = 0;  // x0
  localparam RegAddrT Ra = 1;  // x1
  localparam RegAddrT Sp = 2;  // x2

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

    $display("-- level %d, writeAddr %d, writeData %h", level, writeAddr, writeData);
    $display("regs[0][Sp] %h", dut.gen_rf[0].rf.mem[Sp]);
    $display("regs[1][Sp] %h", dut.gen_rf[1].rf.mem[Sp]);
    assert (dut.gen_rf[0].rf.mem[2] == 'h00000000);
    assert (dut.gen_rf[1].rf.mem[2] == 'h00000000);
    $display("-- level %d, writeAddr %d, writeData %h", level, writeAddr, writeData);

    #20;
    $warning();
    $display("regs[0][Sp] %h", dut.gen_rf[0].rf.mem[Sp]);
    $display("regs[1][Sp] %h", dut.gen_rf[1].rf.mem[Sp]);

    assert (dut.gen_rf[0].rf.mem[2] == 'h12345678);  // sp written to level zero
    assert (dut.gen_rf[1].rf.mem[2] == 'h12345678);  // sp not written here

    writeAddr = 3;  // non shared register
    writeData = 'h00001111;
    $display("-- level %d, writeAddr %d, writeData %h", level, writeAddr, writeData);

    #20;
    // $warning();
    $display("regs[0][Sp] %h", dut.gen_rf[0].rf.mem[Sp]);
    $display("regs[1][Sp] %h", dut.gen_rf[1].rf.mem[Sp]);
    $display("regs[0][3] %h", dut.gen_rf[0].rf.mem[3]);
    $display("regs[1][3] %h", dut.gen_rf[1].rf.mem[3]);
    assert (dut.gen_rf[0].rf.mem[Sp] == 'h12345678);
    assert (dut.gen_rf[1].rf.mem[Sp] == 'h12345678);
    assert (dut.gen_rf[0].rf.mem[3] == 'h00000000);
    assert (dut.gen_rf[1].rf.mem[3] == 'h00001111);

    // test write through
    level = 2;
    readAddr1 = 3;
    readAddr2 = Sp;
    writeAddr = 3;
    writeData = 'h1111_0000;

    $display("\n-- level %d, writeEn %d, writeAddr %d, writeData %h", level, writeEn, writeAddr,
             writeData);
    #1;  // wait to force Verilator update
    $display("readAddr1 %d, readData1 %h", readAddr1, readData1);
    $display("readAddr2 %d, readData2 %h", readAddr2, readData2);
    assert (readData1 == 'h1111_0000);
    assert (readData2 == 'h1234_5678);

    writeEn = 0;
    $display("\n-- level %d, writeEn %d, writeAddr %d, writeData %h", level, writeEn, writeAddr,
             writeData);
    #1;  // wait to force Verilator update
    $display("readAddr1 %d, readData1 %h", readAddr1, readData1);
    $display("readAddr2 %d, readData2 %h", readAddr2, readData2);
    assert (readData1 == 'h0000_0000);  // never written to, so 0
    assert (readData2 == 'h1234_5678);

    // test ra
    level = 2;
    writeRaEn = 1;
    writeEn = 1;
    writeAddr = Ra;  // ra register;
    writeData = 'hffff_eeee;
    readAddr1 = Ra;

    #1;  // wait to force Verilator update
    $display("\n-- level %d, writeEn %d, writeAddr %d, writeData %h", level, writeEn, writeAddr,
             writeData);
    $display("-- level %d, writeRaEn %d", level, writeRaEn);

    $display("before clock");
    $display("regs[2][Ra] %h", dut.gen_rf[2].rf.mem[Ra]);  // current level
    $display("regs[1][Ra] %h", dut.gen_rf[1].rf.mem[Ra]);  // preempt level
    $display("readAddr1 %d = %h", readAddr1, readData1);
    $display("readAddr2 %d = %h", readAddr2, readData2);

    #17;
    $display("after clock");
    $display("regs[2][Ra] %h", dut.gen_rf[2].rf.mem[Ra]);  // current level
    $display("regs[1][Ra] %h", dut.gen_rf[1].rf.mem[Ra]);  // preempt level
    $display("readAddr1 %d = %h", readAddr1, readData1);
    $display("readAddr2 %d = %h", readAddr2, readData2);

    assert (readData1 == 'hffff_eeee);
    assert (dut.gen_rf[2].rf.mem[Ra] == 'hffff_eeee);
    assert (dut.gen_rf[1].rf.mem[Ra] == 'hffff_ffff);

    $display("size of regfile in bits %d", $bits(dut.gen_rf[0].rf.mem));

    $finish;

  end
endmodule
