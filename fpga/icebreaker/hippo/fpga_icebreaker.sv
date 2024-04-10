// fpga_icebreaker
`timescale 1ns / 1ps

import config_pkg::*;
import decoder_pkg::*;
module top (
    input  CLK,
    output LED1,
    output LED2
);

  BtnT btn;
  assign btn = '{0, 0, 0, 0};

  top_n_clic hippo (
      .clk  (CLK),
      .reset(0),
      .btn,
      .LED2
  );


  logic [31:0] r_count;

  // clock devider
  always @(posedge CLK) begin
    r_count <= r_count + 1;
    LED1 <= r_count[22];
  end

endmodule
