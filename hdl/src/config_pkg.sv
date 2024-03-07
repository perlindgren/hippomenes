// config_pkg
`timescale 1ns / 1ps

package config_pkg;

  // Instruction memory configuration
  localparam integer unsigned IMemStart = 'h0000_0000;
  localparam integer unsigned IMemSize = 'h0000_0100;  // in bytes

  // Data memory configuration
  localparam integer unsigned DMemStart = 'h0001_0000;
  localparam integer unsigned DMemSize = 'h0000_1000;  // in bytes

  localparam integer unsigned IMemAddrWidth = $clog2(IMemSize);  // derived
  localparam integer unsigned DMemAddrWidth = $clog2(DMemSize);  // derived

  localparam type IMemAddrT = logic [IMemAddrWidth-1:0];
  localparam type DMemAddrT = logic [DMemAddrWidth-1:0];

endpackage
