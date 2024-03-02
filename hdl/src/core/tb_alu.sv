// tb_alu
`timescale 1ns / 1ps

import decoder_pkg::*;
module tb_alu;

  logic [31:0] a;
  logic [31:0] b;
  alu_op_t op;
  logic sub_arith;

  logic [31:0] res;

  alu dut (
      .a(a),
      .b(b),
      .op(op),
      .sub_arith(sub_arith),
      .res(res)
  );

  initial begin
    $dumpfile("alu.fst");
    $dumpvars;

    a = 3;
    b = 5;
    op = ALU_ADD;
    sub_arith = 0;

    #10;
    assert (res == 8) $display("3 + 5 = 8");
    else $error();

    a  = 3;  // 011
    b  = 5;  // 101
    op = ALU_SLT;
    #10;
    assert (res == 1) $display("(3 < 5) -> true");
    else $error();

    a  = -3;
    b  = 5;
    op = ALU_SLT;
    #10;
    assert (res == 1) $display("signed (-3 < 5) -> true");
    else $error();

    a  = -3;
    b  = 5;
    op = ALU_SLTU;
    #10;
    assert (res == 0) $display("unsigned (-3 < 5) -> false");
    else $error();

    a  = -3;
    b  = -5;
    op = ALU_SLT;
    #10;
    assert (res == 0) $display("signed (-3 < -5) -> false");
    else $error();

    a  = -3;
    b  = -5;
    op = ALU_SLTU;
    #10;
    assert (res == 0) $display("unsigned (-3 < -5) -> false");
    else $error();

    a  = 3;
    b  = -5;
    op = ALU_SLTU;
    #10;
    assert (res == 1) $display("unsigned (3 < -5) -> true");
    else $error();

    a  = 3;
    b  = -5;
    op = ALU_SLT;
    #10;
    assert (res == 0) $display("signed (3 < -5) -> false");
    else $error();

    // shifting
    a  = 3;
    b  = 2;
    op = ALU_SLL;
    #10;
    assert (res == 12) $display("(3 << 2) = 12");
    else $error();

    a = 12;
    b = 2;
    op = ALU_SR;
    sub_arith = 0;  // shift right logic
    #10;
    assert (res == 3) $display("unsigned (12 >> 2) = 3");
    else $error();

    a = 12;
    b = 2;
    op = ALU_SR;
    sub_arith = 1;  // shift right logic
    #10;
    assert (res == 3) $display("signed (12 >> 2) = 3");
    else $error();

    a = -12;
    b = 2;
    op = ALU_SR;
    sub_arith = 1;  // shift right arithmetic
    #10;
    assert (res == -3) $display("signed(-12 >>> 2) = -3");
    else $error("res = %h", res);

    #10 $finish;

  end
endmodule
