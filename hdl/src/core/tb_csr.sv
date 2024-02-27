// tb_csr
`timescale 1ns / 1ps

import decoder_pkg::*;
module tb_csr;

  reg clk;
  reg reset;
  reg en;
  r rs1;
  r rd;
  csr_t op;
  word in;
  word old;

  csr dut (
      .clk(clk),
      .reset(reset),
      .en(en),
      .rs1(rs1),
      .rd(rd),
      .op(op),
      .in(in),
      .old(old)
  );

  always #10 clk = ~clk;

  initial begin
    $dumpfile("csr.fst");
    $dumpvars;

    reset = 1;
    #15;
    reset = 0;
    #5;

    clk = 0;
    en  = 1;

    in  = 'b1011;
    op  = CSRRW;
    // notice old will be delayed
    $display("CSRRW 'b1011 old %h", old);

    #20;
    $display("wait old %h", old);
    assert (old == 0);
    in = 'b1100;
    op = CSRRS;
    $display("CSRRS 'b1100 old %h", old);

    #20;
    $display("wait old %h", old);
    assert (old == 'b1011);
    in = 'b1100;
    op = CSRRC;
    $display("CSRRC 'b1100 %h", old);

    #20;
    $display("wait old %h", old);
    assert (old == 'b1111);

    rs1 = 1;
    op  = CSRRWI;
    $display("CSRRWI rs1 =1 old %h", old);

    #20;
    $display("wait old %h", old);
    assert (old == 'b0011);

    rs1 = 2;
    op  = CSRRSI;
    $display("CSRRSI rs1 =2 old %h", old);

    #20;
    $display("wait old %h", old);
    assert (old == 'b0001);

    rs1 = 1;
    op  = CSRRCI;
    $display("CSRRCI rs1 =1 old %h", old);

    #20;
    $display("wait old %h", old);
    assert (old == 'b0011);

    rs1 = 1;
    op  = CSRRCI;
    $display("CSRRCI rs1 =1 old %h --- dummy just to get old", old);

    #20;
    $display("wait old %h", old);
    assert (old == 'b0010);


    #20 $finish;
  end
endmodule
