// csr, led
// Should later be put in GPIO

`timescale 1ns / 1ps

import config_pkg::*;

module csr_gpio (
    input logic clk,
    input logic reset,
    input logic csr_enable,
    input CsrAddrT csr_addr,
    input r rs1_zimm,
    input word rs1_data,
    input csr_op_t csr_op,

    // output logic match,
    input GpioT ext_data,
    input logic ext_write_enable,

    // io
    input GpioT direction,
    input GpioT gpio_in,

    output GpioT gpio_out,
    output word  out
);

  word data;
  word direct_out;  // currently not used

  csr #(
      .CsrWidth(GpioNum),
      .Addr(GpioCsrData)
  ) csr_gpio (
      // in
      .clk,
      .reset,
      .csr_enable,
      .csr_addr,
      .rs1_zimm,
      .rs1_data,
      .csr_op,
      .ext_data,
      .ext_write_enable,
      // out
      .direct_out,
      .out
  );

  always_comb begin
    for (integer k = 0; k < GpioNum; k++) begin
      // if (direction[k]) data[k] = out[k] else data[k] = io_in[k];
    end
  end


endmodule
