// mem
`timescale 1ns / 1ps

module n_clic
  import config_pkg::*;
  import mem_pkg::*;
#(
    parameter  integer VecSize  = 8,
    localparam integer VecWidth = $clog2(VecSize)  // derived
) (
    input logic clk,
    input logic reset,
    input logic csr_enable,
    input csr_addr_t csr_addr,
    input r rs1,
    input r rd,
    input csr_t op,
    input word in,
    output word out
);

  word  mstatus_out;
  logic mstatus_match;
  csr #(
      .Addr('h305)
  ) mstatus (
      // in
      .clk(clk),
      .reset(reset),
      .en(csr_enable),
      .rs1(rs1),
      .rd(rd),
      .addr(csr_addr),
      .op(op),
      .in(in),
      // out
      .match(mstatus_match),
      .out(mstatus_out)
  );

  // word stack_depth;
  // csr #(
  //     .Addr('h350)
  // ) mstatus (
  //     .clk(clk),
  //     .reset(reset),
  //     .en(csr_enable),
  //     .rs1(rs1),
  //     .rd(rd),
  //     .addr(csr_addr),
  //     .op(op),
  //     .in(in),
  //     .old(mstatus_out)
  // );

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




