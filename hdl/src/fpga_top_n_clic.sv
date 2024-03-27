// fpga_top
`timescale 1ns / 1ps

// This is just illustrative
module fpga_top_n_clic (
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

    input logic sw0,
    input logic sw1
);

  logic clk;

  logic [31:0] r_count;
  // logic reset;
  logic locked;

  logic tmp_sw0;
  logic tmp_sw1;

  assign tmp_sw0 = sw0;
  assign tmp_sw1 = sw1;

  assign led2 = tmp_sw0;
  assign led3 = tmp_sw1;

  assign led_g0 = 0;
  assign led_g1 = 0;
  assign led_g2 = 0;
  assign led_g3 = 0;
  assign led_b0 = 0;
  assign led_b1 = 0;
  assign led_b2 = 0;
  assign led_b3 = 0;
  assign led_r0 = 0;
  assign led_r1 = 0;
  assign led_r2 = 0;
  assign led_r3 = 0;
  assign led_r3 = 0;


  top_n_clic hippo (
      .clk,
      .led  (led1),
      .reset(tmp_sw1)
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
    // led2 <= r_count[20];
  end

endmodule

