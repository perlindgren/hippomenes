// tb_n_clic
`timescale 1ns / 1ps

module tb_n_clic;
  import decoder_pkg::*;
  import config_pkg::*;

  logic clk;
  logic reset;

  logic csr_enable;
  csr_addr_t csr_addr;
  r rs1_zimm;
  word rs1_data;
  csr_op_t csr_op;
  word out;

  logic [IMemAddrWidth-1:0] pc_in;
  logic [IMemAddrWidth-1:0] pc_out;
  n_clic dut (
      // in
      .clk,
      .reset,
      .csr_enable,
      .csr_addr,
      .rs1_zimm,
      .rs1_data,
      .csr_op,
      //
      .pc_in,
      .pc_out,
      // out
      .out(out)
  );

  always #10 clk = ~clk;



  // logic [4:0] entry;
  function void clic_dump();
    $display("mintresh %d, level %d", dut.m_int_thresh.data, dut.index_out);
    for (integer i = 0; i < 8; i++) begin
      $display("%d, is_int %b max_prio %d, max_vec %d, pc_in %d, pc_out %d", i, dut.is_int[i],
               dut.max_prio[i], dut.max_vec[i], dut.pc_in, dut.pc_out);
    end
  endfunction

  reg_n #(
      .DataWidth(IMemAddrWidth)
  ) pc_reg (
      .clk,
      .reset,
      .in (pc_out),
      .out(pc_in)
  );

  initial begin
    $dumpfile("n_clic.fst");
    $dumpvars;

    clk   = 0;
    reset = 1;
    #15;
    reset = 0;

    dut.m_int_thresh.data = 0;  // initial prio, minthresh

    dut.gen_vec[0].csr_entry.data = (1 << 2) | (1 << 1);  // 0, prio 1, enabled
    dut.gen_vec[2].csr_entry.data = (2 << 2) | (1 << 1);  // 2, prio 2, enabled
    dut.gen_vec[4].csr_entry.data = (1 << 2) | (1 << 1);  // 4, prio 1, enabled
    dut.gen_vec[7].csr_entry.data = (7 << 2) | (1 << 1);  // 7, prio 7, enabled

    dut.gen_vec[0].csr_vec.data = 2;  // in words
    dut.gen_vec[2].csr_vec.data = 4;  //
    dut.gen_vec[4].csr_vec.data = 8;  //
    dut.gen_vec[7].csr_vec.data = 14;  // 


    #20;  // force clocking

    clic_dump();
    assert (dut.is_int[7] == 0 && dut.max_prio[7] == 0 && dut.max_vec[7] == 0);

    $display("pend vec 4");
    dut.gen_vec[4].csr_entry.data |= (1 << 0);  // pended
    #20;  // force clock
    clic_dump();

    $display("pend vec 0");
    dut.gen_vec[0].csr_entry.data |= (1 << 0);  // pended
    #20;  // force clock
    clic_dump();

    $display("pend vec 2");
    dut.gen_vec[2].csr_entry.data |= (1 << 0);  // pended
    #20;  // force clock
    clic_dump();


    // assert (dut.is_int[7] == 1 && dut.max_prio[7] == 1 && dut.max_vec[7] == 4);

    // $display("pend vec 0");
    // dut.gen_vec[0].csr_entry.data |= (1 << 0);  // pended
    // #1;
    // clic_dump();
    // assert (dut.is_int[7] == 1 && dut.max_prio[7] == 1 && dut.max_vec[7] == 0);

    // $display("pend vec 2");
    // dut.gen_vec[2].csr_entry.data |= (1 << 0);  // pended
    // #1;
    // clic_dump();
    // assert (dut.is_int[7] == 1 && dut.max_prio[7] == 2 && dut.max_vec[7] == 2);

    // $display("pend vec 7");
    // dut.gen_vec[7].csr_entry.data |= (1 << 0);  // pended
    // #1;
    // clic_dump();
    // assert (dut.is_int[7] == 1 && dut.max_prio[7] == 7 && dut.max_vec[7] == 7);

    // $display("un-pend vec 7");
    // dut.gen_vec[7].csr_entry.data ^= (1 << 0);  // un-pended
    // #1;
    // clic_dump();
    // assert (dut.is_int[7] == 1 && dut.max_prio[7] == 2 && dut.max_vec[7] == 2);

    // $display("raise threshold");
    // dut.gen_csr[0].csr.data = 7;  // raise threshold
    // #1;
    // clic_dump();
    // assert (dut.is_int[7] == 0 && dut.max_prio[7] == 7 && dut.max_vec[7] == 0);

    // $display("lower threshold");
    // dut.gen_csr[0].csr.data = 0;  // lower threshold
    // #1;
    // clic_dump();
    // assert (dut.is_int[7] == 1 && dut.max_prio[7] == 2 && dut.max_vec[7] == 2);







    // // simple test of limited size csr
    // csr_addr = 'hb00;
    // csr_enable = 1;
    // rs1_zimm = 0;
    // rs1_data = 0;
    // csr_op = CSRRSI;


    // $display("out %h", out);
    // rs1_zimm = 31;

    // #19;
    // $display("out %h", out);
    // rs1_data = 'hffff_ff0f;
    // csr_op   = CSRRW;

    // #20;
    // $display("out %h", out);



    // // dut.stack_depth.data = 2;

    // // dut.gen_csr[0].csr.data = 23;

    // csr_addr = 'h305;
    // csr_enable = 1;
    // rs1_zimm = 0;
    // rs1_data = 0;
    // csr_op = CSRRSI;

    // #1;
    // $display("305 out %h", out);

    // csr_addr = 'h350;
    // #1;
    // $display("350 out %h", out);


    // #18;
    // $display("out %h", out);
    // // $display("mstatus data %h", dut.mstatus.data);
    // // $display("stack_depth data %h", dut.stack_depth.data);

    // $display("[0] data %h", dut.gen_csr[0].csr.data);
    // $display("[1] data %h", dut.gen_csr[1].csr.data);
    // $display("[2] data %h", dut.gen_csr[2].csr.data);



    // // assert (dut.regs[1][3] == 'h00001111);

    $finish;

  end
endmodule
