// pc mux

module pc_mux
  import pc_mux_pkg::*;
(

    input state_t select,
    input logic [31:0] next,
    input logic [31:0] branch,
    output logic [31:0] out
);

  always begin
    case (select)
      NEXT: out = next;
      BRANCH: out = branch;
      default: out = next;
    endcase
  end

endmodule
