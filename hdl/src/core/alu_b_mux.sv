// alu_b_mux

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
      RS2: out = rs2;
      IMM_EXT: out = imm;
      PC_PLUS_4: out = pc_plus_4;
      PC: out = pc;
      default: out = rs2;
    endcase
  end

endmodule
