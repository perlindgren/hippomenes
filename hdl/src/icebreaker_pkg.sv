// icebreaker_pkg
`timescale 1ns / 1ps

package icebreaker_pkg;
  import config_pkg::*;

  // Led
  localparam CsrAddrT LedAddr = 'h000;
  localparam integer unsigned LedWidth = 5;
  localparam type LedT = logic [LedWidth-2:0];

  // Buttons
  localparam CsrAddrT BtnAddr = 'h001;
  localparam integer unsigned BtnWidth = 4;
  localparam type BtnT = logic [BtnWidth-1:0];

endpackage
