// fpga_top
`timescale 1ns / 1ps

// This is just illustrative
module fpga_top_n_clic (
    input sysclk,
    output logic led0,
    output logic led1,
    output logic led2,
    output logic led3,
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

