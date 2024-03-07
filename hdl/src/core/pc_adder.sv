// pc_adder
`timescale 1ns / 1ps

module pc_adder #(
    parameter integer unsigned AddrWidth = 32,  // default to word
    localparam type AddrT = logic [AddrWidth-1:0]  // derived
) (
    input  AddrT in,
    output AddrT out
);
  assign out = in + 4;
endmodule

