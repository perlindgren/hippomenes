// d_mem
`timescale 1ns / 1ps

`include "arty_pkg.sv"
`include "core/decoder_pkg.sv"
`include "config_pkg.sv"
`include "mem_pkg.sv"

module d_mem
  import arty_pkg::*;
  import decoder_pkg::*;
  import config_pkg::*;
  import mem_pkg::*;
(
    input logic clk,
    input logic reset,
    // input logic write_enable,
    input mem_width_t width,
    input logic sign_extend,
    input logic [DMemAddrWidth-1:0] addr,
    input logic [31:0] data_in,
    input logic write_enable,
    output logic [31:0] data_out,
    output logic [31:0] imem_out
);

  d_mem_spram dut (
      .clk(clk),
      .reset(reset),
      .addr(address),
      .width(width),
      .sign_extend(sign_extend),
      .write_enable(write_enable),
      .data_in(data_in),
      .data_out(data_out)
  );

  spram imem (
      .clk,
      .reset,
      .address,
      .data_out(imem_out)
  );


endmodule
