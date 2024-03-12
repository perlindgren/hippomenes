// tb_stack
`timescale 1ns / 1ps

module tb_stack;
  localparam integer unsigned StackDepth = 4;
  localparam integer StackDepthWidth = $clog2(StackDepth);  // derived
  localparam integer unsigned DataWidth = 8;

  logic                       clk;
  logic                       reset;
  logic                       push;
  logic                       pop;

  logic [      DataWidth-1:0] data_in;
  logic [      DataWidth-1:0] data_out;
  logic [StackDepthWidth-1:0] index_out;

  stack #(
      .StackDepth(StackDepth),
      .DataWidth (DataWidth)
  ) dut (
      // in
      .clk,
      .reset,
      .push,
      .pop,
      .data_in,
      // out,
      .data_out,
      .index_out
  );

  always #10 clk = ~clk;

  initial begin
    $dumpfile("stack.fst");
    $dumpvars;

    clk   = 0;
    reset = 1;
    #15;
    reset = 0;
    push  = 0;
    pop   = 0;

    #20;
    $display("index_out %d, data_out %d", index_out, data_out);
    assert (index_out == 3 && data_out == 0);

    // push
    push = 1;
    data_in = 1;
    $display("push %d", data_in);
    #20;
    $display("index_out %d, data_out %d", index_out, data_out);
    assert (index_out == 2 && data_out == 1);

    // no push
    push = 0;
    $display("no pop/push");

    #20;
    $display("index_out %d, data_out %d", index_out, data_out);
    assert (index_out == 2 && data_out == 1);

    // push
    push = 1;
    data_in = 2;
    $display("push %d", data_in);
    #20;
    $display("index_out %d, data_out %d", index_out, data_out);
    assert (index_out == 1 && data_out == 2);

    // push
    push = 1;
    data_in = 3;
    $display("push %d", data_in);
    #20;
    $display("index_out %d, data_out %d", index_out, data_out);
    assert (index_out == 0 && data_out == 3);

    // push
    push = 1;
    data_in = 4;
    $display("push %d", data_in);
    #20;
    $display("index_out %d, data_out %d", index_out, data_out);
    assert (index_out == 3 && data_out == 4);

    // nothing
    push = 0;
    data_in = 4;
    $display("no pop/push");
    #20;
    $display("index_out %d, data_out %d", index_out, data_out);
    assert (index_out == 3 && data_out == 4);

    // pop
    pop = 1;
    $display("pop");
    #20;
    $display("index_out %d, data_out %d", index_out, data_out);
    assert (index_out == 0 && data_out == 3);

    // pop
    pop = 1;
    $display("pop");
    #20;
    $display("index_out %d, data_out %d", index_out, data_out);
    assert (index_out == 1 && data_out == 2);

    // pop
    pop = 1;
    $display("pop");
    #20;
    $display("index_out %d, data_out %d", index_out, data_out);
    assert (index_out == 2 && data_out == 1);

    $finish;
  end
endmodule
