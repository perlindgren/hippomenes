// tb_di_mem
`timescale 1ns / 1ps
import config_pkg::*;
import decoder_pkg::*;
import arty_pkg::*;
module tb_uart;
/*
  logic clk;
  logic reset;
  word  prescaler;
  word  d_in;
  logic rts;
  logic tx;
  uart u (
      .clk(clk),
      .reset(reset),
      .prescaler(prescaler),
      .d_in(d_in),
      .rts(rts),
      .tx(tx)
  );

  always #10 clk = ~clk;

  initial begin
    $dumpfile("uart.fst");
    $dumpvars;
    clk = 0;
    reset = 1;
    prescaler = 1;
    d_in = 'h12345678;
    rts = 1;
    #100;
    reset = 0;
    #10_000;

    $finish;
  end
*/
  logic clk;
  logic reset;
  word  prescaler;
  word csr_data_out;
  logic have_next;
  logic csr_enable;
  CsrAddrT csr_addr;
  csr_op_t csr_op;
  r rs1_zimm;
  word rs1_data;
  logic rts;
  logic tx;
  word fifo_data;
  fifo fifo (
    .clk_i(clk),
    .reset_i(reset),
    .next(next),
    .csr_enable,
    .csr_addr,
    .rs1_zimm,
    .rs1_data,
    .csr_op,
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
      .tx(rx),
      .next(next)
  );
  always #10 clk = ~clk;
  initial begin
    clk = 0;
    prescaler = 0;
    csr_enable = 1;
    csr_addr = 'h50;
    csr_op = CSRRW;
    rs1_data = 'h12345678;
    rs1_zimm = 1;
    reset = 1;
    #20;
    reset = 0;
    #20;
    rs1_data = 'hDEADBEEF;
    #20;
    rs1_data = 'h13371337;
    #20;
    csr_enable = 0;
    #50000;
    $finish;
  end
endmodule
