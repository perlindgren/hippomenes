// wb_mux

import decoder_pkg::*;
module wb_mux (
    input wb_mux_t sel,
    input logic [31:0] alu,
    input logic [31:0] dm,
    output logic [31:0] out
);

  always begin
    case (sel)
      WB_ALU:  out = alu;
      WB_DM:   out = dm;
      default: out = alu;
    endcase
  end

endmodule
