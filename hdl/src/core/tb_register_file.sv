// tb_register_file
`timescale 1ns / 1ps

module tb_register_file;
  import config_pkg::*;

  logic clk_i;
  logic rst_ni;

  logic we_a_i;
  RegAddrT waddr_a_i;
  RegT wdata_a_i;
  RegAddrT raddr_a_i;
  RegAddrT raddr_b_i;
  RegT rdata_a_o;
  RegT rdata_b_o;
  logic ra_set;

  register_file dut (
      // Clock and Reset
      .clk_i,
      .rst_ni,

      // Read port R1
      .raddr_a_i,
      .rdata_a_o,
      // Read port R2
      .raddr_b_i,
      .rdata_b_o,
      // Write port W1
      .waddr_a_i,
      .wdata_a_i,
      .we_a_i,
      // Set the ra register to magic number
      .ra_set
  );

  always #10 clk_i = ~clk_i;

  initial begin
    $dumpfile("register_file.fst");
    $dumpvars;

    clk_i  = 0;
    rst_ni = 0;
    #5;
    rst_ni = 1;
    #10;
    rst_ni = 0;
    #10;

    ra_set = 0;
    raddr_a_i = 3;
    raddr_b_i = 4;
    we_a_i = 1;
    waddr_a_i = 4;
    wdata_a_i = 'h12345678;

    #20;
    assert ((rdata_a_o == 0) && (rdata_b_o == 'h12345678)) $display("ok");
    else $error("rs1 %h, rs2 %h", rdata_a_o, rdata_b_o);

    raddr_a_i = 4;
    raddr_b_i = 3;

    #1;  // pass time

    assert ((rdata_b_o == 0) && (rdata_a_o == 'h12345678)) $display("ok");
    else $error("rs1 %h, rs2 %h", rdata_a_o, rdata_b_o);

    $display("we_a_i %b waddr_a_i %d wdata_a_i %h", we_a_i, waddr_a_i, wdata_a_i);
    $display("rs1 %h, rs2 %h", rdata_a_o, rdata_b_o);


    we_a_i = 1;
    raddr_a_i = 0;
    raddr_b_i = Ra;
    waddr_a_i = Ra;
    wdata_a_i = 'h1000_0001;

    #20

    assert ((rdata_a_o == 0) && (rdata_b_o == 'h1000_0001)) $display("ok");
    else $error("rs1 %h, rs2 %h", rdata_a_o, rdata_b_o);

    we_a_i = 0;
    ra_set = 1;
    we_a_i = 0;
    raddr_a_i = 0;
    raddr_b_i = Ra;

    #19;

    assert ((rdata_a_o == 0) && (rdata_b_o == 'hffff_ffff)) $display("ok");
    else $error("rs1 %h, rs2 %h", rdata_a_o, rdata_b_o);

    we_a_i = 1;
    waddr_a_i = 31;
    wdata_a_i = 'hdead_beef;
    raddr_a_i = 31;

    #20;
    assert ((rdata_a_o == 'hdead_beef) && (rdata_b_o == 'hffff_ffff)) $display("ok");
    else $error("rs1 %h, rs2 %h", rdata_a_o, rdata_b_o);

    we_a_i = 1;
    ra_set = 0;
    wdata_a_i = 'hdead_1001;
    waddr_a_i = Ra;

    #20;
    assert ((rdata_a_o == 'hdead_beef) && (rdata_b_o == 'hdead_1001)) $display("ok");
    else $error("rs1 %h, rs2 %h", rdata_a_o, rdata_b_o);

    we_a_i = 1;
    ra_set = 1;
    wdata_a_i = 'hdead_1001;
    waddr_a_i = 31;

    #20;

    assert ((rdata_a_o == 'hdead_1001) && (rdata_b_o == 'hffff_ffff)) $display("ok");
    else $error("rs1 %h, rs2 %h", rdata_a_o, rdata_b_o);


    #10 $finish;

  end
endmodule
