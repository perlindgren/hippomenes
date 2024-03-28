// config_pkg
`timescale 1ns / 1ps

package config_pkg;
  // General
  localparam integer unsigned RegWidth = 32;
  localparam type RegT = logic [RegWidth-1:0];

  localparam integer unsigned RegNum = 32;
  localparam integer unsigned RegAddrWidth = $clog2(RegNum);
  localparam type RegAddrT = logic [RegAddrWidth-1:0];

  localparam RegAddrT Zero = 0;  // x0
  localparam RegAddrT Ra = 1;  // x1
  localparam RegAddrT Sp = 2;  // x2

  // Instruction memory configuration
  localparam integer unsigned IMemStart = 'h0000_0000;
  localparam integer unsigned IMemSize = 'h0000_1000;  // in bytes

  localparam integer unsigned IMemDataWidth = 32;  // in bits
  localparam type IMemDataT = logic [IMemDataWidth -1:0];

  // Data memory configuration
  localparam integer unsigned DMemStart = 'h0001_0000;
  localparam integer unsigned DMemSize = 'h0000_1000;  // in bytes

  // Memory relatted
  localparam integer unsigned IMemAddrWidth = $clog2(IMemSize);
  localparam integer unsigned DMemAddrWidth = $clog2(DMemSize);
  localparam type IMemAddrT = logic [IMemAddrWidth-1:0];
  localparam type DMemAddrT = logic [DMemAddrWidth-1:0];

  // Interrupt priorities
  localparam integer unsigned PrioNum = 4;
  localparam integer unsigned PrioWidth = $clog2(PrioNum);
  localparam type PrioT = logic [PrioWidth-1:0];

  // N-CLIC configuration
  localparam integer unsigned VecSize = 8;
  localparam integer unsigned VecWidth = $clog2(VecSize);
  localparam type VecT = logic [VecWidth-1:0];

  // CSR Related
  localparam type CsrAddrT = logic [11:0];

  // Led
  localparam CsrAddrT LedAddr = 'h000;
  localparam integer unsigned LedWidth = 4;
  localparam type LedT = logic [LedWidth-1:0];

  // Buttons
  localparam CsrAddrT BtnAddr = 'h001;
  localparam integer unsigned BtnWidth = 4;
  localparam type BtnT = logic [BtnWidth-1:0];

  // Sw
  localparam CsrAddrT SwAddr = 'h002;
  localparam integer unsigned SwWidth = 4;
  localparam type SwT = logic [SwWidth-1:0];

  // GPIO Related, TODO
  localparam GpioNum = 3;  // We have a gpio bitvec of 3 
  localparam type GpioT = logic [GpioNum-1:0];

  typedef enum logic [GpioNum-1:0] {
    LED = GpioT'(0),  // index 0
    TX  = GpioT'(1),
    RX  = GpioT'(2)
  } GpioIndexT;

  localparam CsrAddrT GpioCsrDir = 'h002;
  localparam CsrAddrT GpioCsrData = 'h003;

  localparam CsrAddrT VecCsrBase = 'hb00;  // up to 32 vectors
  localparam CsrAddrT EntryCsrBase = 'hb20;
  localparam CsrAddrT TimeStampCsrBase = 'hb40;

  // General CSR registers
  localparam CsrAddrT MStatusAddr = 'h305;
  localparam CsrAddrT MIntThreshAddr = 'h347;
  localparam CsrAddrT StackDepthAddr = 'h350;

  // Peripheral timer
  localparam CsrAddrT TimerAddr = 'h400;
  localparam integer unsigned TimerWidth = 16;
  localparam integer unsigned TimerPreWith = 4;

  localparam type TimerWidthT = logic [TimerWidth-1:0];
  localparam type TimerPresWidthT = logic [TimerPreWith-1:0];

  typedef struct packed {
    TimerWidthT counter_top;
    TimerPresWidthT prescaler;  // LSB
  } TimerT;

  // Monotonic timer
  localparam integer unsigned MonoTimerWidth = 32;
  localparam type MonoTimerT = logic [MonoTimerWidth-1:0];
  localparam integer unsigned TimerTWidth = $bits(TimerT);

  // Time-stamp configuration
  localparam integer unsigned TimeStampWidth = 8;
  localparam integer unsigned TimeStampPreScaler = 0;
  localparam type TimeStampT = logic [TimeStampWidth-1:0];

endpackage
