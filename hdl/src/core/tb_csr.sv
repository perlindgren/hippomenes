// tb_csr
`timescale 1ns / 1ps

import decoder_pkg::*;
module tb_csr;

  logic clk;
  logic reset;
  logic en;
  csr_addr_t addr;
  r rs1_zimm;
  word rs1_data;
  csr_t op;
  word out;
  // logic match;

  csr dut (
      // in
      .clk(clk),
      .reset(reset),
      .en(en),
      .addr(addr),
      .rs1_data(rs1_data),
      .op(op),
      .rs1_zimm(rs1_zimm),
      // out
      //.match(match),
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
    en = 1;

    rs1_data = 'b1011;
    op = CSRRW;
    // notice out will be delayed
    $display("CSRRW 'b1011 out %h", out);
    assert (out == 0);

    #20;
    $display("wait out %h", out);
    assert (out == 'b1011);
    // assert (match == 1);
    rs1_data = 'b1100;
    op = CSRRS;
    $display("CSRRS 'b1100 out %h", out);

    #20;
    $display("wait out %h", out);
    assert (out == 'b1111);
    rs1_data = 'b1100;
    op = CSRRC;
    $display("CSRRC 'b1100 %h", out);

    #20;
    $display("wait out %h", out);
    assert (out == 'b0011);

    rs1_zimm = 1;
    op = CSRRWI;
    $display("CSRRWI rs1 =1 out %h", out);

    #20;
    $display("wait out %h", out);
    assert (out == 'b0001);

    rs1_zimm = 2;
    op = CSRRSI;
    $display("CSRRSI rs1 =2 out %h", out);

    #20;
    $display("wait out %h", out);
    assert (out == 'b0011);

    rs1_zimm = 1;
    op = CSRRCI;
    $display("CSRRCI rs1 =1 out %h", out);

    #20;
    $display("wait out %h", out);
    assert (out == 'b0010);

    rs1_zimm = 1;
    op = CSRRCI;
    $display("CSRRCI rs1 =1 out %h --- dummy just to get out", out);

    addr = 1;  // should cause address miss match
    #1;
    assert (out == 0);


    #20 $finish;
  end
endmodule
