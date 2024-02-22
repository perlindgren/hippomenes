// branch_logic

import decoder_pkg::*;
module branch_logic (
    input logic [31:0] a,
    input logic [31:0] b,
    input branch_op_t op,

    output logic res
);

  always begin
    case (op)
      BL_BEQ:  res = a == b;
      BL_BNE:  res = !(a == b);
      BL_BLT:  res = $signed(a) < $signed(b);
      BL_BGE:  res = !($signed(a) < $signed(b));
      BL_BLTU: res = $unsigned(a) < $unsigned(b);
      BL_BGEU: res = !($unsigned(a) < $unsigned(b));
      default: res = 0;
    endcase
  end

endmodule
