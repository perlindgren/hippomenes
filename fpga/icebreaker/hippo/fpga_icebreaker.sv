// fpga_icebreaker
`timescale 1ns / 1ps

// import icebreaker_pkg::*;

module top (

    input CLK,

    output LED1
    // output LED2,
    // output LED3,
    // output LED4,
    // output LED5,

    // input BTN_N,
    // input BTN1,
    // input BTN2,
    // input BTN3,

    // output LEDR_N,
    // output LEDG_N,

    // output P1A1,
    // P1A2,
    // P1A3,
    // P1A4,
    // P1A7,
    // P1A8,
    // P1A9,
    // P1A10,
    // output P1B1,
    // P1B2,
    // P1B3,
    // P1B4,
    // P1B7,
    // P1B8,
    // P1B9,
    // P1B10

    // input sysclk,
    // output LedT led,
    // output LedT led_r,
    // output LedT led_g,
    // output LedT led_b,
    // input SwT sw,

    // output logic rx,  // seen from host side 
    // input  logic tx,

    // input BtnT btn
);

  // logic clk;

  logic [31:0] r_count;
  // logic locked;

  // always_comb begin
  //   for (integer k = 0; k < LedWidth; k++) begin
  //     if (k != 0) led_r[k] = 0;  // used for clock
  //     led_g[k] = 0;
  //     led_b[k] = 0;
  //   end
  // end

  // top_arty hippo (
  //     .clk,
  //     .reset(sw[1]),
  //     .btn,
  //     .led,
  //     .rx
  // );


  // clock devider
  always @(posedge CLK) begin
    r_count  <= r_count + 1;
    LED1 <= r_count[22];
  end

endmodule
