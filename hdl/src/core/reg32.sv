module reg32 (
    input logic clk,
    input logic reset,
    input logic [31:0] in,
    output logic [31:0] out
);
  logic [31:0] pc_reg;

  always_ff @(posedge clk) begin
    if (reset) pc_reg <= 0;
    else pc_reg <= in;

  end

  assign out = pc_reg;

endmodule
