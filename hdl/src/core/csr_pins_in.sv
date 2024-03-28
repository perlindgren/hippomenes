// csr_pins_in

`timescale 1ns / 1ps

import decoder_pkg::*;

module csr_pins_in (
    input logic clk,
    input logic reset,
    input logic csr_enable,
    input CsrAddrT csr_addr,
    input r rs1_zimm,
    input word rs1_data,
    input csr_op_t csr_op,

    input CsrDataT ext_data,
    input logic ext_write_enable,

    output word out,
    input  InT  pins_in
);

  // TODO!: This does not work yet

  //   word direct_out;  // currently not used
  //   csr #(
  //       .CsrWidth(InWidth),
  //       .Addr(InAddr)
  //   ) csr_led (
  //       // in
  //       .clk,
  //       .reset,
  //       .csr_enable,
  //       .csr_addr,
  //       .rs1_zimm,
  //       .rs1_data,
  //       .csr_op,
  //       .ext_data,
  //       .ext_write_enable,
  //       // out
  //       .direct_out,
  //       .out
  //   );

  assign out = 32'($unsigned(pins_in));

endmodule
