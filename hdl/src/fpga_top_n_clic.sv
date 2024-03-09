// fpga_top
`timescale 1ns / 1ps

// This is just illustrative
module fpga_top_n_clic (
    input sysclk,
    output logic led,
    output logic led2
);

  logic clk;

  logic [31:0] r_count;
  logic reset = 0;
  logic locked;

  top_n_clic hippo (
        .clk,
        .led  (led2),
        .reset(0)
  );

  clk_wiz_0 clk_gen (
      // Clock in ports
      .clk_in1(sysclk),
      // Clock out ports
      .clk_out1(clk),
      // Status and control signals
      .reset,
      .locked
  );

  // clock devider
  always @(posedge clk) begin
    r_count <= r_count + 1;
    led <= r_count[22];
    // led2 <= r_count[20];
  end

endmodule

