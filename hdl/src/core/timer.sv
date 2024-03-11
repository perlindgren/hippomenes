// timer
`timescale 1ns / 1ps

//  Programmable timer peripheral
module timer
  import config_pkg::*;
  import decoder_pkg::*;

(
    input logic clk,
    input logic reset,

    input logic csr_enable,
    input CsrAddrT csr_addr,
    input csr_op_t csr_op,
    input r rs1_zimm,
    input word rs1_data,

    // external access for side effects
    input  TimerT ext_data,
    input  logic  ext_write_enable,
    output word   direct_out,
    output word   out
);

  csr #(
      .CsrWidth(TimerTWidth)
  ) csr_timer (
      // in
      .clk,
      .reset,

      .csr_enable,
      .csr_addr,
      .csr_op,
      .rs1_zimm,
      .rs1_data,

      // external access for side effects
      .ext_data,
      .ext_write_enable,
      // out
      .direct_out,
      .out
  );

  always_ff @(posedge clk) begin
    // if (reset) mono_timer <= 0;
    // else mono_timer <= mono_timer + 1;
  end
endmodule
