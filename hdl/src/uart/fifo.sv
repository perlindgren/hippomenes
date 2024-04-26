// uart
`timescale 1ns / 1ps

`include "../config_pkg.sv"
`include "../core/decoder_pkg.sv"

module fifo
  import config_pkg::*;
  import decoder_pkg::*;
(
    input logic clk_i,
    input logic reset_i,
    input logic next,
    input logic [7:0] data_i,
    input logic write_enable,
    //input logic cmp,
    output logic [7:0] data,
    output logic have_next
);
  word data_int;
  //word queue[FifoQueueSize];  // 32 word queue, should be parametric
  logic [7:0] queue[FifoQueueSize];
  logic [FifoPtrSize-1:0] in_ptr;
  logic [FifoPtrSize-1:0] out_ptr;

  always_comb begin
    data = queue[out_ptr];
  end

  always_ff @(posedge clk_i) begin
    if (reset_i) begin
      //data_internal <= 0;
      queue   <= '{default: 0};
      in_ptr  <= 0;
      out_ptr <= 0;
    end else begin
      if (write_enable) begin
        queue[in_ptr] <= data_i;
        in_ptr <= in_ptr + 1;
      end
      if (in_ptr != out_ptr) begin
        have_next <= 1;
      end else have_next <= 0;
      if (next) out_ptr <= out_ptr + 1;
    end
  end
endmodule
