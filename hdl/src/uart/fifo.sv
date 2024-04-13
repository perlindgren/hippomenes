// uart
`timescale 1ns / 1ps

module fifo (
    input logic clk_i,
    input logic reset_i,
    input logic next,
    input logic csr_enable,
    input CsrAddrT csr_addr,
    input csr_op_t csr_op,
    input r rs1_zimm,
    input word rs1_data,
    //input logic cmp,
    output word data,
    output word csr_data_out,
    output logic have_next
);
  import decoder_pkg::*;
  word data_int;
  word queue[FifoQueueSize];  // 32 word queue, should be parametric
  logic [FifoPtrSize:0] in_ptr;
  logic [FifoPtrSize:0] out_ptr;
  csr #(
      .CsrWidth(32),
      .Addr(FifoCsrAddr)
  ) csr (
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
      if (csr_enable == 1 && csr_addr == FifoCsrAddr) begin
        queue[in_ptr] <= data_int;
        in_ptr <= in_ptr + 1;
      end
      if (in_ptr != out_ptr) begin
        have_next <= 1;
        //out_ptr   <= out_ptr + 1;
      end else have_next <= 0;
      if (next) out_ptr <= out_ptr + 1;
    end
  end
endmodule
