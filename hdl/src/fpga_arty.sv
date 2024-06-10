// fpga_top
`timescale 1ns / 1ps

// This is just illustrative
module fpga_arty (
    input sysclk,
    output logic[3:0] led,

    output logic[3:0] led_r,

    output logic[3:0] led_g,

    output logic[3:0] led_b,

    output logic rx,  // host 
    input  logic tx,  // host

    input logic[1:0] sw,

    input logic[3:0] btn
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

  assign tmp_sw0  = sw[0];
  assign tmp_sw1  = sw[1];
  assign tmp_btn0 = btn[0];
  assign tmp_btn1 = btn[1];
  assign tmp_btn2 = btn[2];
  assign tmp_btn3 = btn[3];

  //assign led2 = tmp_sw0;
  //assign led3 = tmp_sw1;

  //assign led_r[0]   = 0;
  assign led_r[1]   = 0;
  assign led_r[2]   = 0;
  assign led_r[3]   = 0;

  assign led_g[0]   = 0;
  assign led_g[1]   = 0;
  assign led_g[2]   = 0;
  assign led_g[3]   = 0;

  assign led_b[0]   = 0;
  assign led_b[1]   = 0;
  assign led_b[2]   = 0;
  assign led_b[3]   = 0;

  always_comb begin

  end

  top_arty hippo (
      .clk,
      .reset(tmp_sw1),
      .btn  (btn),
      .led  (led),
      .tx(rx)
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
    led_r[0] <= r_count[22];
  end

endmodule

