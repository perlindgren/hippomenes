// alu

import decoder_pkg::*;
module alu (
    input logic [31:0] a,
    input logic [31:0] b,
    input logic sub_arith,
    input alu_op_t op,

    output logic [31:0] res
);

  always begin
    case (op)
      ALU_ADD:  res = a + b;
      ALU_SLL:  res = a << b[4:0];
      ALU_SLT:  res = {31'(0), $signed(a) < $signed(b)};
      ALU_SLTU: res = {31'(0), $unsigned(a) < $unsigned(b)};
      ALU_EXOR: res = a ^ b;
      ALU_SR:   if (sub_arith) res = $signed(a) >>> b[4:0];
 else res = a >> b[4:0];
      ALU_OR:   res = a | b;
      ALU_AND:  res = a & b;
      default:  res = 0;
    endcase
  end

endmodule
