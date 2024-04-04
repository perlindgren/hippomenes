// n_clic
`timescale 1ns / 1ps

module n_clic
  import decoder_pkg::*;
  import config_pkg::*;
(
    input logic clk,
    input logic reset,

    // csr registers
    input logic     csr_enable,
    input CsrAddrT  csr_addr,
    input r         rs1_zimm,
    input word      rs1_data,
    input csr_op_t  csr_op,
    // epc
    input IMemAddrT pc_in,

    output word               csr_out,
    output IMemAddrT          int_addr,
    output pc_interrupt_mux_t pc_interrupt_sel,
    output PrioT              level_out,         // stack depth
    output logic              interrupt_out
);

  // CSR timer
  word  timer_direct_out;  // not used
  word  timer_out;
  logic timer_interrupt_set;
  logic timer_interrupt_clear;

  timer timer (
      // in
      .clk,
      .reset,
      .csr_enable,
      .csr_addr,
      .csr_op,
      .rs1_zimm,
      .rs1_data,
      .ext_data(TimerT'(0)),
      .ext_write_enable(1'b0),
      .interrupt_clear(timer_interrupt_clear),
      // out
      .interrupt_set(timer_interrupt_set),
      .csr_direct_out(timer_direct_out),
      .csr_out(timer_out)
  );

  // CSR m_int_thresh
  logic m_int_thresh_write_enable;
  word  m_int_thresh_direct_out;  // not used
  word  m_int_thresh_out;
  PrioT m_int_thresh_data;

  csr #(
      .CsrWidth(PrioWidth),
      .Addr(MIntThreshAddr)
  ) m_int_thresh (
      // in
      .clk,
      .reset,
      .csr_enable,
      .csr_addr,
      .rs1_zimm,
      .rs1_data,
      .csr_op,
      .ext_data(m_int_thresh_data),
      .ext_write_enable(m_int_thresh_write_enable),
      // out
      .direct_out(m_int_thresh_direct_out),
      .out(m_int_thresh_out)
  );
  
  
  word mstatus_direct_out;
  word mstatus_out;
  csr #(
    .CsrWidth(MStatusWidth),
    .Addr(MStatusAddr)
  ) mstatus (
    .clk,
    .reset,
    .csr_enable,
    .csr_addr,
    .rs1_zimm,
    .rs1_data,
    .csr_op,
    .ext_data(MStatusT'(0)),
    .ext_write_enable(1'(0)),
    .direct_out(mstatus_direct_out),
    .out(mstatus_out)
  );

  // packed struct allowng for 5 bit immediates in CSR
  typedef struct packed {
    PrioT prio;
    logic enabled;
    logic pended;   // LSB
  } entry_t;

  // stack
  logic push;
  logic pop;
  typedef struct packed {
    IMemAddrT addr;
    PrioT     prio;
  } stack_t;

  stack_t stack_out;
  // epc address stack
  stack #(
      .StackDepth(PrioNum),
      .DataWidth ($bits(stack_t))
  ) epc_stack (
      // in
      .clk,
      .reset,
      .push,
      .pop,
      .data_in  ({pc_in, m_int_thresh.data}),
      // out,
      .data_out (stack_out),
      .index_out(level_out)
  );

  // generate vector table
  typedef logic [(IMemAddrWidth - 2)-1:0] IMemAddrStore;

  entry_t                            entry           [VecSize];
  PrioT                              prio            [VecSize];
  IMemAddrStore                      csr_vec_data    [VecSize];
  logic                              ext_write_enable[VecSize];
  logic         [$bits(entry_t)-1:0] ext_entry_data  [VecSize];
  generate
    word temp_vec  [VecSize];
    word temp_entry[VecSize];
    word vec_out   [VecSize];
    word entry_out [VecSize];

    for (genvar k = 0; k < VecSize; k++) begin : gen_vec
      csr #(
          .Addr(VecCsrBase + CsrAddrT'(k)),
          .CsrWidth(IMemAddrWidth - 2)
      ) csr_vec (
          // in
          .clk,
          .reset,
          .csr_enable,
          .csr_addr,
          .csr_op,
          .rs1_zimm,
          .rs1_data,
          .ext_write_enable(0),
          .ext_data(0),
          // out
          .direct_out(temp_vec[k]),
          .out(vec_out[k])
      );

      csr #(
          .Addr(EntryCsrBase + CsrAddrT'(k)),
          .CsrWidth($bits(entry_t))
      ) csr_entry (
          // in
          .clk,
          .reset,
          .csr_enable,
          .csr_addr,
          .csr_op,
          .rs1_zimm,
          .rs1_data,
          .ext_write_enable(ext_write_enable[k]),
          .ext_data(ext_entry_data[k]),
          // out
          .direct_out(temp_entry[k]),
          .out(entry_out[k])
      );

      assign entry[k]        = entry_t'(temp_entry[k]);
      assign prio[k]         = entry[k].prio;  // a bit of a hack to please Verilator
      assign csr_vec_data[k] = IMemAddrStore'(temp_vec[k]);
    end
  endgenerate

  // simple implementation to find max priority
  PrioT         max_prio [VecSize];
  IMemAddrStore max_vec  [VecSize];
  VecT          max_index[VecSize];
  always_comb begin
    // check first index in vector table
    if (entry[0].enabled && entry[0].pended && (prio[0] >= m_int_thresh.data)) begin
      max_prio[0]  = prio[0];
      max_vec[0]   = csr_vec_data[0];
      max_index[0] = 0;
    end else begin
      max_prio[0]  = m_int_thresh.data;
      max_vec[0]   = 0;
      max_index[0] = 0;
    end
    // check rest of vector table
    for (integer k = 1; k < VecSize; k++) begin
      if (entry[k].enabled && entry[k].pended && (prio[k] >= max_prio[k-1])) begin
        max_prio[k]  = prio[k];
        max_vec[k]   = csr_vec_data[k];
        max_index[k] = VecT'(k);
      end else begin
        max_prio[k]  = max_prio[k-1];
        max_vec[k]   = max_vec[k-1];
        max_index[k] = max_index[k-1];
      end
    end
  end

  // handle interrupts: take-, tail-chain-, exit- and no-interrupt
  always_comb begin
  // this assignment is broken under vivado, always yields max_i = x
    automatic VecT max_i = max_index[VecSize-1];
    ext_write_enable = '{default: '0};  // we don't touch the csr:s by default
    ext_entry_data   = '{default: '0};

    if (timer_interrupt_set) begin
      // pend 0 if timer interrupt
      ext_write_enable[0] = 1;
      ext_entry_data[0]   = entry[0] | 1;  // set pend bit
    end
    
    if (mstatus_direct_out[3] == 0) begin
      push = 0;
      pop = 0;
      m_int_thresh_data = 0;
      m_int_thresh_write_enable = 0;
      int_addr = pc_in;
      interrupt_out = 0;
      pc_interrupt_sel = PC_NORMAL;
      timer_interrupt_clear = 0;
    end else if (max_prio[VecSize-1] > m_int_thresh.data) begin
      // take higher priority interrupt
      push = 1;
      pop = 0;
      int_addr = {max_vec[VecSize-1], 2'b00};  // convert to byte address inestruction memory
      m_int_thresh_data = max_prio[VecSize-1];
      m_int_thresh_write_enable = 1;
      interrupt_out = 1;
      pc_interrupt_sel = PC_INTERRUPT;
      ext_write_enable[max_i] = 1;  // write to entry
      ext_entry_data[max_i] = entry[max_i] & ~1;  // clear pend bit
      if (max_i == 0) begin
        $display("take timer");
        timer_interrupt_clear = 1;
      end else timer_interrupt_clear = 0;
      $display("max_i: %d", max_i);
      $display("max_index[VecSize-1] %d", max_index[VecSize-1]);
      $display("interrupt take int_addr %d", int_addr);
    end else if ((pc_in == ~(IMemAddrWidth'(0))) &&
        entry[max_i].enabled && entry[max_i].pended &&
        (max_prio[VecSize-1] >= m_int_thresh.data)) begin
      // tail chain only in case the vector is actually enabled and pended
      push = 0;
      pop = 0;
      int_addr = {max_vec[VecSize-1], 2'b00};  // convert to byte addressed instruction memory
      m_int_thresh_data = 0;  // no update of threshold
      m_int_thresh_write_enable = 0;  // no update of threshold
      interrupt_out = 1;
      pc_interrupt_sel = PC_INTERRUPT;
      ext_write_enable[max_i] = 1;  // write to entry
      ext_entry_data[max_i] = entry[max_i] & ~1;  // clear pend bit
      if (max_i == 0) begin
        $display("take timer");
        timer_interrupt_clear = 1;
      end else timer_interrupt_clear = 0;
      $display("tail chaining level_out %d, pop %d", level_out, pop);
    end else if (pc_in == ~(IMemAddrWidth'(0))) begin
      // interrupt return
      push = 0;
      pop = 1;
      int_addr = stack_out.addr;
      m_int_thresh_data = stack_out.prio;
      m_int_thresh_write_enable = 1;
      interrupt_out = 0;
      pc_interrupt_sel = PC_INTERRUPT;
      timer_interrupt_clear = 0;
      $display("interrupt return");
    end else begin
      // no interrupt
      push = 0;
      pop = 0;
      m_int_thresh_data = 0;
      m_int_thresh_write_enable = 0;
      int_addr = pc_in;
      interrupt_out = 0;
      pc_interrupt_sel = PC_NORMAL;
      timer_interrupt_clear = 0;
      // $display("interrupt NOT take");
    end
  end

  // set csr_out
  always_comb begin
    csr_out = 0;
    if (csr_addr == TimerAddr) begin
      csr_out = timer_out;

      $display("!!! CSR timer_out !!!");
    end else if (csr_addr == MIntThreshAddr) begin
      csr_out = m_int_thresh_out;

      $display("!!! CSR m_thresh_out !!!");
    end else if (csr_addr == StackDepthAddr) begin
      csr_out = 32'($unsigned(level_out));

      $display("!!! CSR StackDepth !!!");
    end else begin
      for (int k = 0; k < VecSize; k++) begin
        if (csr_addr == VecCsrBase + CsrAddrT'(k)) begin
          csr_out = vec_out[k];
        end
        if (csr_addr == EntryCsrBase + CsrAddrT'(k)) begin
          csr_out = entry_out[k];
        end
      end
    end
  end
endmodule

