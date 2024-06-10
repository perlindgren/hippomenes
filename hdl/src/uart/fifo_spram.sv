// fifo_spram
`timescale 1ns / 1ps

import decoder_pkg::*;
module fifo_spram (
    input logic clk_i,
    input logic reset_i,
    input logic next,
    input logic csr_enable,
    input CsrAddrT csr_addr,
    input r rs1_zimm,
    input word rs1_data,
    input csr_op_t csr_op,
    input PrioT level,

    input CsrAddrT vcsr_addr,
    input vcsr_width_t vcsr_width,
    input vcsr_offset_t vcsr_offset,
    output logic [7:0] data,
    output word csr_data_out,
    output logic have_next
);
  logic [7:0] buffer[2];
  FifoPtrT in_ptr;
  FifoPtrT out_ptr;
  FifoPtrT mem_in_ptr;
  FifoPtrT mem_out_ptr;
  logic [7:0] data_in;
  logic [1:0] buffer_ptr;
  spram_block #(
      .MemFileName("data_0.mem")
  ) block_0 (
      .clk(clk_i),
      .reset(reset_i),
      .address(spram_addr),
      .write_enable(spram_we),
      .data_in(spram_din),
      .data_out(spram_dout)
  );
  always_comb begin
    data = buffer[0];
  end

  always_ff @(posedge clk_i) begin
    if (reset_i) begin
      mem_ptr <= 0;
      in_ptr <= 0;
      out_ptr <= 0;
      buffer_ptr <= 0;
      buffer <= '{default: 0};
    end else begin
      spram_we <= 0;
      if (csr_enable == 1 && csr_addr == FifoByteCsrAddr) begin
        if (buffer_in_ptr < 2) begin
          buffer[buffer_in_ptr] <= data_in;
          buffer_in_ptr <= buffer_in_ptr + 1;
        end else begin
          spram_addr <= mem_in_ptr;
          spram_we   <= 1;
          mem_in_ptr <= mem_in_ptr + 1;
        end
      end
    end
  end

endmodule
