// config_pkg
`timescale 1ns / 1ps

package config_pkg;

  // Instruction memory configuration
  parameter integer unsigned IMemStart = 'h0000_0000;
  parameter integer unsigned IMemSize = 'h0000_0100;  // in bytes

  // Data memory configuration
  parameter integer unsigned DMemStart = 'h0001_0000;
  parameter integer unsigned DMemSize = 'h0000_1000;  // in bytes

  localparam integer unsigned IMemAddrWidth = $clog2(IMemSize);  // derived
  localparam integer unsigned DMemAddrWidth = $clog2(DMemSize);  // derived

endpackage
