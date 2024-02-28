// rom
`timescale 1ns / 1ps

module rom
  import config_pkg::*;
  import mem_pkg::*;
#(
    parameter integer MemSize = 'h0000_1000,
    localparam integer MemAddrWidth = $clog2(MemSize)  // derived
) (
    input reg clk,
    input reg [MemAddrWidth-1:0] address,

    output reg [31:0] data_out
);

  reg [31:0] mem[MemSize >> 2];
 
  always_comb begin
    data_out = mem[address[DMemAddrWidth-1:2]];
  end

  // 00000000 <l>:
  //    0:	b000d073          	.insn	4, 0xb000d073
  //    4:	b0005073          	.insn	4, 0xb0005073
  //    8:	ff9ff06f          	j	0 <l>
  always_comb begin

    mem[0] = 'hb000d073;
    mem[1] = 'hb0005073;
    mem[2] = 'hff9ff06f;

  end

endmodule
