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
  localparam integer unsigned IMemSize = 'h0000_8000;  // in bytes

  localparam integer unsigned IMemDataWidth = 32;  // in bits
  localparam type IMemDataT = logic [IMemDataWidth -1:0];

  // Data memory configuration
  localparam integer unsigned DMemStart = 'h0001_0000;
  localparam integer unsigned DMemSize = 'h0000_8000;  // in bytes
  localparam integer unsigned DMemDataWidth = 8;  // byte RW
  localparam type DMemDataT = logic [DMemDataWidth -1:0];
  // Read-only memory configuratioe
  localparam integer unsigned RomStart = 'h0002_0000;
  localparam integer unsigned RomSize = 'h0000_0500;  // in bytes
  localparam integer unsigned RomDataWidth = 8;  // in bits
  localparam type RomDataT = logic [RomDataWidth-1:0];

  // Memory related
  localparam integer unsigned IMemAddrWidth = $clog2(IMemSize);
  localparam integer unsigned DMemAddrWidth = $clog2(DMemSize);
  localparam integer unsigned RomAddrWidth = $clog2(RomSize);
  localparam type IMemAddrT = logic [IMemAddrWidth-1:0];
  localparam type DMemAddrT = logic [DMemAddrWidth-1:0];
  localparam type RomAddrT = logic [RomAddrWidth-1:0];

  // Interrupt priorities
  localparam integer unsigned PrioNum = 8;
  localparam integer unsigned PrioWidth = $clog2(PrioNum);
  localparam type PrioT = logic [PrioWidth-1:0];

    // csr Interrupt priorities
  localparam integer unsigned CsrPrioNum = 4;
  localparam integer unsigned CsrPrioWidth = $clog2(PrioNum);
  localparam type CsrPrioT = logic [PrioWidth-1:0];

  // N-CLIC configuration
  localparam integer unsigned VecSize = 9;
  localparam integer unsigned VecWidth = $clog2(VecSize);
  localparam type VecT = logic [VecWidth-1:0];

  // CSR Related
  localparam type CsrAddrT = logic [11:0];

  localparam CsrAddrT VecCsrBase = 'hb00;  // up to 32 vectors
  localparam CsrAddrT EntryCsrBase = 'hb20;
  localparam CsrAddrT TimeStampCsrBase = 'hb40;

  // General CSR registers
  localparam CsrAddrT MStatusAddr = 'h300;
  localparam CsrAddrT MIntThreshAddr = 'h347;
  localparam CsrAddrT StackDepthAddr = 'h350;
  localparam integer unsigned MStatusWidth = 4;
  localparam type MStatusT = logic [MStatusWidth-1:0];
  // VCSR
  localparam integer unsigned VcsrAmount = 16;
  localparam CsrAddrT VcsrBase = 'h100;
  localparam integer unsigned MaxFieldWidth = 32;  // widest field accessible via VCSR
  localparam integer unsigned MaxOffset = 31;  // larger than 31 makes no sense on a 32bit arch
  typedef logic [$clog2(MaxOffset)-1:0] vcsr_offset_t;
  typedef logic [$clog2(MaxFieldWidth)-1:0] vcsr_width_t;
  typedef logic [$clog2(VcsrAmount)-1:0] vcsr_idx_t;
  // Peripheral timer
  localparam CsrAddrT TimerAddr = 'h400;
  localparam integer unsigned TimerWidth = 16;
  localparam integer unsigned TimerPreWith = 4;
  localparam integer unsigned TimerCounterWidth = TimerWidth + 2 ** TimerPreWith;
  localparam type TimerCounterT = logic [TimerCounterWidth-1:0];
  localparam type TimerWidthT = logic [TimerWidth-1:0];
  localparam type TimerPresWidthT = logic [TimerPreWith-1:0];

  typedef struct packed {
    TimerWidthT counter_top;
    TimerPresWidthT prescaler;  // LSB
  } TimerT;

  // Monotonic timer
  localparam integer unsigned MonoTimerWidth = 32;
  localparam integer unsigned MonoTimerWidthBytes = MonoTimerWidth / 8;
  localparam type MonoTimerT = logic [MonoTimerWidth-1:0];
  localparam integer unsigned TimerTWidth = $bits(TimerT);

  // Time-stamp configuration
  localparam integer unsigned TimeStampWidth = 32;
  localparam integer unsigned TimeStampPreScaler = 0;
  localparam type TimeStampT = logic [TimeStampWidth-1:0];

  localparam integer unsigned FifoQueueSize = 'h8000;
  localparam integer unsigned FifoEntryWidth = 8;
  localparam type FifoDataT = logic [FifoEntryWidth-1:0][7:0];
  localparam type FifoDataIdxT = logic [$clog2(FifoEntryWidth):0];
  localparam integer unsigned FifoEntryWidthBits = FifoEntryWidth * 8;
  localparam integer unsigned FifoBlockSize = FifoQueueSize / FifoEntryWidth;
  localparam integer unsigned FifoAddrWidth = $clog2(FifoQueueSize);
  localparam integer unsigned FifoBlockAddrWidth = $clog2(FifoQueueSize / FifoEntryWidth);
  localparam integer unsigned FifoPtrSize = $clog2(FifoQueueSize);
  localparam integer unsigned FifoEntryWidthSize = $clog2(FifoEntryWidth - 1);
  localparam type FifoPtrT = logic [FifoPtrSize -1:0];
  localparam integer unsigned FifoDataWidth = 8;
  localparam CsrAddrT FifoWordCsrAddr = 'h50;
  localparam CsrAddrT FifoByteCsrAddr = 'h51;
  localparam integer unsigned CoreFreq = 10000000;
  // localparam integer unsigned CoreFreq = 230400;
  localparam integer unsigned UartBaudRate = 115200;
  localparam integer unsigned UartCmpVal = CoreFreq / UartBaudRate;

endpackage
