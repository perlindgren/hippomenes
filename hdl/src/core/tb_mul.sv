// tb_alu
`timescale 1ns / 1ps

import decoder_pkg::*;
module tb_mul;

  logic [31:0] a;
  logic [31:0] b;
  mul_op_t op;

  logic [31:0] res;

  mul dut (
      .a  (a),
      .b  (b),
      .op (op),
      .res(res)
  );

  initial begin
    $dumpfile("mul.fst");
    $dumpvars;

    a  = 3;
    b  = 5;
    op = MUL_MUL;

    #10;
    assert (res == 15) $display("lo_32(3 * 5) = 15");
    else $error();

    a  = 3;
    b  = -5;
    op = MUL_MUL;

    #10;
    assert (res == -15) $display("lo_32(3 * -5) = -15");
    else $error();

    a  = 3;
    b  = -5;
    op = MUL_MULH;

    #10;
    assert (res == -1) $display("hi_32(3 * -5) = -1");
    else $error();

    a  = 3;
    b  = -5;
    op = MUL_MULHU;

    #10;
    assert (res == 2) $display("hi_32(unsigned(3 * -5)) = 2");
    else $error();

    a  = 3;
    b  = -5;
    op = MUL_MULHSU;

    #10;
    assert (res == 2) $display("hi_32(signed(3) * unsigned(-5)) = 2");
    else $error();




    #10 $finish;

  end
endmodule
