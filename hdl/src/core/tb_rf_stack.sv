// tb_rf_stack
module tb_rf_stack;
  parameter integer unsigned DataWidth = 32;
  parameter integer unsigned NumRegs = 32;
  parameter integer unsigned NumLevels = 8;
  localparam integer unsigned IndexWidth = $clog2(NumRegs);
  localparam integer unsigned IndexLevels = $clog2(NumLevels);

  reg                   clk;
  reg                   reset;
  reg                   writeEn;
  reg                   writeRaEn;
  reg [  DataWidth-1:0] writeRaData;
  reg [IndexLevels-1:0] level;
  reg [ IndexWidth-1:0] writeAddr;
  reg [  DataWidth-1:0] writeData;
  reg [ IndexWidth-1:0] readAddr1;
  reg [ IndexWidth-1:0] readAddr2;
  reg [  DataWidth-1:0] readData1;
  reg [  DataWidth-1:0] readData2;
  reg [  DataWidth-1:0] readRa;


  rf_stack #(
      .DataWidth(DataWidth),
      .NumRegs  (NumRegs),
      .NumLevels(NumLevels)
  ) dut (
      .clk(clk),
      .reset(reset),
      .writeEn(writeEn),
      .writeRaEn(writeRaEn),
      .writeRaData(writeRaData),
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
    #10;
    reset = 0;

    level = 1;
    writeRaEn = 0;

    readAddr1 = 0;
    readAddr2 = 2;
    writeEn = 1;
    writeAddr = 2;  // shared sp
    writeData = 'h12345678;

    $warning();
    $display("-- level %d, writeAddr %d, writeData %h", level, writeAddr, writeData);
    $display("regs[0][2] %h", dut.regs[0][2]);
    $display("regs[1][2] %h", dut.regs[1][2]);
    assert (dut.regs[0][2] == 'h00000000);
    assert (dut.regs[1][2] == 'h00000000);
    $display("-- level %d, writeAddr %d, writeData %h", level, writeAddr, writeData);

    #10;
    $warning();
    $display("regs[0][2] %h", dut.regs[0][2]);
    $display("regs[1][2] %h", dut.regs[1][2]);
    assert (dut.regs[0][2] == 'h12345678);
    assert (dut.regs[1][2] == 'h00000000);

    writeAddr = 3;  // non shared register
    writeData = 'h00001111;
    $display("-- level %d, writeAddr %d, writeData %h", level, writeAddr, writeData);

    #20;
    $warning();
    $display("regs[0][2] %h", dut.regs[0][2]);
    $display("regs[1][2] %h", dut.regs[1][2]);
    $display("regs[0][3] %h", dut.regs[0][3]);
    $display("regs[1][3] %h", dut.regs[1][3]);
    assert (dut.regs[0][2] == 'h12345678);
    assert (dut.regs[1][2] == 'h00000000);
    assert (dut.regs[0][3] == 'h00000000);
    assert (dut.regs[1][3] == 'h00001111);


    // test write through
    level = 2;
    readAddr1 = 3;
    readAddr2 = 2;  // sp
    writeAddr = 3;
    writeData = 'h11110000;

    $display("\n-- level %d, writeEn %d, writeAddr %d, writeData %h", level, writeEn, writeAddr,
             writeData);
    #1;  // wait to force Verilator update
    $display("readAddr1 %d, readData1 %h", readAddr1, readData1);
    $display("readAddr2 %d, readData2 %h", readAddr2, readData2);
    assert (readData1 == 'h11110000);
    assert (readData2 == 'h12345678);

    writeEn = 0;
    $display("\n-- level %d, writeEn %d, writeAddr %d, writeData %h", level, writeEn, writeAddr,
             writeData);
    #1;  // wait to force Verilator update
    $display("readAddr1 %d, readData1 %h", readAddr1, readData1);
    $display("readAddr2 %d, readData2 %h", readAddr2, readData2);
    assert (readData1 == 'h00000000);  // never written to, so 0
    assert (readData2 == 'h12345678);

    // test ra
    writeRaEn = 1;
    writeRaData = 'heeeeffff;
    writeEn = 1;
    writeAddr = 1;  // ra register;
    writeData = 'hffffeeee;

    $display("\n-- level %d, writeEn %d, writeAddr %d, writeData %h", level, writeEn, writeAddr,
             writeData);
    $display("-- level %d, writeRaEn %d,  writeRaData %h", level, writeRaEn, writeRaData);

    #18;

    $display("regs[1][1] %h", dut.regs[2][1]);  // current level
    $display("regs[0][1] %h", dut.regs[1][1]);  // preempt level

    $finish;

  end
endmodule
