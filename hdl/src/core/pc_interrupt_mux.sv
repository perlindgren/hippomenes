// pc_interrupt_mux
`timescale 1ns / 1ps

import decoder_pkg::*;
module pc_interrupt_mux #(
    parameter integer unsigned AddrWidth = 32,
    localparam type AddrT = logic [AddrWidth-1:0]
) (
    input  pc_interrupt_mux_t sel,
    input  AddrT              pc_normal,
    input  AddrT              pc_interrupt,
    output AddrT              out
);

  always_comb begin
    case (sel)
      PC_NORMAL:    out = pc_normal;
      PC_INTERRUPT: out = pc_interrupt;
      default:      out = pc_normal;
    endcase
  end

endmodule
