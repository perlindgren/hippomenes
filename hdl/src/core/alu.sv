// alu
`timescale 1ns / 1ps

import decoder_pkg::*;
module alu (
    input word a,
    input word b,
    input logic sub_arith,
    input alu_op_t op,

    output word res
);

  always_comb begin
    case (op)
      ALU_ADD:
      if (sub_arith) begin
        res = a - b;
      end else begin
        res = a + b;
      end
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
