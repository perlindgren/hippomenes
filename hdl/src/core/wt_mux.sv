// alu_a_mux
`timescale 1ns / 1ps

import decoder_pkg::*;
module wt_mux (
    input wt_mux_sel_t sel,
    input word rf_data,
    input word wt_data,
    output word out
);

  always_comb begin
    case (sel)
      WT_RF_OUT: out = rf_data;
      WT_RF_IN:  out = wt_data;
      WT_MAGIC:  out = ~0;
      default:   out = 0;
    endcase
  end

endmodule
