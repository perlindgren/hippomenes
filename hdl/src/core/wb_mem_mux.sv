// wb_mux
`timescale 1ns / 1ps

import decoder_pkg::*;
module wb_mem_mux (
    input wb_mem_mux_t sel,
    input word other_data,
    input word memory_data,
    output word out
);

  always_comb begin
    case (sel)
      WB_OTHER: out = other_data;
      WB_MEM:   out = memory_data;
      default:  out = other_data;
    endcase
  end

endmodule
