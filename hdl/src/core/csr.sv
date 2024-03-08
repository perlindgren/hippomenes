// csr, individual register

`timescale 1ns / 1ps

import decoder_pkg::*;

// Notice, we assume csrwidth to be at lest 5 bits
// in order to simplify the code
(* DONT_TOUCH = "TRUE" *)
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
    input logic ext_write_enable, (* dont_touch = "true" *)
    output word out  // should prehaps be [CsrWidth-1:0]?
);
  (* DONT_TOUCH = "TRUE" *)
  CsrDataT data;

  // asynchronous read
  // we don't currently implement side effect, besides the ext_data
  assign out = Read && (csr_addr == Addr) ? 32'($unsigned(data)) : 0;

  always_ff @(posedge clk) begin
    if (reset) begin
      data <= ResetValue;
    end else if (ext_write_enable) begin
      // here we do side effect write
      $display("--- ext data ---");
      data <= ext_data;
    end else if (csr_enable && (csr_addr == Addr) && Write) begin
      case (csr_op)
        CSRRW: begin
          // side effect on read/write here
          $display("CSR WRITE %h", rs1_data);
          data <= CsrDataT'(rs1_data);
        end
        CSRRS: begin  // set only if rs1 != x0
          if (rs1_zimm != 0) begin
            // side effect here
            data <= data | CsrDataT'(rs1_data);
          end
        end
        CSRRC: begin  // clear only if rs1 != x0
          if (rs1_zimm != 0) begin
            // write side effect here
            data <= data & ~(CsrDataT'(rs1_data));
          end
        end
        CSRRWI: begin
          // use rs1_zimm as immediate
          // write side effect here
          data <= CsrDataT'($unsigned(rs1_zimm));
        end
        CSRRSI: begin
          // use rs1_zimm as immediate
          if (rs1_zimm != 0) begin
            // write side effect here
            data <= data | CsrDataT'($unsigned(rs1_zimm));
          end
        end
        CSRRCI: begin
          // use rs1_zimm as immediate
          if (rs1_zimm != 0) begin
            // write side effect here
            data <= data & (~CsrDataT'($unsigned(rs1_zimm)));
          end
        end
        default: ;
      endcase
    end
  end

endmodule
