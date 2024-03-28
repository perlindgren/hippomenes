// csr_pins_out
// Should later be put in GPIO

`timescale 1ns / 1ps

import decoder_pkg::*;

module csr_pins_out (
    input logic clk,
    input logic reset,
    input logic csr_enable,
    input CsrAddrT csr_addr,
    input r rs1_zimm,
    input word rs1_data,
    input csr_op_t csr_op,

    output word out,
    output OutT pins_out
);
  word direct_out;  // currently not used
  csr #(
      .CsrWidth(OutWidth),
      .Addr(OutAddr)
  ) csr_led (
      // in
      .clk,
      .reset,
      .csr_enable,
      .csr_addr,
      .rs1_zimm,
      .rs1_data,
      .csr_op,
      .ext_data(0),
      .ext_write_enable(0),
      // out
      .direct_out,
      .out
  );

  assign pins_out = OutT'(out);

endmodule
