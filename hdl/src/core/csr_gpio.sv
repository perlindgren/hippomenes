// csr, led
// Should later be put in GPIO

`timescale 1ns / 1ps

import decoder_pkg::*;

module csr_gpio_data #(
    localparam integer unsigned CsrWidth = GpioNum,  // default to word
    localparam type CsrDataT = logic [CsrWidth-1:0]  // derived
) (

    input logic clk,
    input logic reset,
    input logic csr_enable,
    input CsrAddrT csr_addr,
    input r rs1_zimm,
    input word rs1_data,
    input csr_op_t csr_op,

    // direction register
    input CsrDataT direction,
    // output logic match,
    input CsrDataT ext_data,
    input logic ext_write_enable,
    output word out,

    // io
    wire CsrDataT io
);

  word direct_out;  // currently not used
  csr #(
      .CsrWidth(CsrWidth),
      .Addr(GpioCrsData)  // 
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
    for (integer k = 0; k < CsrWith; k++) begin
      if (direction[k]) io[k] = out[k];
    end
  end


endmodule
