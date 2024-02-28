// tb_fpga_top
`timescale 1ns / 1ps

module tb_fpga_top;
  import config_pkg::*;
  import decoder_pkg::*;

  reg clk;
  reg reset;
  reg led;

  top top (
      .clk  (clk),
      .reset(reset),
      .led  (led)
  );

  initial begin
    reset = 1;
    clk   = 0;
    #15 reset = 0;
  end

  always #10 clk = ~clk;

  initial begin
    $dumpfile("fpga_top.fst");
    $dumpvars;

    #100;
    $finish;
  end

endmodule
