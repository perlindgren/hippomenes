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
    input logic csr_enable,
    input csr_addr_t csr_addr,
    input r rs1_zimm,
    input word rs1_data,
    input csr_op_t csr_op,
    output word out
);
  typedef struct packed {
    integer width;
    csr_addr_t addr;
    word reset_val;
    logic read;
    logic write;
  } csr_struct_t;

  // TODO: move to config
  localparam csr_struct_t CsrVec[3] = {
    '{PrioWidth, MIntThreshAddr, 20, 1, 1},  //
    '{32, MStatusAddr, 10, 1, 1},  //
    '{VecWidth, StackDepthAddr, 8, 1, 0}
  };
  // generate generic csr registers
  generate
    word temp[3];
    for (genvar k = 0; k < 3; k++) begin : gen_csr
      csr #(
          .CsrWidth(CsrVec[k].width),
          .Addr(CsrVec[k].addr),
          .ResetValue(CsrVec[k].reset_val[CsrVec[k].width-1:0]),
          .Read(CsrVec[k].read),
          .Write(CsrVec[k].write)
      ) csr (
          // in
          .*,
          // out
          .out(temp[k])
      );

      // one hot encoding, only one match allowed
      assign out = (csr_addr == CsrVec[k].addr) ? temp[k] : 'z;
    end

  endgenerate

  // smart packed struct allowng for 5 bit immediates in CSR
  typedef struct packed {
    logic [PrioWidth-1:0] prio;
    logic enabled;
    logic pended;  // LSB
  } entry_t;

  // generate vector table
  /* verilator lint_off UNOPTFLAT */
  logic [PrioWidth-1:0] max_prio[VecSize];
  logic [ VecWidth-1:0] max_vec [VecSize];
  logic                 is_int  [VecSize];

  generate
    word temp_vec[VecSize];
    word temp_entry[VecSize];
    logic [PrioWidth-1:0] prio;
    entry_t entry;

    for (genvar k = 0; k < VecSize; k++) begin : gen_vec
      csr #(
          .Addr(12'(VecCsrBase + k)),
          .CsrWidth(IMemAddrWidth - 2)
      ) csr_vec (
          // in
          .*,
          // out
          .out(temp_vec[k])
      );

      csr #(
          .Addr(12'(EntryCsrBase + k)),
          .CsrWidth($bits(entry_t))
      ) csr_entry (
          // in
          .*,
          // out
          .out(temp_entry[k])
      );

      // one hot encoding, only one match allowed
      assign out = (csr_addr == 12'(VecCsrBase + k)) ? temp_vec[k] : 'z;
      assign out = (csr_addr == 12'(EntryCsrBase + k)) ? temp_entry[k] : 'z;

      // stupid implementation to find max priority
      always_comb begin
        entry = csr_entry.data;
        prio  = entry.prio;  // a bit of a hack to please Verilator

        if (k == 0) begin
          if (entry.enabled && entry.pended && (prio > gen_csr[0].csr.data)) begin
            is_int[0]   = 1;
            max_prio[0] = prio;
            max_vec[0]  = 0;
          end else begin
            is_int[0]   = 0;
            max_prio[0] = gen_csr[0].csr.data;
            max_vec[0]  = 0;
          end
        end else begin
          if (entry.enabled && entry.pended && (prio > max_prio[k-1])) begin
            is_int[k]   = 1;
            max_prio[k] = prio;
            max_vec[k]  = k;
          end else begin
            is_int[k]   = is_int[k-1];
            max_prio[k] = max_prio[k-1];
            max_vec[k]  = max_vec[k-1];
          end
        end
      end
    end

  endgenerate

endmodule




