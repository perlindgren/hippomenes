// tb_register_file
module tb_register_file;
  parameter DataWidth  = 32;
  parameter NumRegs    = 32;
  parameter IndexWidth = $clog2(NumRegs);

  logic                  clk;
  logic                  writeEn;
  logic [IndexWidth-1:0] writeAddr;
  logic [ DataWidth-1:0] writeData;
  logic [IndexWidth-1:0] readAddr1;
  logic [IndexWidth-1:0] readAddr2;
  logic [ DataWidth-1:0] readData1;
  logic [ DataWidth-1:0] readData2;

  RegisterFile dut (
      clk,
      writeEn,
      writeAddr,
      writeData,
      readAddr1,
      readAddr2,
      readData1,
      readData2
  );

  initial begin
    $dumpfile("register_file.fst");
    $dumpvars;

    clk = 0; 
    writeEn = 0;
    writeAddr = 0;
    readAddr1 = 0;
    readAddr2 = 0;

    writeEn = 1; writeAddr = 'b00001; writeData = 'h12345678;

    #10 clk = 1; #10 clk = 0;

    #10 $finish;
    // highest entry (leftmost), represent the threshold
    // all at prio zero
    // entries = {{3'b000}, {3'b000}, {3'b000}, {3'b000}};
    // #10 $display("(0), is_interrupt %d, index %d", is_interrupt, index);
    // assert (is_interrupt == 0 && index == 3) $display("filtered by threshold");
    // else $error("should be filtered by threshold");

  end
endmodule
