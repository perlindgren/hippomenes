// mem
`timescale 1ns / 1ps


module n_clic
  import decoder_pkg::*;
  import config_pkg::*;
#(
    parameter  integer VecSize  = 8,
    localparam integer VecWidth = $clog2(VecSize), // derived

    parameter  integer PrioLevels = 8,
    localparam integer PrioWidth  = $clog2(PrioLevels), // derived

    parameter integer VecCsrBase   = 'hb00,
    parameter integer EntryCsrBase = 'hb20,  // up to 32 vectors

    // csr registers
    localparam csr_addr_t MStatusAddr    = 'h305,
    localparam csr_addr_t MIntThreshAddr = 'h347,
    localparam csr_addr_t StackDepthAddr = 'h350
) (
    input logic clk,
    input logic reset,

    // csr registers
    input logic csr_enable,
    input csr_addr_t csr_addr,
    input r rs1_zimm,
    input word rs1_data,
    input csr_op_t csr_op,

    // epc
    input logic [IMemAddrWidth-1:0] pc_in,

    //
    output word out,
    output logic [IMemAddrWidth-1:0] pc_out
);

  // CSR m_int_thresh
  (* DONT_TOUCH = "TRUE" *)
  logic m_int_thresh_write_enable;
  (* DONT_TOUCH = "TRUE" *)
  word m_int_thresh_out;
  (* DONT_TOUCH = "TRUE" *)
  logic [PrioWidth-1:0] m_int_thresh_data;
  (* DONT_TOUCH = "TRUE" *)
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
      .out(m_int_thresh_out)
  );

  // typedef struct packed {
  //   integer width;
  //   csr_addr_t addr;
  //   word reset_val;
  //   logic read;
  //   logic write;
  // } csr_struct_t;

  // packed struct allowng for 5 bit immediates in CSR
  typedef struct packed {
    logic [PrioWidth-1:0] prio;
    logic enabled;
    logic pended;  // LSB
  } entry_t;

  // stack_t data_in;

  // stack
  logic push;
  logic pop;
  typedef struct packed {
    logic [IMemAddrWidth-1:0] addr;
    logic [PrioWidth-1:0]     prio;
  } stack_t;

  stack_t stack_out;
  logic [PrioWidth-1:0] level_out;  // stack depth
  // epc address stack
  stack #(
      .StackDepth(PrioLevels),
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
  /* verilator lint_off UNOPTFLAT */
  logic   [         PrioWidth-1:0] max_prio    [VecSize];
  logic   [(IMemAddrWidth -2)-1:0] max_vec     [VecSize];
  logic                            is_int      [VecSize];

  entry_t                          entry       [VecSize];
  logic   [         PrioWidth-1:0] prio        [VecSize];
  logic   [(IMemAddrWidth -2)-1:0] csr_vec_data[VecSize];

  generate
    word temp_vec[VecSize];
    word temp_entry[VecSize];

    // automatically connected
    logic ext_write_enable;
    logic [(IMemAddrWidth - 2)-1:0] ext_vec_data;
    logic [$bits(entry_t)-1:0] ext_entry_data;

    for (genvar k = 0; k < VecSize; k++) begin : gen_vec
      csr #(
          .Addr(12'(VecCsrBase + k)),
          .CsrWidth(IMemAddrWidth - 2)
      ) csr_vec (
          // in
          .*,
          .ext_write_enable,
          .ext_data(ext_vec_data),
          // out
          .out(temp_vec[k])
      );

      csr #(
          .Addr(12'(EntryCsrBase + k)),
          .CsrWidth($bits(entry_t))
      ) csr_entry (
          // in
          .*,
          .ext_write_enable,
          .ext_data(ext_entry_data),
          // out
          .out(temp_entry[k])
      );

      assign entry[k]         = gen_vec[k].csr_entry.data;
      assign prio[k]          = entry[k].prio;  // a bit of a hack to please Verilator
      assign csr_vec_data[k]  = gen_vec[k].csr_vec.data;

      // one hot encoding, only one match allowed
      // assign out = (csr_addr == 12'(VecCsrBase + k)) ? temp_vec[k] : 'z;
      // assign out = (csr_addr == 12'(EntryCsrBase + k)) ? temp_entry[k] : 'z;
      assign ext_write_enable = 0;  // these should not be written as of now
      assign ext_vec_data     = 0;  // these should not be written as of now
      assign ext_entry_data   = 0;  // these should not be written as of now
    end

  endgenerate

  // stupid implementation to find max priority
  always_comb begin
    for (integer k = 0; k < VecSize; k++) begin
      if (k == 0) begin
        if (entry[k].enabled && entry[k].pended && (prio[k] > m_int_thresh.data)) begin
          is_int[0]   = 1;
          max_prio[0] = prio[k];
          max_vec[0]  = csr_vec_data[k];
        end else begin
          is_int[0]   = 0;
          max_prio[0] = m_int_thresh.data;
          max_vec[0]  = 0;
        end
      end else begin
        if (entry[k].enabled && entry[k].pended && (prio[k] > max_prio[k-1])) begin
          is_int[k]   = 1;
          max_prio[k] = prio[k];
          max_vec[k]  = csr_vec_data[k];
        end else begin
          is_int[k]   = is_int[k-1];
          max_prio[k] = max_prio[k-1];
          max_vec[k]  = max_vec[k-1];
        end
      end
    end
  end

  always_comb begin
    // check return from interrupt condition
    if (pc_in == ~(IMemAddrWidth'(0)) && is_int[VecSize-1]) begin
      // tail chaining, not sure this is correct
      push = 0;
      pop = 0;
      pc_out = {max_vec[VecSize-1], 2'b00};  // convert to byte address inestruction memory
      m_int_thresh_data = 0;  // no update of threshold
      m_int_thresh_write_enable = 0;  // no update of threshold
      // $display("tail chaining level_out %d, pop %d", level_out, pop);
    end else if (is_int[VecSize-1]) begin
      push = 1;
      pop = 0;
      pc_out = {max_vec[VecSize-1], 2'b00};  // convert to byte address inestruction memory
      m_int_thresh_data = max_prio[VecSize-1];
      m_int_thresh_write_enable = 1;
      // $display("interrupt take pc_out %d", pc_out);
    end else if (pc_in == ~(IMemAddrWidth'(0))) begin
      push = 0;
      pop = 1;
      pc_out = stack_out.addr;
      m_int_thresh_data = stack_out.prio;
      m_int_thresh_write_enable = 1;
      // $display("pop");
    end else begin
      push = 0;
      pop = 0;
      m_int_thresh_data = 0;
      m_int_thresh_write_enable = 0;
      pc_out = pc_in;
      // $display("interrupt NOT take");
    end
  end

  always_latch begin
    if (csr_addr == 12'(MIntThreshAddr)) begin
      out = m_int_thresh_out;
    end else begin
      for (int k = 0; k < VecSize; k++) begin
        if (csr_addr == 12'(VecCsrBase + k)) begin
          out = temp_vec[k];
          break;
        end
      end
      for (int k = 0; k < VecSize; k++) begin
        if (csr_addr == 12'(EntryCsrBase + k)) begin
          out = temp_vec[k];
          break;
        end
      end
    end
  end
endmodule




// // TODO: move to config
// localparam csr_struct_t CsrVec[3] = {
//   '{PrioWidth, MIntThreshAddr, 20, 1, 1},
//   '{32, MStatusAddr, 10, 1, 1},
//   '{VecWidth, StackDepthAddr, 8, 1, 0}
// };
// generate generic csr registers
// generate
//   word temp[3];
//   for (genvar k = 0; k < 3; k++) begin : gen_csr
//     csr #(
//         .CsrWidth(CsrVec[k].width),
//         .Addr(CsrVec[k].addr),
//         .ResetValue(CsrVec[k].reset_val[CsrVec[k].width-1:0]),
//         .Read(CsrVec[k].read),
//         .Write(CsrVec[k].write)
//     ) csr (
//         // in
//         .*,
//         // out
//         .out(temp[k])
//     );

//     // one hot encoding, only one match allowed
//     assign out = (csr_addr == CsrVec[k].addr) ? temp[k] : 'z;
//   end

// endgenerate
