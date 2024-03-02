// csr, individual register

`timescale 1ns / 1ps

import decoder_pkg::*;

module csr #(
    parameter word ResetValue = 0,
    parameter csr_addr_t Addr = 0,
    parameter logic Read = 1,
    parameter logic Write = 1
) (
    input logic clk,
    input logic reset,
    input logic en,
    input csr_addr_t addr,
    input csr_t op,
    input r rs1_zimm,
    input word rs1_data,
    // output logic match,
    output word out
);
  word data;

  // asynchronous read, side effect (if any) later
  assign out = Read && (addr == Addr) ? data : 0;

  always @(posedge clk) begin
    if (reset) begin
      data = ResetValue;
      // match = 0;
      // out  = 0;
    end else begin
      if (en && (addr == Addr)) begin
        // here we can do side effect on both read and write

        // match = 1;
        if (Write) begin
          case (op)
            CSRRW: begin
              data = rs1_data;
            end
            CSRRS: begin
              data = data | rs1_data;
            end
            CSRRC: begin
              data = data & ~rs1_data;
            end
            CSRRWI: begin
              // use rs1_zimm as immediate
              data = 32'($unsigned(rs1_zimm));
            end
            CSRRSI: begin
              // use rs1_zimm as immediate
              data = data | 32'($unsigned(rs1_zimm));
            end
            CSRRCI: begin
              // use rs1_zimm as immediate
              data = data & (~32'($unsigned(rs1_zimm)));
            end
            default: ;  // data <= data;
          endcase
        end

      end else begin
        // match = 0;
        // out   = 0;  // needed?
      end
    end
  end

endmodule
