// vcsr
`timescale 1ns / 1ps

module vcsr
  import decoder_pkg::*;
  import config_pkg::*;
#(
    // parameter integer unsigned VcsrAmount = 16,  // default to 16
    //  parameter CsrAddrT VcsrBase = 'h100  // default to 100
) (
    input logic clk,
    input logic reset,
    input word rs1_data,
    input CsrAddrT csr_addr,
    input r rs1_zimm,
    input logic csr_enable,
    input csr_op_t csr_op,
    output CsrAddrT out_addr,
    output vcsr_offset_t out_offset,
    output vcsr_width_t out_width
);
  typedef struct packed {
    CsrAddrT addr;
    vcsr_offset_t offset;
    vcsr_width_t width;
  } config_entry_t;
  config_entry_t cfg_direct_out[VcsrAmount];
  word cfg_out[VcsrAmount];
  generate
    word temp_cfg_out[VcsrAmount];
    word temp_cfg_direct_out[VcsrAmount];
    for (genvar k = 0; k < VcsrAmount; k++) begin : gen_cfg
      csr #(
          .Addr(VcsrBase + CsrAddrT'(k)),
          .CsrWidth(32)
      ) csr_cfg (
          .clk,
          .reset,
          .csr_enable,
          .csr_addr,
          .csr_op,
          .rs1_zimm,
          .rs1_data,
          .ext_write_enable(0),
          .ext_data(0),

          .vcsr_addr  (0),
          .vcsr_width (0),
          .vcsr_offset(0),

          .direct_out(temp_cfg_direct_out[k]),
          .out(temp_cfg_out[k])
      );
      assign cfg_direct_out[k] = config_entry_t'(temp_cfg_direct_out[k]);
      assign cfg_out[k] = temp_cfg_out[k];
    end

  endgenerate
  vcsr_idx_t idx;
  always_comb begin
    if (word'(csr_addr) < (word'(VcsrBase) + VcsrAmount * 2) && word'(csr_addr) >= (word'(VcsrBase) + VcsrAmount)) begin
      idx = vcsr_idx_t'(csr_addr) - vcsr_idx_t'(VcsrBase);
      out_addr = cfg_direct_out[idx].addr;
      out_offset = cfg_direct_out[idx].offset;
      out_width = cfg_direct_out[idx].width;
    end else begin
      out_addr = VcsrBase;  // ensure vcsr doesn't do a write in this case
      // by setting the out address to an internal VCSR CSR (these are not
      // accessible via VCSR)
      idx = 0;
      out_offset = 0;
      out_width = 0;
    end
  end
endmodule

