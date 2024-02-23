// tb_branch_logic

import decoder_pkg::*;
module tb_branch_logic;

  word a;
  word b;
  reg branch_instr;
  branch_op_t op;

  pc_mux_t res;

  branch_logic dut (
      .a(a),
      .b(b),
      .branch_instr(branch_instr),
      .op(op),
      .res(res)
  );

  initial begin
    $dumpfile("branch_logic.fst");
    $dumpvars;

    // BEQ
    branch_instr = 1;
    a = 3;
    b = 5;
    op = BL_BEQ;
    #10;
    assert (res == 0) $display("BEQ 3 == 5 -> false");
    else $error();

    a  = 7;
    b  = 7;
    op = BL_BEQ;
    #10;
    assert (res == 1) $display("BEQ 7 == 7 -> true");
    else $error();

    // BNE
    a  = 3;
    b  = 5;
    op = BL_BNE;
    #10;
    assert (res == 1) $display("BNE 3 == 5 -> true");
    else $error();

    a  = 7;
    b  = 7;
    op = BL_BNE;
    #10;
    assert (res == 0) $display("BNE 7 == 7 -> false");
    else $error();

    a  = 3;
    b  = 5;
    op = BL_BNE;
    #10;
    assert (res == 1) $display("BNE 3 == 5 -> true");
    else $error();

    // BLT
    a  = -3;
    b  = 7;
    op = BL_BLT;
    #10;
    assert (res == 1) $display("BLT -3 < 7 -> true");
    else $error();

    a  = 3;
    b  = -7;
    op = BL_BLT;
    #10;
    assert (res == 0) $display("BLT 3 < -7  -> false");
    else $error();

    a  = -3;
    b  = -3;
    op = BL_BLT;
    #10;
    assert (res == 0) $display("BLT -3 < -3  -> false");
    else $error();

    // BGE
    a  = 3;
    b  = -7;
    op = BL_BGE;
    #10;
    assert (res == 1) $display("BGE 3 >= -7  -> true");
    else $error();

    a  = -3;
    b  = 7;
    op = BL_BGE;
    #10;
    assert (res == 0) $display("BGE -3 >= 7  -> false");
    else $error();

    a  = -3;
    b  = -3;
    op = BL_BGE;
    #10;
    assert (res == 1) $display("BGE -3 >= -3  -> true");
    else $error();

    // BLTU
    a  = -3;
    b  = 7;
    op = BL_BLTU;
    #10;
    assert (res == 0) $display("BLTU -3 < 7 -> false");
    else $error();

    a  = 3;
    b  = -7;
    op = BL_BLTU;
    #10;
    assert (res == 1) $display("BLTU 3 < -7  -> true");
    else $error();

    a  = -3;
    b  = -3;
    op = BL_BLTU;
    #10;
    assert (res == 0) $display("BLTU -3 < -3  -> false");
    else $error();

    // BGEU
    a  = 3;
    b  = -7;
    op = BL_BGEU;
    #10;
    assert (res == 0) $display("BGEU 3 >= -7  -> false");
    else $error();

    a  = -3;
    b  = 7;
    op = BL_BGEU;
    #10;
    assert (res == 1) $display("BGEU -3 >= 7  -> true");
    else $error();

    a  = -3;
    b  = -3;
    op = BL_BGEU;
    #10;
    assert (res == 1) $display("BGEU -3 >= -3  -> true");
    else $error();

    branch_instr = 0;
    #10;
    assert (res == 0) $display("not a branch instruction");
    else $error();


    #10 $finish;

  end
endmodule
