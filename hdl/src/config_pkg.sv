// config_pkg
`timescale 1ns / 1ps

package config_pkg;

  // Instruction memory configuration
  localparam integer unsigned IMemStart = 'h0000_0000;
  localparam integer unsigned IMemSize = 'h0000_0100;  // in bytes

  // Data memory configuration
  localparam integer unsigned DMemStart = 'h0001_0000;
  localparam integer unsigned DMemSize = 'h0000_1000;  // in bytes

  // N-CLIC configuration
  localparam integer unsigned VecSize = 8;
  localparam integer unsigned PrioLevels = 8;

  localparam integer unsigned IMemAddrWidth = $clog2(IMemSize);  // derived
  localparam integer unsigned DMemAddrWidth = $clog2(DMemSize);  // derived

  localparam type IMemAddrT = logic [IMemAddrWidth-1:0];
  localparam type DMemAddrT = logic [DMemAddrWidth-1:0];

  localparam integer unsigned VecWidth = $clog2(VecSize);
  localparam integer unsigned PrioWidth = $clog2(PrioLevels);

  localparam type VecT = logic [VecWidth-1:0];
  localparam type PrioT = logic [PrioWidth-1:0];

  localparam type CsrAddrT = logic [11:0];
  localparam CsrAddrT VecCsrBase = 'hb00;  // up to 32 vectors
  localparam CsrAddrT EntryCsrBase = 'hb20;
  localparam CsrAddrT TimeStampCsrBase = 'hb40;

  // CSR registers
  localparam CsrAddrT MStatusAddr = 'h305;
  localparam CsrAddrT MIntThreshAddr = 'h347;
  localparam CsrAddrT StackDepthAddr = 'h350;

  // Monotonic timer
  localparam integer unsigned MonoTimerWidth = 32;
  localparam type MonoTimerT = logic [MonoTimerWidth-1:0];

  // Time-stamp configuration
  localparam integer unsigned TimeStampWidth = 8;
  localparam integer unsigned TimeStampPreScaler = 0;
  localparam type TimeStampT = logic [TimeStampWidth-1:0];

endpackage
