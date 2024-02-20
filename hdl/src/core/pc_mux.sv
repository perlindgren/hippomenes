// pc mux

module PcMux (
    input logic select,
    input logic [31:0] next,
    input logic [31:0] branch,
    output logic [31:0] out
);
  always @(select, next, branch) begin
    case (select)
      0: out <= next;
      1: out <= branch;
    endcase
  end
endmodule
