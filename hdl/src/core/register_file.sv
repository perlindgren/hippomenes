`timescale 1ns / 1ps

module register_file
  import config_pkg::*;
#(
    parameter bit DummyInstructions = 0,
    parameter bit WrenCheck         = 0,
    parameter bit RdataMuxCheck     = 0,

    localparam RegT RegZeroVal = '0
) (
    // Clock and Reset
    input logic clk_i,
    input logic rst_ni,

    //Read port R1
    input RegAddrT raddr_a_i,
    output RegT rdata_a_o,
    //Read port R2
    input RegAddrT raddr_b_i,
    output RegT rdata_b_o,
    // Write port W1
    input RegAddrT waddr_a_i,
    input RegT wdata_a_i,
    input logic we_a_i
);

  RegT  mem[RegNum];
  // DataT mem_o_a, mem_o_b;
  logic we;

  assign we = we_a_i;
  assign rdata_a_o = mem[raddr_a_i];
  assign rdata_b_o = mem[raddr_b_i];

  // Note that the SystemVerilog LRM requires variables on the LHS of assignments within
  // "always_ff" to not be written to by any other process. However, to enable the initialization
  // of the inferred RAM32M primitives with non-zero values, below "initial" procedure is needed.
  // Therefore, we use "always" instead of the generally preferred "always_ff" for the synchronous
  // write procedure.
  always @(posedge clk_i) begin : sync_write
    if (we == 1'b1 && waddr_a_i != 0) begin
      mem[waddr_a_i] <= wdata_a_i;
    end
  end : sync_write

  // Make sure we initialize the BRAM with the correct register reset value.
  initial begin
    for (int k = 0; k < RegNum; k++) begin
      mem[k] = RegZeroVal;
    end
  end

  // Reset not used in this register file version
  logic unused_reset;
  assign unused_reset = rst_ni;

endmodule
