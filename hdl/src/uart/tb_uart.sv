// tb_uart
`timescale 1ns / 1ps

import config_pkg::*;
import decoder_pkg::*;
import arty_pkg::*;

module tb_uart;

  logic clk;
  logic reset;
  word prescaler;
  word csr_data_out;
  logic have_next;
  logic csr_enable;
  CsrAddrT csr_addr;
  csr_op_t csr_op;
  r rs1_zimm;
  word rs1_data;
  logic rts;
  logic tx;
  byte fifo_data;
  logic next;
  PrioT level;

  fifo fifo (
      .clk_i(clk),
      .reset_i(reset),
      .next(next),
      .csr_enable,
      .csr_addr,
      .rs1_zimm,
      .rs1_data,
      .csr_op,
      .level,
      .data(fifo_data),
      .csr_data_out,
      .have_next
  );

  uart uart (
      .clk_i(clk),
      .reset_i(reset),
      .prescaler(prescaler),
      .d_in(fifo_data),
      .rts(have_next),
      .tx(tx),
      .next(next)
  );

  always #10 clk = ~clk;

  initial begin
    $dumpfile("uart.fst");
    $dumpvars;

    clk = 0;
    prescaler = 0;
    csr_enable = 0;
    csr_addr = FifoByteCsrAddr;
    csr_op = CSRRW;
    rs1_data = 0;
    rs1_zimm = 1;
    level = 3;
    reset = 1;
    #20;
    reset = 0;
    #20;
    level = 2;
    csr_enable = 1;
    rs1_data = 'h41;

    #20;
    rs1_data = 'h42;

    #20;
    rs1_data = 'h43;

    #20;
    level = 3;
    csr_enable = 0;

    #80;
    level = 2;
    csr_enable = 1;
    rs1_data = 'h41;

    #20;
    rs1_data = 0;

    #20;
    rs1_data = 'h43;

    #20;
    level = 3;
    csr_enable = 0;


    // last test
    #80;
    level = 2;
    csr_enable = 1;
    rs1_data = 'h41;

    #20;
    rs1_data = 0;

    #20;
    level = 1;
    rs1_data = 'h43;

    #20;
    level = 2;
    csr_enable = 0;

    #20 csr_enable = 1;
    rs1_data = 'h44;

    #20;

    level = 3;
    csr_enable = 0;





    #500000;
    $finish;
  end
endmodule
