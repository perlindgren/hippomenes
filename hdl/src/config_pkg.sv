// Configuration

package config_pkg;

  // Instruction memory configuration
  parameter integer unsigned IMemStart = 'h0000_0000;
  parameter integer unsigned IMemSize = 'h0000_1000;

  // Data memory configuration
  parameter integer unsigned DMemStart = 'h0001_0000;
  parameter integer unsigned DMemSize = 'h0000_1000;

  localparam integer unsigned IMemAddrWidth = $clog2(IMemSize);  // derived
  localparam integer unsigned DMemAddrWidth = $clog2(DMemSize);  // derived

  // Move to common?
  typedef reg [31:0] word;

endpackage
