// rom
`timescale 1ns / 1ps

module rom
  import config_pkg::*;
  import mem_pkg::*;
#(
    parameter integer unsigned MemSize = 'h0000_1000,
    localparam integer MemAddrWidth = $clog2(MemSize)  // derived
) (
    input logic clk,
    input logic [MemAddrWidth-1:0] address,

    output logic [31:0] data_out
);

  word mem[MemSize >> 2];
  integer errno;
  integer fd;

`ifdef VERILATOR
  string error_msg;
`endif

  assign data_out = mem[address[MemAddrWidth-1:2]];
  initial begin
    for (integer k = 0; k < MemSize >> 2; k++) begin
      mem[k] = 0;
    end
    $display("Loading memory file binary.mem");
`ifdef VERILATOR
    $readmemh("../../rust_examples/binary.mem", mem);
    errno = $ferror(fd, error_msg);
    if (errno == -1 | errno == 2) begin
      $fatal("Could not find binary.mem");
    end
`else
    $readmemh("binary.mem", mem);
`endif

  end

endmodule
