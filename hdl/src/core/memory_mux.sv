// wb_mux
`timescale 1ns / 1ps

import decoder_pkg::*;
module memory_mux (
    input logic sel,
    input word dm,
    input word rom,
    output word out
);

  always_comb begin
    case (sel)
      0:  out = dm;
      1: out = rom;
      default: out = dm;
    endcase
  end

endmodule
