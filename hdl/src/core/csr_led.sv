// csr, individual register

`timescale 1ns / 1ps

import decoder_pkg::*;

module csr_led #(
    parameter word DefaultValue = 0
) (
    input logic clk,
    input logic reset,
    input logic en,
    input r rs1,
    input r rd,
    input csr_t op,
    input word in,
    output word old,
    output logic led
);
  csr csr_led (
      .clk(clk),
      .reset(reset),
      .en(en),
      .rs1(rs1),
      .rd(rd),
      .op(op),
      .in(in),
      .old(old)
  );

  assign led = csr_led.data[0];

endmodule
