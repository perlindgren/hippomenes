// tb_rf_stack
`timescale 1ns / 1ps

module tb_rf_stack;
  localparam integer unsigned DataWidth = 32;
  localparam integer unsigned NumRegs = 32;
  localparam integer unsigned NumLevels = 4;
  localparam integer unsigned RegsWidth = $clog2(NumRegs);
  localparam integer unsigned LevelsWidth = $clog2(NumLevels);

  localparam type DataT = logic [DataWidth-1:0];
  localparam type LevelT = logic [LevelsWidth-1:0];
  localparam type AddrT = logic [RegsWidth-1:0];

  localparam AddrT Zero = 0;  // x0
  localparam AddrT Ra = 1;  // x1
  localparam AddrT Sp = 2;  // x2

  logic  clk;
  logic  reset;
  logic  writeEn;
  logic  writeRaEn;
  LevelT level;
  AddrT  writeAddr;
  DataT  writeData;
  AddrT  readAddr1;
  AddrT  readAddr2;
  DataT  readData1;
  DataT  readData2;
  DataT  readRa;

  rf_stack #(
      .DataWidth(DataWidth),
      .NumRegs  (NumRegs),
      .NumLevels(NumLevels)
  ) dut (
      .clk(clk),
      .reset(reset),
      .writeEn(writeEn),
      .writeRaEn(writeRaEn),
      .level(level),
      .writeAddr(writeAddr),
      .writeData(writeData),
      .readAddr1(readAddr1),
      .readAddr2(readAddr2),
      .readData1(readData1),
      .readData2(readData2),
      .readRa(readRa)
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

    $warning();
    $display("-- level %d, writeAddr %d, writeData %h", level, writeAddr, writeData);
    $display("regs[0][Sp] %h", dut.regs[0][Sp]);
    $display("regs[1][Sp] %h", dut.regs[1][Sp]);
    assert (dut.regs[0][2] == 'h00000000);
    assert (dut.regs[1][2] == 'h00000000);
    $display("-- level %d, writeAddr %d, writeData %h", level, writeAddr, writeData);

    #20;
    $warning();
    $display("regs[0][Sp] %h", dut.regs[0][Sp]);
    $display("regs[1][Sp] %h", dut.regs[1][Sp]);
    assert (dut.regs[0][2] == 'h12345678);  // sp written to level zero
    assert (dut.regs[1][2] == 'h00000000);  // sp not written here

    writeAddr = 3;  // non shared register
    writeData = 'h00001111;
    $display("-- level %d, writeAddr %d, writeData %h", level, writeAddr, writeData);

    #20;
    $warning();
    $display("regs[0][Sp] %h", dut.regs[0][Sp]);
    $display("regs[1][Sp] %h", dut.regs[1][Sp]);
    $display("regs[0][3] %h", dut.regs[0][3]);
    $display("regs[1][3] %h", dut.regs[1][3]);
    assert (dut.regs[0][Sp] == 'h12345678);
    assert (dut.regs[1][Sp] == 'h00000000);
    assert (dut.regs[0][3] == 'h00000000);
    assert (dut.regs[1][3] == 'h00001111);

    // test write through
    level = 2;
    readAddr1 = 3;
    readAddr2 = Sp;  // sp
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
    writeRaEn = 1;
    writeEn   = 1;
    writeAddr = Ra;  // ra register;
    writeData = 'hffff_eeee;
    readAddr1 = Ra;

    $display("\n-- level %d, writeEn %d, writeAddr %d, writeData %h", level, writeEn, writeAddr,
             writeData);
    $display("-- level %d, writeRaEn %d", level, writeRaEn);

    #18;

    $display("regs[1][Ra] %h", dut.regs[2][Ra]);  // current level
    $display("regs[0][Ra] %h", dut.regs[1][Ra]);  // preempt level
    assert (readData1 == 'hffff_eeee);
    assert (dut.regs[2][Ra] == 'hffff_eeee);
    assert (dut.regs[1][Ra] == 'hffff_ffff);

    $display("size of regfile in bits %d", $bits(dut.regs));

    $finish;

  end
endmodule
