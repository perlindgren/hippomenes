// csr, individual register

`timescale 1ns / 1ps

import decoder_pkg::*;

// Notice, we assume csrwidth to be at lest 5 bits
// in order to simplify the code
module csr #(
    parameter integer unsigned CsrWidth = 32,  // default to word
    localparam type CsrDataT = logic [CsrWidth-1:0],  // derived
    parameter logic [CsrWidth-1:0] ResetValue = 0,

    parameter csr_addr_t Addr = 0,
    parameter logic Read = 1,
    parameter logic Write = 1
) (
    input logic clk,
    input logic reset,
    input logic csr_enable,
    input csr_addr_t csr_addr,
    input csr_op_t csr_op,
    input r rs1_zimm,
    input word rs1_data,

    // external access for side effects
    input CsrDataT ext_data,
    input logic ext_write_enable,
    output word out  // should prehaps be [CsrWidth-1:0]?
);
  CsrDataT data;
  CsrDataT tmp;

  always_comb begin
    if (csr_enable && (csr_addr == Addr) && Write) begin
      tmp = data;
      case (csr_op)
        CSRRW: begin
          // side effect on read/write here
          $display("CSR WRITE %h", rs1_data);
          tmp = CsrDataT'(rs1_data);
        end
        CSRRS: begin  // set only if rs1 != x0
          if (rs1_zimm != 0) begin
            // side effect here
            tmp = data | CsrDataT'(rs1_data);
          end
        end
        CSRRC: begin  // clear only if rs1 != x0
          if (rs1_zimm != 0) begin
            // write side effect here
            tmp = data & ~(CsrDataT'(rs1_data));
          end
        end
        CSRRWI: begin
          // use rs1_zimm as immediate
          // write side effect here
          tmp = CsrDataT'($unsigned(rs1_zimm));
        end
        CSRRSI: begin
          // use rs1_zimm as immediate
          if (rs1_zimm != 0) begin
            // write side effect here
            tmp = data | CsrDataT'($unsigned(rs1_zimm));
          end
        end
        CSRRCI: begin
          // use rs1_zimm as immediate
          if (rs1_zimm != 0) begin
            // write side effect here
            tmp = data & (~CsrDataT'($unsigned(rs1_zimm)));
          end
        end
        default: ;
      endcase
    end else tmp = Read && (csr_addr == Addr) ? data : 0;
  end

  always out = 32'($unsigned(tmp));

  always_ff @(posedge clk) begin
    if (reset) begin
      data <= ResetValue;
    end else if (ext_write_enable) begin
      // here we do side effect write
      $display("--- ext data ---");
      data <= ext_data;
    end else data <= tmp;
  end

endmodule
