// tb_n_clic
`timescale 1ns / 1ps

module tb_n_clic;
  import decoder_pkg::*;
  import config_pkg::*;

  localparam csr_addr_t VecCsrBase = 'hb00;

  (* DONT_TOUCH = "TRUE" *)
  logic clk;
  (* DONT_TOUCH = "TRUE" *)
  logic reset;

  (* DONT_TOUCH = "TRUE" *)
  logic csr_enable;
  (* DONT_TOUCH = "TRUE" *)
  csr_addr_t csr_addr;
  (* DONT_TOUCH = "TRUE" *)
  r rs1_zimm;
  (* DONT_TOUCH = "TRUE" *)
  word rs1_data;
  (* DONT_TOUCH = "TRUE" *)
  csr_op_t csr_op;
  (* DONT_TOUCH = "TRUE" *)
  word out;

  (* DONT_TOUCH = "TRUE" *)
  logic [IMemAddrWidth-1:0] pc_in;
  (* DONT_TOUCH = "TRUE" *)
  logic [IMemAddrWidth-1:0] n_clic_pc_out;
  (* DONT_TOUCH = "TRUE" *)
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
      .pc_out(n_clic_pc_out),
      // out
      .out(out)
  );

  (* DONT_TOUCH = "TRUE" *)
  logic [IMemAddrWidth-1:0] pc_reg_out;
  (* DONT_TOUCH = "TRUE" *)
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

  (* DONT_TOUCH = "TRUE" *)
  pc_mux_t pc_mux_sel;
  (* DONT_TOUCH = "TRUE" *)
  logic [IMemAddrWidth-1:0] pc_branch;
  (* DONT_TOUCH = "TRUE" *)
  logic [IMemAddrWidth-1:0] pc_mux_out;
  (* DONT_TOUCH = "TRUE" *)
  pc_mux #(
      .AddrWidth(IMemAddrWidth)
  ) pc_mux (
      // in
      .sel(pc_mux_sel),
      .pc_next(n_clic_pc_out),
      .pc_branch(pc_branch),
      // out
      .out(pc_mux_out)
  );

  // emulate the register file, for observing old_csr
  (* DONT_TOUCH = "TRUE" *)
  word old_csr;
  (* DONT_TOUCH = "TRUE" *)
  reg_n rf_reg (
      // in
      .clk,
      .reset,
      .in (out),
      // out
      .out(old_csr)
  );

  // clock process
  always #10 clk = ~clk;

  // logic [4:0] entry;
  function void clic_dump();
    $display("mintresh %d, level (nesting depth) %d", dut.m_int_thresh.data, dut.level_out);
    for (integer i = 0; i < 8; i++) begin
      $display("%d, is_int %b max_prio %d, max_vec %d, pc_in %d, pc_out %d", i, dut.is_int[i],
               dut.max_prio[i], dut.max_vec[i], dut.pc_in, dut.pc_out);
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

    reset = 0;

    dut.m_int_thresh.data = 0;  // initial prio, minthresh

    dut.gen_vec[0].csr_entry.data = (1 << 2) | (1 << 1);  // 0, prio 1, enabled
    dut.gen_vec[2].csr_entry.data = (2 << 2) | (1 << 1);  // 2, prio 2, enabled
    dut.gen_vec[4].csr_entry.data = (1 << 2) | (1 << 1);  // 4, prio 1, enabled
    dut.gen_vec[7].csr_entry.data = (7 << 2) | (1 << 1);  // 7, prio 7, enabled

    dut.gen_vec[0].csr_vec.data = 2;  // 8 in byte addr
    dut.gen_vec[2].csr_vec.data = 4;  // 16
    dut.gen_vec[4].csr_vec.data = 8;  // 32 
    dut.gen_vec[7].csr_vec.data = 14;  // 56

    pc_mux_sel = PC_NEXT;
    pc_branch = 0;

    #20 $display("time ", $time());  // force clocking

    clic_dump();
    assert (dut.is_int[7] == 0 && dut.max_prio[7] == 0 && dut.max_vec[7] == 0);

    $display("pend vec 4");
    dut.gen_vec[4].csr_entry.data |= (1 << 0);  // pended
    #20 $display("time ", $time());  // force clock
    assert (dut.pc_out == 32);
    clic_dump();

    $display("pend vec 0 no interrupt");
    dut.gen_vec[0].csr_entry.data |= (1 << 0);  // pended
    #20 $display("time ", $time());  // force clock
    assert (dut.pc_out == 32);
    clic_dump();

    $display("pend vec 2");
    dut.gen_vec[2].csr_entry.data |= (1 << 0);  // pended
    #20 $display("time ", $time());  // force clock
    assert (dut.pc_out == 16);
    clic_dump();

    $display("no pend, no interrupt");
    #20 $display("time ", $time());  // force clock
    assert (dut.pc_out == 16);
    clic_dump();

    $display("pend vec 7");
    dut.gen_vec[7].csr_entry.data |= (1 << 0);  // pended
    #20 $display("time ", $time());  // force clock
    assert (dut.pc_out == 56);
    clic_dump();

    pc_mux_sel = PC_BRANCH;
    pc_branch  = ~0;
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
    $display("VecCsrBase out %h", out);
    assert (out == 2);

    csr_addr = VecCsrBase + 1;
    #20;
    $display("VecCsrBase + 1 out %h", out);
    assert (out == 0);

    csr_addr = VecCsrBase + 2;
    #20;
    $display("VecCsrBase + 2 out %h", out);
    assert (out == 4);

    rs1_data = 'hfff_ffff;
    csr_op   = CSRRW;
    #20;
    $display("VecCsrBase + 2 out %h", out);
    $display("VecCsrBase + 2 old_csr %h", old_csr);
    assert (old_csr == 4);
    assert (out == 'h3f);
    csr_enable = 0;  // don't write to csr
    rs1_data   = '0;

    #20;
    $display("VecCsrBase + 2 out %h", out);
    $display("VecCsrBase + 2 old_csr %h", old_csr);
    assert (out == 'h3f);
    assert (old_csr == 'h3f);

    $finish;

  end
endmodule
