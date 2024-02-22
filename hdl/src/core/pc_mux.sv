// pc_mux

import decoder_pkg::*;
module pc_mux (
    input pc_mux_t sel,
    input logic [31:0] pc_next,
    input logic [31:0] pc_branch,
    output logic [31:0] out
);

  always begin
    case (sel)
      PC_NEXT:   out = pc_next;
      PC_BRANCH: out = pc_branch;
      default:   out = pc_next;
    endcase
  end

endmodule
