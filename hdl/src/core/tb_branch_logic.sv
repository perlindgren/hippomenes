// tb_branch_logic
`timescale 1ns / 1ps

import decoder_pkg::*;
module tb_branch_logic;

  word a;
  word b;
  reg branch_always;
  reg branch_instr;
  branch_op_t op;

  pc_mux_t out;

  branch_logic dut (
      .a(a),
      .b(b),
      .branch_always(branch_always),
      .branch_instr(branch_instr),
      .op(op),
      .out(out)
  );

  initial begin
    $dumpfile("branch_logic.fst");
    $dumpvars;

    branch_always = 0;
    branch_instr = 1;

    // BEQ
    a = 3;
    b = 5;
    op = BL_BEQ;
    #10;
    assert (out == PC_NEXT) $display("BEQ 3 == 5 -> false");
    else $error();

    a  = 7;
    b  = 7;
    op = BL_BEQ;
    #10;
    assert (out == PC_BRANCH) $display("BEQ 7 == 7 -> true");
    else $error();

    // BNE
    a  = 3;
    b  = 5;
    op = BL_BNE;
    #10;
    assert (out == PC_BRANCH) $display("BNE 3 == 5 -> true");
    else $error();

    a  = 7;
    b  = 7;
    op = BL_BNE;
    #10;
    assert (out == PC_NEXT) $display("BNE 7 == 7 -> false");
    else $error();

    a  = 3;
    b  = 5;
    op = BL_BNE;
    #10;
    assert (out == PC_BRANCH) $display("BNE 3 == 5 -> true");
    else $error();

    // BLT
    a  = -3;
    b  = 7;
    op = BL_BLT;
    #10;
    assert (out == PC_BRANCH) $display("BLT -3 < 7 -> true");
    else $error();

    a  = 3;
    b  = -7;
    op = BL_BLT;
    #10;
    assert (out == PC_NEXT) $display("BLT 3 < -7  -> false");
    else $error();

    a  = -3;
    b  = -3;
    op = BL_BLT;
    #10;
    assert (out == PC_NEXT) $display("BLT -3 < -3  -> false");
    else $error();

    // BGE
    a  = 3;
    b  = -7;
    op = BL_BGE;
    #10;
    assert (out == PC_BRANCH) $display("BGE 3 >= -7  -> true");
    else $error();

    a  = -3;
    b  = 7;
    op = BL_BGE;
    #10;
    assert (out == PC_NEXT) $display("BGE -3 >= 7  -> false");
    else $error();

    a  = -3;
    b  = -3;
    op = BL_BGE;
    #10;
    assert (out == PC_BRANCH) $display("BGE -3 >= -3  -> true");
    else $error();

    // BLTU
    a  = -3;
    b  = 7;
    op = BL_BLTU;
    #10;
    assert (out == PC_NEXT) $display("BLTU -3 < 7 -> false");
    else $error();

    a  = 3;
    b  = -7;
    op = BL_BLTU;
    #10;
    assert (out == PC_BRANCH) $display("BLTU 3 < -7  -> true");
    else $error();

    a  = -3;
    b  = -3;
    op = BL_BLTU;
    #10;
    assert (out == PC_NEXT) $display("BLTU -3 < -3  -> false");
    else $error();

    // BGEU
    a  = 3;
    b  = -7;
    op = BL_BGEU;
    #10;
    assert (out == PC_NEXT) $display("BGEU 3 >= -7  -> false");
    else $error();

    a  = -3;
    b  = 7;
    op = BL_BGEU;
    #10;
    assert (out == PC_BRANCH) $display("BGEU -3 >= 7  -> true");
    else $error();

    a  = -3;
    b  = -3;
    op = BL_BGEU;
    #10;
    assert (out == PC_BRANCH) $display("BGEU -3 >= -3  -> true");
    else $error();

    branch_instr = 0;
    #10;
    assert (out == PC_NEXT) $display("not a branch instruction");
    else $error();

    branch_always = 1;
    #10;
    assert (out == 1) $display("branch_always");
    else $error();


    #10 $finish;

  end
endmodule
