// tb_register_file
`timescale 1ns / 1ps

module tb_register_file;
  parameter integer unsigned DataWidth = 32;
  parameter integer unsigned NumRegs = 32;
  parameter integer unsigned IndexWidth = $clog2(NumRegs);
  localparam type DataT = logic [DataWidth-1:0];
  localparam int unsigned AddrWidth = 5;
  localparam type AddrT = logic [AddrWidth-1:0];


  logic clk_i;
  logic rst_ni;
  logic we_a_i;
  AddrT waddr_a_i;
  DataT wdata_a_i;
  AddrT raddr_a_i;
  AddrT raddr_b_i;
  DataT rdata_a_o;
  DataT rdata_b_o;

  register_file dut (
      // Clock and Reset
      .clk_i,
      .rst_ni,

      //Read port R1
      .raddr_a_i,
      .rdata_a_o,
      //Read port R2
      .raddr_b_i,
      .rdata_b_o,
      // Write port W1
      .waddr_a_i,
      .wdata_a_i,
      .we_a_i
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

    raddr_a_i = 0;
    raddr_b_i = 1;
    we_a_i = 1;
    waddr_a_i = 1;
    wdata_a_i = 'h12345678;

    #20;
    assert ((rdata_a_o == 0) && (rdata_b_o == 'h12345678)) $display("ok");
    else $error("rs1 %h, rs2 %h", rdata_a_o, rdata_b_o);

    assert ((rdata_a_o == 0) && (rdata_b_o == 'h12345678)) $display("ok");
    else $error("rs1 %h, rs2 %h", rdata_a_o, rdata_b_o);

    $display("we_a_i %b waddr_a_i %d wdata_a_i %h", we_a_i, waddr_a_i, wdata_a_i);
    $display("rs1 %h, rs2 %h", rdata_a_o, rdata_b_o);
    #20;

    assert ((rdata_a_o == 0) && (rdata_b_o == 'h12345678)) $display("ok");
    else $error("rs1 %h, rs2 %h", rdata_a_o, rdata_b_o);

    waddr_a_i = 31;
    wdata_a_i = 'hdead_beef;
    raddr_a_i = 31;
    #20;
    assert ((rdata_a_o == 'hdead_beef) && (rdata_b_o == 'h12345678)) $display("ok");
    else $error("rs1 %h, rs2 %h", rdata_a_o, rdata_b_o);

    #10 $finish;

  end
endmodule
