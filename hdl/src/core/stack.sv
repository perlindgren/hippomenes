// stack
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

  // push and pop cannot occur during same cycle
  always_ff @(posedge clk) begin
    if (reset) begin
      index <= StackDepthWidth'(StackDepth - 1);  // growing towards lower index
    end else if (pop) begin
      $display("--- pop ---");
      index <= index + 1;
    end else if (push) begin
      $display("--- push ---");
      data[index-1] <= data_in;
      index <= index - 1;
    end
  end

  assign data_out  = data[index];
  assign index_out = index;

endmodule




