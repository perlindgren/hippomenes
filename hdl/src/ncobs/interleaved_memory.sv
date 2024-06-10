
// mem
`timescale 1ns / 1ps

module interleaved_memory
  import config_pkg::*;
  import mem_pkg::*;
(
    input logic clk,
    input logic reset,
    // input logic write_enable,
    input [FifoEntryWidthSize:0] write_width,
    input logic [FifoAddrWidth-1:0] write_addr,
    input logic [FifoAddrWidth-1:0] read_addr,
    input logic [FifoEntryWidthBits-1:0] data_in,
    input logic write_enable,
    output logic [7:0] data_out
);
  logic [7:0] block_n_dout[FifoEntryWidth];
  logic [7:0] block_n_din[FifoEntryWidth];
  logic [FifoBlockAddrWidth-1:0] block_n_write_addr[FifoEntryWidth];
  logic [FifoBlockAddrWidth-1:0] block_n_read_addr[FifoEntryWidth];
  logic block_n_we[FifoEntryWidth];

  generate
    for (genvar k = 0; k < FifoEntryWidth; k++) begin : gen_blocks
      sdpram_block #(
          .FifoSizeBits(FifoBlockSize * 8),
          .AddrSize(FifoBlockAddrWidth)
      ) block (
          .clk(clk),
          .reset(reset),
          .address_read(read_addr >> 3),
          .address_write(block_n_write_addr[k]),
          .write_enable(block_n_we[k]),
          .data_in(block_n_din[k]),
          .data_out(block_n_dout[k])
      );
    end
  endgenerate
  always_comb begin
    block_n_we  = '{default: 0};
    block_n_din = '{default: 0};
    for (integer i = 0; i < FifoEntryWidth; i++) begin
      if ((write_addr % FifoEntryWidth) > i) begin
        block_n_write_addr[i] = (write_addr >> 3) + 1;
      end else begin
        block_n_write_addr[i] = (write_addr >> 3);
      end
    end
    for (integer i = 0; i < FifoEntryWidth; i++) begin
      automatic
      logic [FifoEntryWidthSize:0]
      ptr =
        ((write_addr+i)%FifoEntryWidth) < FifoEntryWidth ?
        ((write_addr+i)%FifoEntryWidth) :
        ((write_addr+i)%FifoEntryWidth) - FifoEntryWidth;
      if (i < (write_width)) begin
        if (write_enable) begin
          block_n_we[ptr] = 1;
        end else begin
          block_n_we[ptr] = 0;
        end
      end else begin
        block_n_we[ptr] = 0;
      end
    end
    for (integer i = 0; i < FifoEntryWidth; i++) begin
      automatic logic [FifoEntryWidthSize-1:0] ptr = (write_addr % FifoEntryWidth) + i;
      block_n_din[ptr] = data_in >> ((write_width - 1 - i) * 8);
    end

    data_out = block_n_dout[read_addr%FifoEntryWidth];
  end
endmodule
