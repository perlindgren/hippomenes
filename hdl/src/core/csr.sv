// csr, individual register

`timescale 1ns / 1ps

import decoder_pkg::*;

module csr #(
    parameter word ResetValue = 0,
    parameter csr_addr_t Addr = 0
) (
    input logic clk,
    input logic reset,
    input logic en,
    input csr_addr_t addr,
    input r rs1,
    input r rd,
    input csr_t op,
    input word in,
    output logic match,
    output word out
);
  word data;

  always @(posedge clk) begin
    if (reset) begin
      data  = ResetValue;
      match = 0;
    end else if (en && (addr == Addr)) begin
      out   = data;  // always read
      match = 1;
      case (op)
        CSRRW: begin
          data = in;
        end
        CSRRS: begin
          data = data | in;
        end
        CSRRC: begin
          data = data & ~in;
        end
        CSRRWI: begin
          // use rs1 as immediate
          data = 32'($unsigned(rs1));
        end
        CSRRSI: begin
          // use rs1 as immediate
          data = data | 32'($unsigned(rs1));
        end
        CSRRCI: begin
          // use rs1 as immediate
          data = data & (~32'($unsigned(rs1)));
        end
        default: ;
      endcase
    end else begin
      match = 0;
      out   = 0;  // to avoid latch
    end
  end

endmodule
