// fpga_top
`timescale 1ns / 1ps

// This is just illustrative
module fpga_arty (
    input sysclk,
    output logic led0,
    output logic led1,
    output logic led2,
    output logic led3,

    output logic led_r0,
    output logic led_r1,
    output logic led_r2,
    output logic led_r3,

    output logic led_g0,
    output logic led_g1,
    output logic led_g2,
    output logic led_g3,

    output logic led_b0,
    output logic led_b1,
    output logic led_b2,
    output logic led_b3,

    output logic rx,  // host 
    input  logic tx,  // host

    input logic sw0,
    input logic sw1,

    input logic btn
    // input logic btn1,
    // input logic btn2,
    // input logic btn3
);

  logic clk;

  logic [31:0] r_count;
  // logic reset;
  logic locked;

  logic tmp_sw0;
  logic tmp_sw1;

  logic tmp_btn0;
  logic tmp_btn1;
  logic tmp_btn2;
  logic tmp_btn3;

  assign tmp_sw0  = sw0;
  assign tmp_sw1  = sw1;
  assign tmp_btn0 = btn0;
  assign tmp_btn1 = btn1;
  assign tmp_btn2 = btn2;
  assign tmp_btn3 = btn3;

  //assign led2 = tmp_sw0;
  //assign led3 = tmp_sw1;

  assign led_r0   = 0;
  assign led_r1   = 0;
  assign led_r2   = 0;
  assign led_r3   = 0;

  assign led_g0   = 0;
  assign led_g1   = 0;
  assign led_g2   = 0;
  assign led_g3   = 0;

  assign led_b0   = 0;
  assign led_b1   = 0;
  assign led_b2   = 0;
  assign led_b3   = 0;

  always_comb begin

  end

  top_arty hippo (
      .clk,
      .reset(tmp_sw1),
      .btn  (btn),
      .led  ({led0, led1, led2, led3}),
      .rx
      // .gpio_in({led1, rx, tx}),
      // .gpio_out({led1, rx, tx}),
      // .rx(tx),
  );

  clk_wiz_0 clk_gen (
      // Clock in ports
      .clk_in1(sysclk),
      // Clock out ports
      .clk_out1(clk),
      // Status and control signals
      .reset(tmp_sw0),
      .locked
  );

  // clock devider
  always @(posedge clk) begin
    r_count <= r_count + 1;
    led0 <= r_count[22];
  end

endmodule

