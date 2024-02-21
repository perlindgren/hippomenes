// alu_b_mux

import decoder_pkg::*;
module alu_b_mux (
    input alu_b_mux_t sel,
    input logic [31:0] rs2,
    input logic [31:0] imm_ext,
    input logic [31:0] pc_plus_4,
    input logic [31:0] pc,

    output logic [31:0] out
);

  always begin
    case (select)
      RS2: out = rs2;
      IMM_EXT: out = imm_ext;
      PC_PLUS_4: out = pc_plus_4;
      PC: out = PC;
      default: out = rs2;
    endcase
  end

endmodule
