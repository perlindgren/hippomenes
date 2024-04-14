// fpga_arty
`timescale 1ns / 1ps

import arty_pkg::*;

module fpga_arty (
    input sysclk,
    output LedT led,
    output LedT led_r,
    output LedT led_g,
    output LedT led_b,
    input SwT sw,

    output logic rx,  // seen from host side 
    input  logic tx,

    input BtnT btn
);

  logic clk;

  logic [31:0] r_count;
  logic locked;

  always_comb begin
    for (integer k = 0; k < LedWidth; k++) begin
      if (k != 0) led_r[k] = 0;  // used for clock
      led_g[k] = 0;
      led_b[k] = 0;
    end
  end

  top_arty hippo (
      .clk,
      .reset(sw[1]),
      .btn,
      .led,
      .tx(rx) // connect hippo TX with FTDI RX
  );

  clk_wiz_0 clk_gen (
      // Clock in ports
      .clk_in1(sysclk),
      // Clock out ports
      .clk_out1(clk),
      // Status and control signals
      .reset(sw[0]),
      .locked
  );

  // clock devider
  always @(posedge clk) begin
    r_count  <= r_count + 1;
    led_r[0] <= r_count[22];
  end

endmodule
