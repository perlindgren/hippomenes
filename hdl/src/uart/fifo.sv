// uart
`timescale 1ns / 1ps


module fifo
  import config_pkg::*;
  import decoder_pkg::*;
(
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
    //input logic cmp,
    output logic [7:0] data,
    output word csr_data_out,
    output logic have_next
);
  logic [7:0] queue[FifoQueueSize];
  FifoPtrT in_ptr;
  FifoPtrT out_ptr;
  PrioT old_level;

  word data_int;
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
      .vcsr_addr,
      .vcsr_width,
      .vcsr_offset,
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

  FifoPtrT tmp_in_ptr;
  FifoPtrT sentinel_ptr;
  FifoPtrT frame_end_ptr;
  always_ff @(posedge clk_i) begin
    if (reset_i) begin
      queue <= '{default: 0};
      in_ptr <= 0;
      out_ptr <= 0;
      frame_end_ptr <= 0;
      old_level <= PrioNum - 1;
    end else begin
      tmp_in_ptr = in_ptr;
      if (level != old_level) begin
        // we have changed context
        old_level <= level;
        // update last sentinel
        queue[sentinel_ptr] <= (in_ptr - sentinel_ptr) - 1;
        queue[in_ptr] <= 0;  // end packet sentinel
        frame_end_ptr <= in_ptr + 1;
        // queue[in_ptr+1] <= 0;  // new packet sentinel placeholder
        queue[in_ptr+2] <= level;  // interrupt level
        sentinel_ptr <= in_ptr + 1;  // pointer to new packet sentinel
        tmp_in_ptr = tmp_in_ptr + 3;  // next free
      end
      if (csr_enable == 1 && csr_addr == FifoWordCsrAddr) begin
        // TODO: for now just bytes
        queue[tmp_in_ptr]   <= data_int[7:0];
        queue[tmp_in_ptr+1] <= data_int[15:8];
        queue[tmp_in_ptr+2] <= data_int[23:16];
        queue[tmp_in_ptr+3] <= data_int[31:24];
        tmp_in_ptr = tmp_in_ptr + 1;
      end
      if (csr_enable == 1 && csr_addr == FifoByteCsrAddr) begin
        if (byte_data_int[7:0] == 0 || in_ptr - sentinel_ptr == FifoQueueSize - 1) begin
          queue[sentinel_ptr] <= (in_ptr - sentinel_ptr) - 1;
          sentinel_ptr <= in_ptr;
        end
        queue[tmp_in_ptr] <= byte_data_int[7:0];
        tmp_in_ptr = tmp_in_ptr + 1;
      end
      if (frame_end_ptr != out_ptr) begin
        have_next <= 1;
      end else have_next <= 0;
      if (next) out_ptr <= out_ptr + 1;
      in_ptr <= tmp_in_ptr;
    end
  end
endmodule
