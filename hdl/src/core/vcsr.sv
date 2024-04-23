// vcsr
`timescale 1ns / 1ps

module vcsr
  import decoder_pkg::*;
  import config_pkg::*;
#(
    parameter integer unsigned VcsrAmount = 16,  // default to 16
    parameter CsrAddrT VcsrBase = 'h100  // default to 100
) (
    input logic clk,
    input logic reset,
    input word rs1_data,
    input CsrAddrT csr_addr,
    input r rs1_zimm,
    input logic csr_enable,
    input csr_op_t csr_op,
    output CsrAddrT out_addr,
    output word out_data,
    output csr_op_t out_op
);

  typedef logic [$clog2(31)-1:0] offset_t;  // max offset is 31
  typedef logic [$clog2(5)-1:0] width_t;  // immediate max 5 bits
  typedef logic [$clog2(VcsrAmount)-1:0] idx_t;
  typedef struct packed {
    CsrAddrT addr;
    offset_t offset;
    width_t  width;
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

          .direct_out(temp_cfg_direct_out[k]),
          .out(temp_cfg_out[k])
      );
      assign cfg_direct_out[k] = config_entry_t'(temp_cfg_direct_out[k]);
      assign cfg_out[k] = temp_cfg_out[k];
    end

  endgenerate
  offset_t offset;
  width_t width;
  idx_t idx;
  r mask;
  r masked_imm;
  always_comb begin
    if (word'(csr_addr) < (word'(VcsrBase) + VcsrAmount * 2) && word'(csr_addr) >= (word'(VcsrBase) + VcsrAmount)) begin
      idx = idx_t'(csr_addr) - idx_t'(VcsrBase);
      out_addr = cfg_direct_out[idx].addr;
      offset = cfg_direct_out[idx].offset;
      width = cfg_direct_out[idx].width;
      mask = (1 << width) - 1;
      masked_imm = rs1_zimm & mask;
      case (csr_op)
        CSRRWI: begin
          out_op   = CSRRW;
          out_data = word'(masked_imm) << offset;
        end
        CSRRSI: begin
          out_op   = CSRRS;
          out_data = word'(masked_imm) << offset;
        end
        CSRRCI: begin
          out_op   = CSRRC;
          out_data = word'(masked_imm) << offset;
        end
        default: begin
          out_op   = csr_op;
          out_data = rs1_data;
        end
      endcase
    end else begin
      out_addr = csr_addr;
      out_op   = csr_op;
      out_data = rs1_data;
    end
  end
endmodule

