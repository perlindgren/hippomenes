// alu_a_mux
`timescale 1ns / 1ps

import decoder_pkg::*;
module alu_a_mux (
    input alu_a_mux_t sel,
    input word imm,
    input word rs1,
    input word zero,
    output word out
);

  always_comb begin
    case (sel)
      A_IMM:   out = imm;
      A_RS1:   out = rs1;
      A_ZERO:  out = zero;
      default: out = imm;
    endcase
  end

endmodule
