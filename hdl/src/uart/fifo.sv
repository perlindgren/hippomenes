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
    input logic csr_enable,
    input CsrAddrT csr_addr,
    input csr_op_t csr_op,
    input r rs1_zimm,
    input word rs1_data,
    //input logic cmp,
    output logic [7:0] data,
    output word csr_data_out,
    output logic have_next
);
  word data_int;
  //word queue[FifoQueueSize];  // 32 word queue, should be parametric
  logic [7:0] queue[FifoQueueSize];
  logic [FifoPtrSize-1:0] in_ptr;
  logic [FifoPtrSize-1:0] out_ptr;

  // Word
  csr #(
      .CsrWidth(32),
      .Addr(FifoWordCsrAddr)
  ) csr_word (
      .clk(clk_i),
      .reset(reset_i),
      .csr_enable(csr_enable),
      .csr_addr(csr_addr),
      .rs1_zimm(rs1_zimm),
      .rs1_data(rs1_data),
      .csr_op(csr_op),
      .ext_data(0),
      .ext_write_enable(0),
      .direct_out(data_int),
      .out(csr_data_out)
  );

  // Byte 
  word byte_data_int;
  word byte_out;
  csr #(
      .CsrWidth(8),
      .Addr(FifoByteCsrAddr)
  ) csr_byte (
      .clk(clk_i),
      .reset(reset_i),
      .csr_enable(csr_enable),
      .csr_addr(csr_addr),
      .rs1_zimm(rs1_zimm),
      .rs1_data(rs1_data),
      .csr_op(csr_op),
      .ext_data(0),
      .ext_write_enable(0),
      .direct_out(byte_data_int),
      .out(byte_out)
  );

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
      if (csr_enable == 1 && csr_addr == FifoWordCsrAddr) begin
        queue[in_ptr] <= data_int[7:0];
        queue[in_ptr+1] <= data_int[15:8];
        queue[in_ptr+2] <= data_int[23:16];
        queue[in_ptr+3] <= data_int[31:24];
        in_ptr <= in_ptr + 4;
      end
      if (csr_enable == 1 && csr_addr == FifoByteCsrAddr) begin
        queue[in_ptr] <= byte_data_int;
        in_ptr <= in_ptr + 1;
      end
      if (in_ptr != out_ptr) begin
        have_next <= 1;
      end else have_next <= 0;
      if (next) out_ptr <= out_ptr + 1;
    end
  end
endmodule
