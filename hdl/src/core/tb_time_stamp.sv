// tb_time_stamp
`timescale 1ns / 1ps

module tb_time_stamp;
  import config_pkg::*;
  import decoder_pkg::*;

  logic clk;
  logic reset;
  logic pend[VecSize];

  TimeStampT vec_stamp[VecSize];
  CsrAddrT csr_addr;
  word csr_out;
  MonoTimerT mono_timer;

  mono_timer mono_timer_inst (
      .clk,
      .reset,
      .mono_timer
  );

  time_stamp dut (
      // in
      .clk,
      .reset,
      .mono_timer,
      .pend,
      .csr_addr,
      // out
      .csr_out
  );

  always #10 begin
    $display($time);
    clk = ~clk;
  end

  // function static void dump();
  //   for (integer k = 0; k < VecSize; k++) begin
  //     $display("stamp[%d] %d", k, vec_stamp[k]);
  //   end
  // endfunction

  initial begin
    $dumpfile("time_stamp.fst");
    $dumpvars;

    pend = '{default: 0};
    csr_addr = TimeStampCsrBase;  // first time stamp register

    clk = 0;
    reset = 1;
    #15;
    reset = 0;

    $display("mono_timer %d", mono_timer);

    #20;

    $display("mono_timer %d", mono_timer);

    #200;
    $display("mono_timer %d", mono_timer);

    pend[1]  = 1;
    csr_addr = TimeStampCsrBase + 1;
    $display("pend 1 time %d", mono_timer);
    $display("csr_out %d = %d", csr_addr, csr_out);
    #1;
    $display("#1");
    $display("csr_out %d = %d", csr_addr, csr_out);
    #19;
    $display("#19 (clock)");
    $display("csr_out %d = %d", csr_addr, csr_out);

    #20;

    $display("csr_out %d = %d", csr_addr, csr_out);
    pend[1]  = 0;
    csr_addr = TimeStampCsrBase + 2;
    #1;
    $display("csr_out %d = %d", csr_addr, csr_out);
    $display("pend[1] = 1");
    $display("pend[2] = 1");

    pend[1] = 1;  // glitch on pend1 will be ignored as sampled on rising edge
    pend[2] = 1;
    $display("csr_out %d = %d", csr_addr, csr_out);

    #19;
    $display("--- here ---");

    $display("csr_out %d = %d", csr_addr, csr_out);
    csr_addr = TimeStampCsrBase + 1;
    #1;
    $display("csr_out %d = %d", csr_addr, csr_out);



    #20;
    $display("csr_out %d", csr_out);
    csr_addr = TimeStampCsrBase + 2;
    #1;
    $display("csr_out %d = %d", csr_addr, csr_out);




    // dump();
    // assert (vec_stamp[1] == 5);
    // pend[1] = 0;

    // #19;

    // pend[1] = 1;
    // pend[2] = 1;
    // #1;
    // dump();
    // assert (vec_stamp[1] == 5);
    // assert (vec_stamp[2] == 5);

    // pend[1] = 0;
    // pend[2] = 0;

    // #19;

    // #200;
    // pend[1] = 1;
    // #1;
    // dump();
    // assert (vec_stamp[1] == 11);
    // assert (vec_stamp[2] == 5);

    // #19;
    // pend[2] = 1;
    // #1;
    // dump();

    // assert (vec_stamp[1] == 11);
    // assert (vec_stamp[2] == 11);

    $finish;
  end
endmodule
