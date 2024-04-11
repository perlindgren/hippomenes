// rom
`timescale 1ns / 1ps

module rom
  import config_pkg::*;
(
    input logic clk,
    input IMemAddrT address,
    output IMemDataT data_out
);

  IMemDataT mem[IMemSize >> 2];
  IMemDataT tmp_mem[IMemSize >> 2];
  assign data_out = mem[address[IMemAddrWidth-1:2]];

  initial begin
    $readmemh("../../../rust_examples/binary.mem", tmp_mem);
  end

  always_comb begin
    for (integer k = 0; k < IMemSize >> 2; k++) begin
      mem[k] = 0;
      mem[k] = tmp_mem[k];
    end

  end
  // `endif
  //   end

  // TODO: Vivado?
  // `else
  //     $readmemh("binary.mem", mem);
  // `endif

  // always_comb begin

  //   mem[0] = 'h50000117;
  //   mem[1] = 'h50010113;
  //   mem[2] = 'h0000d073;
  //   mem[3] = 'h00005073;
  //   mem[4] = 'hff9ff06f;

  // end


endmodule
