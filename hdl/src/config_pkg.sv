// Configuration

package config_pkg;
  parameter integer DMemStart = 'h0000_0000;
  parameter integer DMemSize  = 'h0000_1000;

  localparam integer DMemAddrWidth = $clog2(DMemSize); // derived

endpackage