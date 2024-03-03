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

    parameter integer VecCsrBase = 'hb00,

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
    csr_addr_t addr;
    word reset_val;
    logic read;
    logic write;
  } csr_struct_t;

  localparam csr_struct_t CsrVec[3] = {
    '{MStatusAddr, 10, 1, 1},  //
    '{MIntThreshAddr, 20, 1, 1},  //
    '{StackDepthAddr, 8, 1, 0}
  };

  // smart packed struct allowng for 5 bit immediates in CSR
  typedef struct packed {
    logic pended;
    logic enable;
    logic [PrioWidth-1:0] prio;
  } entry_t;

  // emulating vector table entry
  word out2;
  csr #(
      .ResetValue(3),
      .CsrWidth($bits(entry_t)),
      .Addr(10)
  ) test_entry_csr (
      // in
      .clk(clk),
      .reset(reset),
      .csr_en(csr_enable),
      .csr_addr(csr_addr),
      .rs1_zimm(rs1_zimm),
      .rs1_data(rs1_data),
      .csr_op(csr_op),
      // out
      .out(out2)
  );

  // emulting vector table address
  word out3;
  csr #(
      .ResetValue('h10),  // default vector
      .CsrWidth(IMemAddrWidth - 2),  // word indexes, RVI
      .Addr(20)
  ) test_vec_csr (
      // in
      .clk(clk),
      .reset(reset),
      .csr_en(csr_enable),
      .csr_addr(csr_addr),
      .rs1_zimm(rs1_zimm),
      .rs1_data(rs1_data),
      .csr_op(csr_op),
      // out
      .out(out3)
  );


  // generate generic csr registers
  generate
    word temp[3];
    for (genvar k = 0; k < 3; k++) begin : gen_csr
      csr #(
          .Addr(CsrVec[k].addr),
          .ResetValue(CsrVec[k].reset_val),
          .Read(CsrVec[k].read),
          .Write(CsrVec[k].write)
      ) csr (
          // in
          .clk(clk),
          .reset(reset),
          .csr_en(csr_enable),
          .csr_addr(csr_addr),
          .rs1_zimm(rs1_zimm),
          .rs1_data(rs1_data),
          .csr_op(csr_op),
          // out
          .out(temp[k])
      );

      // one hot encoding, only one match allowed
      assign out = (csr_addr == CsrVec[k].addr) ? temp[k] : 'z;
    end

  endgenerate

  // generate vector table
  generate
    word temp_vec[VecSize];
    for (genvar k = 0; k < VecSize; k++) begin : gen_vec
      csr #(
          .Addr(12'(VecCsrBase + k))
      ) csr (
          // in
          .clk(clk),
          .reset(reset),
          .csr_en(csr_enable),
          .csr_addr(csr_addr),
          .rs1_zimm(rs1_zimm),
          .rs1_data(rs1_data),
          .csr_op(csr_op),
          // out
          .out(temp_vec[k])
      );

      // one hot encoding, only one match allowed
      assign out = (csr_addr == 12'(VecCsrBase + k)) ? temp_vec[k] : 'z;
    end

  endgenerate

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




