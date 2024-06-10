// wb_mux
`timescale 1ns / 1ps

import decoder_pkg::*;
module wt_ctl (
    input clk,
    input reset,
    input r rd,
    input r rs1,
    input r rs2,
    input logic writeRaEn,
    input logic writeEn,
    output wt_mux_sel_t rs1_sel,
    output wt_mux_sel_t rs2_sel
);
  r rd_old;
  logic writeRaEn_old;
  /*  always_ff @(posedge clk) begin
    if (reset) begin
      rd_old <= 0;
      writeRaEn_old <= 0;
    end
    rd_old <= rd;
    writeRaEn_old <= writeRaEn;
  end*/

  always_comb begin
    if (rs1 == 0) begin
      rs1_sel = WT_RF_OUT;
    end else if ((rd == rs1) && writeEn) begin
      rs1_sel = WT_RF_IN;  //write through
    end else begin
      rs1_sel = WT_RF_OUT;  // regular
    end
    if (rs2 == 0) begin
      rs2_sel = WT_RF_OUT;
    end else if ((rd == rs2) && writeEn) begin
      rs2_sel = WT_RF_IN;  // write through
    end else begin
      rs2_sel = WT_RF_OUT;  // regular
    end
    if (writeRaEn) begin
      if (rs1 == Ra) begin
        rs1_sel = WT_MAGIC;
      end
      if (rs2 == Ra) begin
        rs2_sel = WT_MAGIC;
      end
    end
  end

endmodule
