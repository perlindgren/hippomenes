// Configuration

package config_pkg;

  // Instruction memory configuration
  parameter integer IMemStart = 'h0000_0000;
  parameter integer IMemSize = 'h0000_1000;


  // Data memory configuration
  parameter integer DMemStart = 'h0001_0000;
  parameter integer DMemSize = 'h0000_1000;

  localparam integer IMemAddrWidth = $clog2(IMemSize);  // derived
  localparam integer DMemAddrWidth = $clog2(DMemSize);  // derived

endpackage
