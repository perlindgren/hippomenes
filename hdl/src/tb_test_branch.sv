// tb_test_branch
`timescale 1ns / 1ps

module tb_test_branch;
  import config_pkg::*;
  import decoder_pkg::*;

  logic clk;
  logic reset;

  top top (
      .clk  (clk),
      .reset(reset)
  );

  // clock and reset
  initial begin
    $display($time, " << Starting the Simulation >>");

    // notice raw access to memory is in words
    // 00000000 <init>:
    //        0: 17 01 00 50    auipc   sp, 327680
    //        4: 13 01 01 50    addi    sp, sp, 1280
    //        8: 13 03 10 00    li      t1, 1
    top.imem.mem[0] = 'h5000_0117;  // auipc    sp, 327680
    top.imem.mem[1] = 'h5001_0113;  // addi     sp, sp, 1280
    top.imem.mem[2] = 'h0020_0313;  // li       t1, 2

    // 0000000c <l>:
    //        c: 13 03 f3 ff    addi    t1, t1, -1
    //       10: e3 1e 03 fe    bnez    t1, 0xc <.Lline_table_start0+0xc>

    top.imem.mem[3] = 'hfff3_0313;  //  addi    t1, t1, -1
    top.imem.mem[4] = 'hfe03_1ee3;  //  bnez    t1, 0xc <.Lline_table_start0+0xc>

    // 00000014 <s>:
    //       14: 6f 00 00 00    j   0x14 <.Lline_table_start0+0x14>
    top.imem.mem[5] = 'h0000_006f;  //  bnez    t1, 0xc <.Lline_table_start0+0xc>


    reset = 1;
    clk = 0;
    #5 reset = 0;
  end

  always #10 clk = ~clk;

  initial begin
    $dumpfile("test_branch.fst");
    $dumpvars;

    #10;  // auipc   sp,0x50000
    $warning("auipc   sp,0x50000");
    // $display("rf_rs1 %h rf_rs2 %h", rf_rs1, rf_rs2);
    // $display("wb_data_reg.in %h", wb_data_reg.in);
    // assert (pc_reg.out == 0);






    #160;
    $finish;
  end

endmodule
