// alu_b_mux
`timescale 1ns / 1ps

import decoder_pkg::*;
module alu_b_mux (
    input alu_b_mux_t sel,
    input word rs2,
    input word imm,
    input word pc_plus_4,
    input word pc,

    output word out
);

  always begin
    case (sel)
      B_RS2: out = rs2;
      B_IMM_EXT: out = imm;
      B_PC_PLUS_4: out = pc_plus_4;
      B_PC: out = pc;
      default: out = rs2;
    endcase
  end

endmodule
