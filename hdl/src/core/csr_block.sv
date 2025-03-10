//csr_block
`timescale 1ns / 1ps
import config_pkg::*;

module csr_block
  import config_pkg::*;
#(
    parameter integer unsigned blocks = 8,
    parameter integer unsigned CsrAddr = 'h4FF
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
CsrAddrT csr_out;
csr #(
    .Addr('h4FF),
    .CsrWidth(12)
) addr_csr (
    .clk,
    .reset,
    .csr_enable,
    .csr_addr,
    .rs1_zimm,
    .rs1_data,
    .csr_op,
    .vcsr_width,
    .vcsr_offset,
    .vcsr_addr,
    .ext_write_enable('0),
    .ext_data('0),
    // out
    .direct_out(csr_out)
    //.out()
);
CsrAddrT blocked_csr [blocks];
logic [$clog2(blocks)-1:0] id;
logic blocked_csr_is_full;
always_ff @(posedge clk) begin
    if (reset) begin
        blocked_csr <= '{default: '0};
        id <= 0;
        blocked_csr_is_full <= 0;
    end 
    if (csr_addr == CsrAddr && blocked_csr_is_full == 0) begin
        blocked_csr[id] <= csr_out;
        id += 1;
        if (id == 0) begin
            blocked_csr_is_full = 1;
        end
    end
end

logic [blocks-1:0] block_vec;
generate
    for (genvar k = 0; k < blocks; k++) begin
        always_comb begin
            block_vec[k] = 1;
            if (csr_addr == blocked_csr[k] && k < id) begin
                block_vec[k] = 0;
            end
        end
    end
endgenerate

always_comb begin
    csr_enable_out = &block_vec && csr_enable;
end

endmodule