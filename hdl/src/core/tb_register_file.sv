// tb_register_file
module tb_register_file;
  parameter integer unsigned DataWidth = 32;
  parameter integer unsigned NumRegs = 32;
  parameter integer unsigned IndexWidth = $clog2(NumRegs);

  logic                  clk;
  logic                  reset;
  logic                  writeEn;
  logic [IndexWidth-1:0] writeAddr;
  logic [ DataWidth-1:0] writeData;
  logic [IndexWidth-1:0] readAddr1;
  logic [IndexWidth-1:0] readAddr2;
  logic [ DataWidth-1:0] readData1;
  logic [ DataWidth-1:0] readData2;

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

    clk = 0;
    readAddr1 = 0;
    readAddr2 = 1;
    writeEn = 1;
    writeAddr = 1;
    writeData = 'h12345678;

    #15;
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
