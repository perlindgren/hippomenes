// pc_mux
`timescale 1ns / 1ps

import decoder_pkg::*;
module pc_mux #(
    parameter integer unsigned AddrWidth = 32
) (
    input pc_mux_t sel,
    input logic [AddrWidth-1:0] pc_next,
    input logic [AddrWidth-1:0] pc_branch,
    output logic [AddrWidth-1:0] out
);

  always_comb begin
    case (sel)
      PC_NEXT:   out = pc_next;
      PC_BRANCH: out = pc_branch;
      default:   out = pc_next;
    endcase
  end

endmodule
