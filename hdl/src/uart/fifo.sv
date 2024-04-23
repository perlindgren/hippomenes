// fifo
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
    output logic [7:0] data,
    output word csr_data_out,
    output logic have_next
);
  logic [7:0] queue[FifoQueueSize];
  FifoPtrT in_ptr;
  FifoPtrT out_ptr;
  PrioT old_level;

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

  // stack 
  logic    has_zero      [PrioNum];
  byte     length        [PrioNum];
  byte     tmp_length;

  // byte     tmp_length;

  always_ff @(posedge clk_i) begin
    if (reset_i) begin
      queue <= '{default: 0};
      in_ptr <= 0;
      out_ptr <= 0;
      frame_end_ptr <= 0;
      old_level <= PrioT'(PrioNum - 1);
      has_zero <= '{default: 0};  // not strictly needed
      length <= '{default: 0};  // not strictly needed
    end else begin
      tmp_in_ptr = in_ptr;
      tmp_length = length[level];
      if (level < old_level) begin
        // push frame
        has_zero[level] <= 0;
        tmp_length = 0;
      end else if (level > old_level) begin
        // pop frame
        // package length
        queue[tmp_in_ptr]   <= (has_zero[old_level]) ? -length[old_level] : length[old_level] + 1;
        // package delimeter
        queue[tmp_in_ptr+1] <= 0;
        tmp_in_ptr = tmp_in_ptr + 2;
      end

      if (csr_enable == 1 && csr_addr == FifoByteCsrAddr) begin
        // write byte
        // tmp_length = length[level];

        if (byte_data_int[7:0] == 0) begin
          queue[tmp_in_ptr] <= (has_zero[level]) ? -length[level] : length[level] + 1;
          length[level] <= 1;
          has_zero[level] <= 1;
        end else begin
          queue[tmp_in_ptr] <= byte_data_int[7:0];
          length[level] <= tmp_length + 1;
        end

        tmp_in_ptr = tmp_in_ptr + 1;
      end
      if (in_ptr != out_ptr) begin
        have_next <= 1;
      end else have_next <= 0;
      if (next) out_ptr <= out_ptr + 1;
      in_ptr <= tmp_in_ptr;
      old_level <= level;
    end
  end
endmodule
