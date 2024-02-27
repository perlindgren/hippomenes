// pc_mux
`timescale 1ns / 1ps

import decoder_pkg::*;
module pc_mux (
    input pc_mux_t sel,
    input word pc_next,
    input word pc_branch,
    output word out
);

  always begin
    case (sel)
      PC_NEXT:   out = pc_next;
      PC_BRANCH: out = pc_branch;
      default:   out = pc_next;
    endcase
  end

endmodule
