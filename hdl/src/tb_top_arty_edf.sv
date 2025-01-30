// tb_top_arty
//`timescale 1ns / 1ps

module tb_top_arty_edf;
  import config_pkg::*;
  import arty_pkg::*;
  logic clk;
  logic reset;


  BtnT  btn;
  LedT  led;
  logic tx;

  top_arty_edf #(
      .INIT_IMEM_FILE("../../rust_examples/text.mem"),
      .BLOCK_0_INIT_FILE("../../rust_examples/data_0.mem"),
      .BLOCK_1_INIT_FILE("../../rust_examples/data_1.mem"),
      .BLOCK_2_INIT_FILE("../../rust_examples/data_2.mem"),
      .BLOCK_3_INIT_FILE("../../rust_examples/data_3.mem")
  ) top (
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
    //$display("memsize %h", IMemSize >> 2);
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
