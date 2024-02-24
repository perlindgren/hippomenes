module reg_n #(
    parameter DataWidth = 32
) (
    input logic clk,
    input logic reset,
    input logic [DataWidth -1:0] in,
    output logic [DataWidth -1:0] out
);
  logic [DataWidth -1:0] data;

  always_ff @(posedge clk) begin
    if (reset) data <= 0;
    else data <= in;

  end

  assign out = data;

endmodule
