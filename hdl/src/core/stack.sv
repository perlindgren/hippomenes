// mem
`timescale 1ns / 1ps


module stack
  import decoder_pkg::*;
#(
    parameter integer unsigned StackDepth = 8,
    localparam integer StackDepthWidth = $clog2(StackDepth),  // derived

    parameter integer unsigned DataWidth = 8
) (
    input  logic                       clk,
    input  logic                       reset,
    input  logic                       push,
    input  logic                       pop,
    input  logic [      DataWidth-1:0] data_in,
    output logic [      DataWidth-1:0] data_out,
    output logic [StackDepthWidth-1:0] index_out
);

  logic [      DataWidth-1:0] data  [StackDepth];
  logic [StackDepthWidth-1:0] index;

  // not sure if <= should be used instead...
  always_ff @(posedge clk) begin
    if (reset) begin
      index = StackDepthWidth'(StackDepth - 1);  // growing towards lower index
      data[index] = 0;
    end else if (push) begin
      index -= 1;  // yes we allow wrapping
      data[index] = data_in;
    end else if (pop) begin
      index += 1;
    end

  end

  assign data_out  = data[index];
  assign index_out = index;


endmodule




