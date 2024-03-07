// pc_mux
`timescale 1ns / 1ps

import decoder_pkg::*;
module pc_mux #(
    parameter integer unsigned AddrWidth = 32,
    localparam type AddrT = logic [AddrWidth-1:0]
) (
    input pc_mux_t sel,
    input AddrT pc_next,
    input AddrT pc_branch,
    output AddrT out
);

  always_comb begin
    case (sel)
      PC_NEXT:   out = pc_next;
      PC_BRANCH: out = pc_branch;
      default:   out = pc_next;
    endcase
  end

endmodule
