//csr_block
`timescale 1ns / 1ps

module csr_block
  import config_pkg::*;
#(
    parameter integer unsigned blocks = 32
) (
    input logic clk,
    input logic reset,

    // csr registers
    input logic     csr_enable,
    input CsrAddrT  csr_addr,
    input r         rs1_zimm,
    input word      rs1_data,
    input csr_op_t  csr_op,
    
    // VCSR
    input CsrAddrT      vcsr_addr,
    input vcsr_width_t  vcsr_width,
    input vcsr_offset_t vcsr_offset,

    output logic     csr_enable_out
);





logic block;
assign block = 1;
always_comb begin
    csr_enable_out = csr_enable & block;

end

endmodule