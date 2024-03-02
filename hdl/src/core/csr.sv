// csr, individual register

`timescale 1ns / 1ps

import decoder_pkg::*;

module csr #(
    parameter word DefaultValue = 0
) (
    input logic clk,
    input logic reset,
    input logic en,
    input r rs1,
    input r rd,
    input csr_t op,
    input word in,
    output word old
);
  word data;

  always @(posedge clk) begin
    if (reset) data = 0;
    else if (en) begin
      old = data;  // always read
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
    end
  end

endmodule
