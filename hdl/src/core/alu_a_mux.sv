// alu_a_mux

import decoder_pkg::*;
module alu_a_mux (
    input alu_a_mux_t sel,
    input logic [31:0] imm,
    input logic [31:0] rs1,
    input logic [31:0] zero,
    output logic [31:0] out
);

  always begin
    case (sel)
      IMM: out = imm;
      RS1: out = rs1;
      ZERO: out = zero;
      default: out = imm;
    endcase
  end

endmodule
