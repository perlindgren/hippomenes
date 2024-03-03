// tb_n_clic
`timescale 1ns / 1ps

module tb_n_clic;
  import decoder_pkg::*;
  logic clk;
  logic reset;

  logic csr_enable;
  csr_addr_t csr_addr;
  r rs1_zimm;
  word rs1_data;
  csr_t op;
  word out;

  n_clic dut (
      // in
      .clk(clk),
      .reset(reset),
      .csr_enable(csr_enable),
      .csr_addr(csr_addr),
      .rs1_zimm(rs1_zimm),
      .rs1_data(rs1_data),
      .op(op),
      // out
      .out(out)
  );

  always #10 clk = ~clk;

  initial begin
    $dumpfile("n_clic.fst");
    $dumpvars;

    clk   = 0;
    reset = 1;
    #15;
    reset = 0;

    // dut.mstatus.data = 1;
    // dut.stack_depth.data = 2;

    // dut.gen_csr[0].csr.data = 23;

    csr_addr = 'h305;
    csr_enable = 1;
    rs1_zimm = 0;
    rs1_data = 0;
    op = CSRRSI;

    #1;
    $display("305 out %h", out);

    csr_addr = 'h350;
    #1;
    $display("350 out %h", out);


    #18;
    $display("out %h", out);
    // $display("mstatus data %h", dut.mstatus.data);
    // $display("stack_depth data %h", dut.stack_depth.data);

    $display("[0] data %h", dut.gen_csr[0].csr.data);
    $display("[1] data %h", dut.gen_csr[1].csr.data);
    $display("[2] data %h", dut.gen_csr[2].csr.data);



    // assert (dut.regs[1][3] == 'h00001111);

    $finish;

  end
endmodule