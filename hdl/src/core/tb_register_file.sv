// tb_register_file
`timescale 1ns / 1ps

module tb_register_file;
  parameter integer unsigned DataWidth = 32;
  parameter integer unsigned NumRegs = 32;
  parameter integer unsigned IndexWidth = $clog2(NumRegs);

  reg                  clk;
  reg                  reset;
  reg                  writeEn;
  reg [IndexWidth-1:0] writeAddr;
  reg [ DataWidth-1:0] writeData;
  reg [IndexWidth-1:0] readAddr1;
  reg [IndexWidth-1:0] readAddr2;
  reg [ DataWidth-1:0] readData1;
  reg [ DataWidth-1:0] readData2;

  register_file dut (
      .clk(clk),
      .reset(reset),
      .writeEn(writeEn),
      .writeAddr(writeAddr),
      .writeData(writeData),
      .readAddr1(readAddr1),
      .readAddr2(readAddr2),
      .readData1(readData1),
      .readData2(readData2)
  );

  always #10 clk = ~clk;

  initial begin
    $dumpfile("register_file.fst");
    $dumpvars;

    clk   = 0;
    reset = 0;
    #5;
    reset = 1;
    #10;
    reset = 0;
    #10;

    readAddr1 = 0;
    readAddr2 = 1;
    writeEn   = 1;
    writeAddr = 1;
    writeData = 'h12345678;

    #10;
    assert ((readData1 == 0) && (readData2 == 'h12345678)) $display("ok");
    else $error("rs1 %h, rs2 %h", readData1, readData2);

    writeAddr = 0;
    #10;

    assert ((readData1 == 0) && (readData2 == 'h12345678)) $display("ok");
    else $error("rs1 %h, rs2 %h", readData1, readData2);
    #10;

    writeAddr = 31;
    writeData = 'hdead_beef;
    readAddr1 = 31;
    #10;
    assert ((readData1 == 'hdead_beef) && (readData2 == 'h12345678)) $display("ok");
    else $error("rs1 %h, rs2 %h", readData1, readData2);

    #10 $finish;

  end
endmodule
