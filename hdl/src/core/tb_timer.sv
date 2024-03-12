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

  word csr_direct_out;
  word csr_out;
  logic interrupt_clear;
  logic interrupt_set;

  TimerT timer;

  timer dut (
      // in
      .clk,
      .reset,
      .csr_enable,
      .csr_addr,
      .csr_op,
      .rs1_zimm,
      .rs1_data,
      .ext_data,
      .ext_write_enable,
      .interrupt_set,
      .interrupt_clear,
      .csr_direct_out,
      .csr_out
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

    #120;
    $display("<< interrupt_set %d", interrupt_set);
    assert (interrupt_set == 1);

    #20;
    $display("<< interrupt_set %d", interrupt_set);
    assert (interrupt_set == 1);

    $display(">> interrupt_clear");
    interrupt_clear = 1;
    $display("<< interrupt_set %d (not yet clocked)", interrupt_set);
    assert (interrupt_set == 1);

    #20;
    $display("<< interrupt_set %d (cleared after clock)", interrupt_set);
    assert (interrupt_set == 0);

    #40;
    $display("<< interrupt_set %d", interrupt_set);
    assert (interrupt_set == 1);

    #20;
    $display("<< interrupt_set %d (auto clear since interrupt_clear still 1)", interrupt_set);
    assert (interrupt_set == 0);

    $finish;
  end
endmodule
