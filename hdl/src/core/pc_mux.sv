// pc mux
package pc_mux_pkg;
  typedef enum {
    NEXT,
    BRANCH
  } t_state;
endpackage

module pc_mux import pc_mux_pkg::*;
(

    input t_state select,
    input logic [31:0] next,
    input logic [31:0] branch,
    output logic [31:0] out
);
  always @(select, next, branch) begin
    case (select)
      pc_mux_pkg::NEXT: out <= next;
      BRANCH: out <= branch;
    endcase
  end
endmodule
