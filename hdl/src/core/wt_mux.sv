// alu_a_mux
`timescale 1ns / 1ps

import decoder_pkg::*;
module wt_mux (
    input  logic sel,
    input  word  rf_data,
    input  word  wt_data,
    output word  out
);

  always_comb begin
    if (sel) begin
      out = wt_data;
    end else begin
      out = rf_data;
    end
  end

endmodule
