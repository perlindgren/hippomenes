// fpga_top
`timescale 1ns / 1ps

module fgpa_top (
    input sysclk,
    output reg led,
    output reg led2
);

  reg [31:0] r_count = 0;
  reg reset_out = 1;

  top hippo (
      .clk  (r_count[22]),  // really slow clock
      .led  (led2),
      .reset(reset_out)
  );


  // clock devider
  always @(posedge sysclk) begin
    if (r_count[2]) reset_out <= 0;
    r_count <= r_count + 1;
    led <= r_count[22];

  end

endmodule

