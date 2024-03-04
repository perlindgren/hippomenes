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
    logic pended;
    logic enable;
    logic [PrioWidth-1:0] prio;
  } entry_t;

  // generate vector table
  /* verilator lint_off UNOPTFLAT */
  logic [PrioWidth-1:0] max_prio[VecSize];
  logic [ VecWidth-1:0] max_vec [VecSize];
  logic                 max_int [VecSize];

  generate
    word temp_vec[VecSize];
    word temp_entry[VecSize];
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
        entry = csr_entry.data;  // a bit of a hack to please Verilator
        if (k == 0) begin
          if (entry.prio > gen_csr[0].csr.data) begin
            max_int[0]  = 1;
            max_prio[0] = entry.prio;
            max_vec[0]  = 0;
          end else begin
            max_int[0]  = 0;
            max_prio[0] = gen_csr[0].csr.data;
            max_vec[0]  = 0;
          end
        end else begin
          if (entry.prio > max_prio[k-1]) begin
            max_int[k]  = 1;
            max_prio[k] = entry.prio;
            max_vec[k]  = k;
          end else begin
            max_int[k]  = max_int[k-1];
            max_prio[k] = max_prio[k-1];
            max_vec[k]  = max_vec[k-1];
          end
        end
      end
    end

  endgenerate

  // logic [PrioWidth-1:0] max_prio;
  // entry_t en;
  // always_comb begin
  //   // naive way to find highest prio
  //   take_interrupt = 0;
  //   max_prio = gen_csr[0].csr.data;


  //   en = gen_vec[0].csr_entry.data;

  //   // if ((gen_vec[0].csr_entry.data).enable) begin
  //   //   $display("enable", entry_t'(gen_vec[0].csr_entry.data).enable);
  //   // end

  //   for (integer k = 0; k < VecSize; k++) begin
  //     en = gen_vec[k].csr_entry.data;
  //     $display("enable[%d]= %d", k, en.enable);
  //     //   // if (gen_vec[k].csr_entry.data.enable) begin
  //     //   //   $display("enable[%d]", k);
  //     //   // end

  //   end

  // end



  // word  mstatus_out;
  // logic mstatus_match;
  // csr #(
  //     .Addr(MStatusAddr)
  // ) mstatus (
  //     // in
  //     .clk(clk),
  //     .reset(reset),
  //     .en(csr_enable),
  //     .addr(csr_addr),
  //     .rs1_zimm(rs1_zimm),
  //     .rs1_data(rs1_data),
  //     .op(op),
  //     // out
  //     //.match(mstatus_match),
  //     .out(mstatus_out)
  // );

  // word  stack_depth_out;
  // logic stack_depth_match;
  // csr #(
  //     .Addr(StackDepthAddr)
  // ) stack_depth (
  //     //in
  //     .clk(clk),
  //     .reset(reset),
  //     .en(csr_enable),
  //     .addr(csr_addr),
  //     .rs1_zimm(rs1_zimm),
  //     .rs1_data(rs1_data),
  //     .op(op),
  //     // out
  //     //.match(stack_depth_match),
  //     .out(stack_depth_out)
  // );

  // always_comb begin

  //   case (csr_addr)
  //     MStatusAddr: out = mstatus_out;
  //     StackDepthAddr: out = stack_depth_out;
  //     default: out = 0;
  //   endcase

  // end

  //  csrstore.insert(0x300, 0); //mstatus
  //             csrstore.insert(0x305, 0b11); //mtvec, we only support vectored
  //             csrstore.insert(0x307, 0); //mtvt
  //             csrstore.insert(0x340, 0); //mscratch
  //             csrstore.insert(0x341, 0); //mepc
  //             csrstore.insert(0x342, 0); //mcause
  //             csrstore.insert(0x343, 0); //mtval
  //             csrstore.insert(0x345, 0); //mnxti
  //             csrstore.insert(0xFB1, 0); //mintstatus
  //             csrstore.insert(0x347, 0); //mintthresh
  //             csrstore.insert(0x348, 0); //mscratchcsw
  //             csrstore.insert(0x349, 0); //mscratchcswl
  //             csrstore.insert(0xF14, 0); //mhartid
  //             csrstore.insert(0x350, 0); //stack_depth, vanilla clic config
  //             csrstore.insert(0x351, 0); //super mtvec
  //             for i in 0xB00..=0xBBF {
  //                 csrstore.insert(i, 0); //set up individual interrupt config CSRs
  //             }
  //             for i in 0xD00..=0xDBF {
  //                 csrstore.insert(i, 0); //set up timestamping CSRs
  //             }
  //   logic [31:0] mem[MemSize >> 2];
endmodule




