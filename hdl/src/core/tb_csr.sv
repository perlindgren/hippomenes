// tb_csr
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

    clk = 0;
    en  = 1;
    in  = 'b1011;
    op  = CSRRW;
    #20;
    $display("CSRRW 'b1011 old %h", old);

    in = 'b1100;
    op = CSRRS;
    #20;
    $display("CSRRS 'b1100 old %h", old);

    in = 'b1100;
    op = CSRRC;
    #20;
    $display("CSRRC 'b1100 %h", old);

    #20;
    $display("wait old %h", old);

    rs1 = 1;
    op  = CSRRWI;
    #20;
    $display("CSRRWI rs1 =1 old %h", old);

    #20;

    $display("wait old %h", old);

    #100 $finish;
  end
endmodule
