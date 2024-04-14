// alu
`timescale 1ns / 1ps


module mul (
    input word a,
    input word b,
    input mul_op_t op,

    output word res
);
  import decoder_pkg::*;
  logic [63:0] result_s;
  logic [63:0] result_u;
  logic [63:0] result_su;
  always_comb begin
    result_s  = (signed'(a) * signed'(b));
    result_u  = (unsigned'(a) * unsigned'(b));
    result_su = (signed'(a) * unsigned'(b));
    case (op)
      MUL_MUL: res = result_s[31:0];
      MUL_MULH: res = result_s[63:32];
      MUL_MULHU: res = result_u[63:32];
      MUL_MULHSU: res = result_su[63:32];
      default: res = 0;
    endcase
  end

endmodule
