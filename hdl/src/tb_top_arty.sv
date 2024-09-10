// tb_top_arty
`timescale 1ns / 1ps

module tb_top_arty;
  import config_pkg::*;
  import arty_pkg::*;
  logic clk;
  logic reset;


  BtnT  btn;
  LedT  led;
  logic tx;

  top_arty top (
      // in
      .clk,
      .reset,
      .btn,
      // out
      .led,
      .tx
  );

  // clock and reset
  initial begin
    $display($time, " << Starting the Simulation >>");
    $display("memsize %h", IMemSize >> 2);

    reset = 1;
    clk   = 0;
    #15 reset = 0;
  end

  always #10 begin
    clk = ~clk;
    if (clk) $display(">>>>>>>>>>>>> clk posedge", $time);
  end

  initial begin
    $dumpfile("top_arty.fst");
    $dumpvars;
    #100000;
    $finish;
  end

endmodule

