// branch_logic
`timescale 1ns / 1ps

import decoder_pkg::*;
module branch_logic (
    input word a,
    input word b,
    input logic branch_always,
    input logic branch_instr,
    input branch_op_t op,

    output pc_branch_mux_t out
);
  logic take;

  always_comb begin
    case (op)
      BL_BEQ:  take = (a == b);
      BL_BNE:  take = !(a == b);
      BL_BLT:  take = $signed(a) < $signed(b);
      BL_BGE:  take = !($signed(a) < $signed(b));
      BL_BLTU: take = $unsigned(a) < $unsigned(b);
      BL_BGEU: take = !($unsigned(a) < $unsigned(b));
      default: take = 0;
    endcase

    out = pc_branch_mux_t'(branch_always || (branch_instr && take));
  end

endmodule
