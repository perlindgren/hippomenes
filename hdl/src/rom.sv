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
  assign data_out = mem[address[IMemAddrWidth-1:2]];

`ifdef VERILATOR
  string  error_msg;
  integer errno;
  integer fd;
`endif

  // loading binary
  initial begin
    for (integer k = 0; k < IMemSize >> 2; k++) begin
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
