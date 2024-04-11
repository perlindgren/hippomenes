// tb_n_clic
`timescale 1ns / 1ps

module tb_n_clic;
  import decoder_pkg::*;
  import config_pkg::*;

  logic clk;
  logic reset;
  logic csr_enable;
  CsrAddrT csr_addr;
  r rs1_zimm;
  word rs1_data;
  csr_op_t csr_op;
  IMemAddrT pc_in;
  word csr_out;
  IMemAddrT n_clic_pc_out;
  PrioT level_out;
  logic interrupt_out;
  pc_interrupt_mux_t pc_interrupt_sel;

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
      .pc_in(pc_reg_out),
      // out
      .csr_out,
      .int_addr(n_clic_pc_out),
      .pc_interrupt_sel,
      .level_out,
      .interrupt_out
  );

  IMemAddrT pc_reg_out;

  reg_n #(
      .DataWidth(IMemAddrWidth)
  ) pc_reg (
      // in
      .clk,
      .reset,
      .in (pc_mux_out),
      // out
      .out(pc_reg_out)
  );

  pc_branch_mux_t pc_branch_mux_sel;
  IMemAddrT pc_branch;
  IMemAddrT pc_mux_out;

  pc_branch_mux #(
      .AddrWidth(IMemAddrWidth)
  ) pc_branch_mux (
      // in
      .sel(pc_branch_mux_sel),
      .pc_next(n_clic_pc_out),
      .pc_branch(pc_branch),
      // out
      .out(pc_mux_out)
  );

  // emulate the register file, for observing old_csr

  word old_csr;
  reg_n rf_reg (
      // in
      .clk,
      .reset,
      .in (csr_out),
      // out
      .out(old_csr)
  );

  // clock process
  always #10 begin
    clk = ~clk;
    $display("clk %d", clk, $time);
  end

  // logic [4:0] entry;
  function static void clic_dump();
    $display("mintresh %d, level (nesting depth) %d", dut.m_int_thresh.data, dut.level_out);
    for (integer i = 0; i < 8; i++) begin
      $display("%d,  max_prio %d, max_vec %d, pc_in %d, int_addr %d", i, dut.max_prio[i],
               dut.max_vec[i], dut.pc_in, dut.int_addr);
    end
  endfunction

  initial begin
    $dumpfile("n_clic.fst");
    $dumpvars;

    csr_enable = 0;
    csr_addr = 0;
    rs1_zimm = 0;
    rs1_data = 0;
    csr_op = CSRRW;
    pc_in = 0;

    clk = 0;
    reset = 1;
    #15 $display("time ", $time());  // force clock

    reset = 0;  // reset phase over

    dut.m_int_thresh.data = 0;  // initial prio, minthresh

    dut.gen_vec[0].csr_entry.data = (1 << 2) | (1 << 1);  // 0, prio 1, enabled
    dut.gen_vec[2].csr_entry.data = (2 << 2) | (1 << 1);  // 2, prio 2, enabled
    dut.gen_vec[4].csr_entry.data = (1 << 2) | (1 << 1);  // 4, prio 1, enabled
    dut.gen_vec[7].csr_entry.data = (7 << 2) | (1 << 1);  // 7, prio 7, enabled

    dut.gen_vec[0].csr_vec.data = 2;  // 8 in byte addr
    dut.gen_vec[2].csr_vec.data = 4;  // 16
    dut.gen_vec[4].csr_vec.data = 8;  // 32
    dut.gen_vec[7].csr_vec.data = 14;  // 56

    dut.mstatus.data = 8;  // enable global interrupts

    pc_branch_mux_sel = PC_NEXT;
    pc_branch = 0;

    $display("dut.gen_vec[0].csr_vec.data %h", dut.gen_vec[0].csr_vec.data);


    #20 $display("time ", $time());  // force clocking

    clic_dump();
    assert (dut.max_prio[7] == 0 && dut.max_vec[7] == 0);

    $display("pend vec 4");
    dut.gen_vec[4].csr_entry.data |= (1 << 0);  // pended
    $display("dut.gen_vec[4].csr_entry.data %d", dut.gen_vec[4].csr_entry.data);
    #20 $display("time ", $time());  // force clock
    $display("dut.gen_vec[4].csr_entry.data %d", dut.gen_vec[4].csr_entry.data);
    clic_dump();
    $display("int_addr %d", dut.int_addr);
    assert (dut.int_addr == 32);

    $display("pend vec 0 no interrupt");
    dut.gen_vec[0].csr_entry.data |= (1 << 0);  // pended
    #20 $display("time ", $time());  // force clock
    assert (dut.int_addr == 32);
    clic_dump();

    $display("pend vec 2");
    dut.gen_vec[2].csr_entry.data |= (1 << 0);  // pended
    #20 $display("time ", $time());  // force clock
    assert (dut.int_addr == 16);
    clic_dump();

    $display("no pend, no interrupt");
    #20 $display("time ", $time());  // force clock
    assert (dut.int_addr == 16);
    clic_dump();

    $display("pend vec 7");
    dut.gen_vec[7].csr_entry.data |= (1 << 0);  // pended
    #20 $display("time ", $time());  // force clock
    assert (dut.int_addr == 56);
    clic_dump();

    pc_branch_mux_sel = PC_BRANCH;
    pc_branch = ~0;
    dut.gen_vec[7].csr_entry.data ^= (1 << 0);  // unpend

    #20 $display("time ", $time());  // force clock
    $display("jal ff");
    clic_dump();

    #20 $display("time ", $time());  // force clock
    clic_dump();

    // test csr:s
    csr_addr = VecCsrBase;
    csr_enable = 1;
    rs1_zimm = 0;
    rs1_data = 0;
    csr_op = CSRRSI;

    #20;
    $display("VecCsrBase %h, out %h", csr_addr, csr_out);
    $display("dut.gen_vec[0].csr_vec.data %h", dut.gen_vec[0].csr_vec.data);

    #20;
    $display("VecCsrBase %h, out %h", csr_addr, csr_out);

    assert (csr_out == 2);

    csr_addr = VecCsrBase + 1;
    #20;
    $display("VecCsrBase + 1, %h out %h", csr_addr, csr_out);
    assert (csr_out == 0);

    csr_addr = VecCsrBase + 2;
    #20;
    $display("VecCsrBase + 2, %h out %h", csr_addr, csr_out);
    assert (csr_out == 4);

    rs1_data = 'hfff_ffff;
    csr_op   = CSRRW;
    #20;
    $display("VecCsrBase + 2 out %h", csr_out);
    assert (csr_out == 'h3ff);
    csr_enable = 0;  // don't write to csr
    rs1_data   = '0;

    #20;
    $display("VecCsrBase + 2 out %h", csr_out);
    $display("VecCsrBase + 2 old_csr %h", old_csr);
    assert (csr_out == 'h3ff);
    assert (old_csr == 'h3ff);

    $finish;

  end
endmodule
