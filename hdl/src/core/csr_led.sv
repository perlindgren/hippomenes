// csr, led
// Should later be put in GPIO

`timescale 1ns / 1ps

import decoder_pkg::*;

module csr_led (
    input logic clk,
    input logic reset,
    input logic en,
    input csr_addr_t addr,
    input r rs1,
    input r rd,
    input csr_t op,
    input word in,
    output logic match,
    output word out,
    output logic led
);

  csr #(
      // .ResetValue(0), sanity testing of ResetValue
      .Addr(0)
  ) csr_led (
      .clk(clk),
      .reset(reset),
      .en(en),
      .addr(addr),
      .rs1(rs1),
      .rd(rd),
      .op(op),
      .in(in),
      .match(match),
      .out(out)
  );

  assign led = csr_led.data[0];

endmodule
