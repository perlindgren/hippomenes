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
  vcsr_offset_t out_offset;
  vcsr_width_t out_width;

  vcsr dut (
      .clk,
      .reset,
      .rs1_data,
      .csr_addr,
      .rs1_zimm,
      .csr_enable,
      .csr_op,
      .out_addr,
      .out_offset,
      .out_width
  );
  word dut_csr_direct_out;
  word dut_csr_out;
  csr #(
      .Addr(20),
      .CsrWidth(32)
  ) dut_csr (
      .clk,
      .reset,
      .csr_enable,
      .csr_addr,
      .csr_op,
      .rs1_zimm,
      .rs1_data,
      .ext_write_enable(0),
      .ext_data(0),
      .vcsr_addr(out_addr),
      .vcsr_offset(out_offset),
      .vcsr_width(out_width),

      .direct_out(dut_csr_direct_out),
      .out(dut_csr_out)
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

    assert (out_addr == 'h100);
    csr_addr = 'h100;
    csr_op = CSRRW;
    csr_enable = 1;
    rs1_data = 'b1010001100101;

    #20;

    csr_addr = 20;
    csr_op   = CSRRW;
    rs1_data = 'hFFFFFFFF;

    #20;
    assert (dut_csr_direct_out == 'hFFFFFFFF);
    assert (out_addr == 'h100);

    csr_addr = 'h110;
    csr_op = CSRRWI;
    csr_enable = 1;
    rs1_zimm = 'b10101;
    #20;
    assert (out_addr == 20);
    assert (dut_csr_direct_out == 'hFFFF5FFF);

    csr_addr = 'h09F;
    #20;
    assert (out_addr == 'h100);
    assert (dut_csr_direct_out == 'hFFFF5FFF);

    csr_addr = 'h110;
    csr_op   = CSRRSI;
    rs1_zimm = 'b00010;

    #20;
    assert (out_addr == 20);
    assert (dut_csr_direct_out == 'hFFFF7FFF);

    csr_addr = 'h120;

    #20;
    assert (out_addr == 'h100);

    csr_addr = 'h110;
    csr_op   = CSRRCI;
    rs1_zimm = 'b00100;
    #20;

    assert (out_addr == 20);
    $display("%h", dut_csr_direct_out);
    assert (dut_csr_direct_out == 'hFFFF3FFF);

    #20;
    $finish;


  end
endmodule
