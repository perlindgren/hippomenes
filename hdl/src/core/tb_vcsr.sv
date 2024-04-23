// tb_alu
`timescale 1ns / 1ps

import decoder_pkg::*;
import config_pkg::*;
module tb_vcsr;
  logic reset;
  logic clk;
  logic [31:0] rs1_data;
  CsrAddrT csr_addr;
  r rs1_zimm;
  logic csr_enable;
  csr_op_t csr_op;

  CsrAddrT out_addr;
  logic [31:0] out_data;
  csr_op_t out_op;

  vcsr dut (
      .clk,
      .reset,
      .rs1_data,
      .csr_addr,
      .rs1_zimm,
      .csr_enable,
      .csr_op,
      .out_addr,
      .out_data,
      .out_op
  );
  always #10 begin
    clk = ~clk;
    if (clk) $display(">>> ", $time);
  end
  initial begin
    $dumpfile("vcsr.fst");
    $dumpvars;
    clk = 0;
    reset = 1;
    rs1_data = 0;
    csr_addr = 0;
    rs1_zimm = 0;
    csr_enable = 0;
    csr_op = csr_op_t'(0);
    #20;

    reset = 0;

    #20;

    assert (out_addr == 0);
    assert (out_op == 0);
    csr_addr = 'h100;
    csr_op = CSRRW;
    csr_enable = 1;
    rs1_data = 'b1010001100101;

    #20;

    csr_addr = 'h110;
    csr_op = CSRRWI;
    csr_enable = 1;
    rs1_zimm = 'b10101;
    #20;
    $display("%d", out_addr);
    assert (out_addr == 20);
    assert (out_op == CSRRW);
    assert (out_data == 'b10101000000000000);
    csr_addr = 'h099;
    #20;
    assert (out_addr == 'h099);
    assert (out_op == CSRRWI);
    csr_addr = 'h120;
    #20;
    assert (out_addr == 'h120);
    assert (out_op == CSRRWI);
    $finish;


  end
endmodule
