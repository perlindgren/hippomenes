// config_pkg
`timescale 1ns / 1ps

package arty_pkg;
  import config_pkg::*;

  // Led
  localparam CsrAddrT LedAddr = 'h000;
  localparam integer unsigned LedWidth = 5;
  localparam type LedT = logic [LedWidth-2:0];

  // Buttons
  localparam CsrAddrT BtnAddr = 'h001;
  localparam integer unsigned BtnWidth = 4;
  localparam type BtnT = logic [BtnWidth-1:0];

  // Switches
  localparam CsrAddrT SwAddr = 'h002;
  localparam integer unsigned SwWidth = 4;
  localparam type SwT = logic [SwWidth-1:0];

  // GPIO Related, TODO
  localparam integer unsigned GpioNum = 3;  // We have a gpio bitvec of 3
  localparam type GpioT = logic [GpioNum-1:0];

  typedef enum logic [GpioNum-1:0] {
    LED = GpioT'(0),  // index 0
    TX  = GpioT'(1),
    RX  = GpioT'(2)
  } GpioIndexT;

  localparam CsrAddrT GpioCsrDir = 'h002;
  localparam CsrAddrT GpioCsrData = 'h003;

endpackage
