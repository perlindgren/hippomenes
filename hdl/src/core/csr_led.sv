// csr, led
// Should later be put in GPIO

`timescale 1ns / 1ps

import decoder_pkg::*;

module csr_led #(
    localparam integer unsigned CsrWidth = 1,  // default to word
    localparam type CsrDataT = logic [CsrWidth-1:0]  // derived
) (

    input logic clk,
    input logic reset,
    input logic csr_enable,
    input csr_addr_t csr_addr,
    input r rs1_zimm,
    input word rs1_data,
    input csr_op_t csr_op,
    // output logic match,
    input CsrDataT ext_data,
    input logic ext_write_enable,
    output word out,
    output logic led
);

  csr #(
      // .ResetValue(1),  // sanity testing of ResetValue
      .CsrWidth(CsrWidth),
      .Addr(0)
  ) csr_led (
      .clk,
      .reset,
      .csr_enable,
      .csr_addr,
      .rs1_zimm,
      .rs1_data,
      .csr_op,
      .ext_data,
      .ext_write_enable,
      .out(out)
  );

  assign led = csr_led.data[0];

endmodule
