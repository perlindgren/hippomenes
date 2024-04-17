// tb_mem
`timescale 1ns / 1ps

`include "arty_pkg.sv"
`include "core/decoder_pkg.sv"
`include "config_pkg.sv"
`include "mem_pkg.sv"

module tb_d_mem;
  import arty_pkg::*;
  import decoder_pkg::*;
  import config_pkg::*;
  import mem_pkg::*;

  logic clk;
  DMemAddrT address;
  logic [31:0] data_out;
  logic reset;
  logic write_enable;
  logic [31:0] data_in;
  logic sign_extend;
  mem_width_t width;

  d_mem_spram dut (
      .clk(clk),
      .reset(reset),
      .addr(address),
      .width(width),
      .sign_extend(sign_extend),
      .write_enable(write_enable),
      .data_in(data_in),
      .data_out(data_out)
  );

  word imem_out;
  spram imem (
      .clk,
      .reset,
      .address,
      .data_out(imem_out)
  );

  always #10 clk = ~clk;

  initial begin
    $dumpfile("d_mem.fst");
    $dumpvars;
    reset = 1;
    clk = 0;
    write_enable = 0;
    address = 0;
    sign_extend = 0;
    width = mem_width_t'(WORD);
    data_in = 'hBAD01928;

    #10;
    reset = 0;

    #10;

    assert (data_out == 'h03020100);

    address = 4;

    #20;

    assert (data_out == 'h04030201);

    address = 8;

    #20;

    assert (data_out == 'h05040302);

    address = 12;

    #20;

    assert (data_out == 'h06050403);

    address = 1;

    #20;

    assert (data_out == 'h01030201);

    address = 2;

    #20;

    assert (data_out == 'h02010302);

    address = 3;

    #20;

    assert (data_out == 'h03020103);

    width   = mem_width_t'(BYTE);
    address = 0;

    #20;



    address = 1;

    #20;

    address = 2;

    #20;

    address = 3;

    #20;

    address = 4;

    #20;

    address = 5;

    #20;

    address = 6;

    #20;

    address = 7;

    #20;

    address = 8;

    #20;

    address = 9;

    #20;

    address = 10;

    #20;

    address = 11;

    #20;
    width   = mem_width_t'(HALFWORD);
    address = 0;

    #20;

    address = 1;

    #20;

    address = 2;

    #20;

    address = 3;

    #20;

    address = 4;

    #20;

    address = 5;

    #20;

    address = 6;

    #20;

    address = 7;

    #20;

    address = 8;

    #20;

    address = 9;

    #20;

    address = 10;

    #20;

    address = 0;








    write_enable = 1;
    width = mem_width_t'(WORD);

    #20;

    write_enable = 0;

    #20;

    address = 4;
    write_enable = 1;
    width = mem_width_t'(BYTE);

    #20;

    write_enable = 0;
    width = mem_width_t'(WORD);

    #20;

    address = 8;
    write_enable = 1;
    width = mem_width_t'(HALFWORD);

    #20;

    write_enable = 0;
    width = mem_width_t'(WORD);

    #20;

    $finish;
  end
endmodule
