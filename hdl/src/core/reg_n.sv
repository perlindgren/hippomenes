module reg_n #(
    parameter DataWidth = 32
) (
    input logic clk,
    input logic reset,
    input logic [DataWidth -1:0] in,
    output logic [DataWidth -1:0] out
);
  logic [DataWidth -1:0] pc_reg;

  always_ff @(posedge clk) begin
    if (reset) pc_reg <= 0;
    else pc_reg <= in;

  end

  assign out = pc_reg;

endmodule
