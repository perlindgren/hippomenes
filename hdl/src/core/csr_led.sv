// csr, led
// Should later be put in GPIO

`timescale 1ns / 1ps

import decoder_pkg::*;

module csr_led (
    input logic clk,
    input logic reset,
    input logic en,
    input csr_addr_t addr,
    input r rs1_zimm,
    input word rs1_data,
    input csr_t op,
    output logic match,
    output word out,
    output logic led
);

  csr #(
      // .ResetValue(1),  // sanity testing of ResetValue
      .Addr(0)
  ) csr_led (
      .clk(clk),
      .reset(reset),
      .en(en),
      .addr(addr),
      .rs1_zimm(rs1_zimm),
      .rs1_data(rs1_data),
      .op(op),
      .match(match),
      .out(out)
  );

  assign led = csr_led.data[0];

endmodule
