// tb_csr
`timescale 1ns / 1ps

import decoder_pkg::*;
module tb_csr;

  logic clk;
  logic reset;
  logic en;
  csr_addr_t addr;
  r rs1;
  r rd;
  csr_t op;
  word in;
  word out;
  logic match;

  csr dut (
      // in
      .clk(clk),
      .reset(reset),
      .en(en),
      .addr(addr),
      .rs1(rs1),
      .rd(rd),
      .op(op),
      .in(in),
      // out
      .match(match),
      .out(out)
  );

  always #10 clk = ~clk;

  initial begin
    $dumpfile("csr.fst");
    $dumpvars;

    addr  = 0;  // should match
    reset = 1;
    #15;
    reset = 0;
    #5;

    clk = 0;
    en  = 1;

    in  = 'b1011;
    op  = CSRRW;
    // notice out will be delayed
    $display("CSRRW 'b1011 out %h", out);

    #20;
    $display("wait out %h", out);
    assert (out == 0);
    assert (match == 1);
    in = 'b1100;
    op = CSRRS;
    $display("CSRRS 'b1100 out %h", out);

    #20;
    $display("wait out %h", out);
    assert (out == 'b1011);
    in = 'b1100;
    op = CSRRC;
    $display("CSRRC 'b1100 %h", out);

    #20;
    $display("wait out %h", out);
    assert (out == 'b1111);

    rs1 = 1;
    op  = CSRRWI;
    $display("CSRRWI rs1 =1 out %h", out);

    #20;
    $display("wait out %h", out);
    assert (out == 'b0011);

    rs1 = 2;
    op  = CSRRSI;
    $display("CSRRSI rs1 =2 out %h", out);

    #20;
    $display("wait out %h", out);
    assert (out == 'b0001);

    rs1 = 1;
    op  = CSRRCI;
    $display("CSRRCI rs1 =1 out %h", out);

    #20;
    $display("wait out %h", out);
    assert (out == 'b0011);

    rs1 = 1;
    op  = CSRRCI;
    $display("CSRRCI rs1 =1 out %h --- dummy just to get out", out);

    addr = 1;  // should cause miss match
    #20;
    $display("wait out %h", out);
    assert (out == 0);  // to ensure latch free implementation
    assert (match == 0);

    #20 $finish;
  end
endmodule
