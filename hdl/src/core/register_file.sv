`timescale 1ns / 1ps

module register_file
  import config_pkg::*;
(
    // Clock and Reset
    input logic clk_i,
    input logic rst_ni,

    // Read port R1
    input RegAddrT raddr_a_i,
    output RegT rdata_a_o,
    // Read port R2
    input RegAddrT raddr_b_i,
    output RegT rdata_b_o,
    // Write port W1
    input RegAddrT waddr_a_i,
    input RegT wdata_a_i,
    input logic we_a_i,
    // Set the ra register to magic number
    input logic ra_set
);

  RegT  x3_31_a_o;
  RegT  x3_31_b_o;
  logic x3_31_we;

  rf #(
      .RegNum(RegNum - 3)  // exlude Zero, Ra, Sp
  ) x3_x31 (
      // Clock and Reset
      .clk_i,
      .rst_ni,
      // Read port R1
      .raddr_a_i(raddr_a_i - 3),
      .rdata_a_o(x3_31_a_o),
      // Read port R2
      .raddr_b_i(raddr_b_i - 3),
      .rdata_b_o(x3_31_b_o),
      // Write port W1
      .waddr_a_i(waddr_a_i - 3),
      .wdata_a_i,
      .we_a_i(x3_31_we)
  );

  RegT  ra_a_o;
  RegT  ra_b_o;
  logic ra_we;
  RegT  ra_wdata;

  rf #(
      .RegNum(1)  // A single instance for Ra
  ) ra (
      // Clock and Reset
      .clk_i,
      .rst_ni,
      // Read port R1
      .raddr_a_i(0),
      .rdata_a_o(ra_a_o),
      // Read port R2
      .raddr_b_i(0),
      .rdata_b_o(ra_b_o),
      // Write port W1
      .waddr_a_i(0),
      .wdata_a_i(ra_wdata),
      .we_a_i(ra_we)
  );

  always_comb begin
    if (raddr_a_i == Ra) begin
      $display("raddr_a_i == Ra");
      rdata_a_o = ra_a_o;
    end else rdata_a_o = x3_31_a_o;

    if (raddr_b_i == Ra) begin
      $display("raddr_b_i == Ra");
      rdata_b_o = ra_b_o;
    end else rdata_b_o = x3_31_b_o;

    x3_31_we = we_a_i && (waddr_a_i > Sp);
    ra_we = (we_a_i && (waddr_a_i == Ra)) || ra_set;
    if (ra_set) begin
      $display("ra_wdata = ~0");
      ra_wdata = ~0;
    end else begin
      ra_wdata = wdata_a_i;
    end

    $display("x3_31_we %b, ra_we %b", x3_31_we, ra_we);

  end

endmodule

module rf
  import config_pkg::*;
#(
    parameter integer unsigned RegNum = 32,
    localparam integer unsigned RegAddrWidth = ($clog2(RegNum) > 0) ? $clog2(RegNum) : 1,
    localparam type RegAddrT = logic [RegAddrWidth-1:0]
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
  logic we;

  assign we = we_a_i;
  assign rdata_a_o = mem[raddr_a_i];
  assign rdata_b_o = mem[raddr_b_i];

  always_ff @(posedge clk_i) begin : sync_write
    if (we == 1'b1) begin
      $display("<< -- write -- >>");
      mem[waddr_a_i] <= wdata_a_i;
    end
  end : sync_write

  // maybe this will if implemented as native ram blocks
  initial begin
    for (int k = 0; k < RegNum; k++) begin
      mem[k] = 0;
    end
  end

  // Reset not used in this register file version
  logic unused_reset;
  assign unused_reset = rst_ni;

endmodule
