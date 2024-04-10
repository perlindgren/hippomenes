// fpga_icebreaker
`timescale 1ns / 1ps


module top (
    input  CLK,
    output LED1
);
  logic [31:0] r_count;

  logic a;
  logic b;
  logic s;
  logic c;

  always_comb begin
    a = 0;
    b = 1;
  end

  adder adder_inst (
      .a(a),
      .b,
      .s,
      .c
  );

  // clock devider
  always @(posedge CLK) begin
    r_count <= r_count + 1;
    LED1 <= r_count[22];
  end

endmodule
