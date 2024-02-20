// Instruction decoder

module Decoder (
    input logic [31:0] instruction,
    output logic pc_mux
);
  assign pc_mux = 1;
endmodule
