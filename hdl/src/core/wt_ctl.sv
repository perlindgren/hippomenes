// wb_mux
`timescale 1ns / 1ps

import decoder_pkg::*;
module wt_ctl (
    input clk,
    input reset,
    input r rd,
    input r rs1,
    input r rs2,
    output word rs1_sel,
    output logic rs2_sel
);
  r rd_old;
  always_ff @(posedge clk) begin
    if (reset) begin
      rd_old <= 0;
    end
    rd_old <= rd;

  end
  always_comb begin
    if (rd_old == rs1) begin
      rs1_sel = 1;  //write through
    end else begin
      rs1_sel = 0;  // regular
    end
    if (rd_old == rs2) begin
      rs2_sel = 1;  // write through
    end else begin
      rs2_sel = 0;  // regular
    end
  end

endmodule
