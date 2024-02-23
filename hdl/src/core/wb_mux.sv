// wb_mux

import decoder_pkg::*;
module wb_mux (
    input wb_mux_t sel,
    input word alu,
    input word dm,
    output word out
);

  always begin
    case (sel)
      WB_ALU:  out = alu;
      WB_DM:   out = dm;
      default: out = alu;
    endcase
  end

endmodule
