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
    output word old,
    output logic led
);
  csr #(
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
      .old(old)
  );

  assign led = csr_led.data[0];

endmodule
