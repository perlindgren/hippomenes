// fpga_icebreaker
`timescale 1ns / 1ps

module top
  import icebreaker_pkg::*;
  import decoder_pkg::*;
(
    input CLK,
    input BTN1,
    input BTN2,
    input BTN3,

    output P1B1,
    output P1B2,
    output P1B3,
    output P1B4,
    output P1B7,
    output P1B8,
    output P1B9,
    output P1B10,

    output LED_RED_N,
    output LED_GRN_N,
    output LED_BLU_N,

    output LED1,
    output LED2,
    output LED3,
    output LED4,
    output LED5
);
  BtnT btn;
  assign btn = '{0, BTN3, BTN2, BTN1};

  top_icebreaker top (
      .clk  (CLK),
      .reset(btn[0]),
      .btn,
      .pb1  (P1B1),
      .pb2  (P1B2),
      .pb3  (P1B3),
      .pb4  (P1B4),
      .pb7  (P1B7),
      .pb8  (P1B8),
      .pb9  (P1B9),
      //.pb10 (P1B10),
      .led1 (LED2),
      .led2 (LED3),
      .led3 (LED4),
      .led4 (LED5)
  );

  logic [31:0] r_count;

  assign LED_RED_N = btn[0];
  assign P1B10 = r_count[0] & ~(btn[0]);

  // clock devider
  always @(posedge CLK) begin
    r_count <= r_count + 1;
    LED1 <= r_count[22] & ~(btn[0]);
  end

endmodule
