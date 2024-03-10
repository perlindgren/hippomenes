// tb_stack
`timescale 1ns / 1ps

module tb_time_stamp;
  import config_pkg::*;

  logic clk;
  logic reset;
  logic pend[VecSize];
  TimeStampT vec_stamp[VecSize];

  time_stamp dut (
      // in
      .clk,
      .reset,
      .pend,
      // out
      .vec_stamp
  );

  always #10 begin
    $display($time);
    clk = ~clk;
  end

  function static void dump();
    for (integer k = 0; k < VecSize; k++) begin
      $display("stamp[%d] %d", k, vec_stamp[k]);
    end
  endfunction

  initial begin
    $dumpfile("time_stamp.fst");
    $dumpvars;

    pend  = '{default: 0};

    clk   = 0;
    reset = 1;
    #15;
    reset = 0;

    #200;
    $display("time %d", dut.timer);

    pend[1] = 1;
    $display("pend time %d", dut.timer);
    #1;
    dump();
    assert (vec_stamp[1] == 5);
    pend[1] = 0;

    #19;

    pend[1] = 1;
    pend[2] = 1;
    #1;
    dump();
    assert (vec_stamp[1] == 5);
    assert (vec_stamp[2] == 5);

    pend[1] = 0;
    pend[2] = 0;

    #19;

    #200;
    pend[1] = 1;
    #1;
    dump();
    assert (vec_stamp[1] == 11);
    assert (vec_stamp[2] == 5);

    #19;
    pend[2] = 1;
    #1;
    dump();

    assert (vec_stamp[1] == 11);
    assert (vec_stamp[2] == 11);

    $finish;
  end
endmodule
