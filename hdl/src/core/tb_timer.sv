// tb_timer
`timescale 1ns / 1ps

module tb_timer;
  import decoder_pkg::*;
  import config_pkg::*;

  logic clk;
  logic reset;
  logic csr_enable;
  CsrAddrT csr_addr;
  csr_op_t csr_op;
  r rs1_zimm;
  word rs1_data;

  // external access for side effects
  TimerT ext_data;
  logic ext_write_enable;
  word direct_out;
  word out;

  TimerT timer;

  timer dut (
      .clk,
      .reset,
      .csr_enable,
      .csr_addr,
      .csr_op,
      .rs1_zimm,
      .rs1_data,

      // external access for side effects
      .ext_data,
      .ext_write_enable,
      .direct_out,
      .out
  );

  always #10 begin
    clk = ~clk;
    if (clk) $display(">>> ", $time);
  end

  initial begin
    $dumpfile("timer.fst");
    $dumpvars;

    csr_addr = TimerAddr;

    clk = 0;
    reset = 1;
    #15;
    reset = 0;

    // setup timer configuration
    timer.prescaler = 0;
    timer.counter_top = 4;
    dut.csr_timer.data = timer;

    #30;

    #200;

    $finish;
  end
endmodule
