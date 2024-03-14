// rf_stack
`timescale 1ns / 1ps

module rf_stack
  import config_pkg::*;
(
    input logic clk,
    input logic reset,
    input logic writeEn,
    input logic writeRaEn,
    input PrioT level,
    input RegAddrT writeAddr,
    input RegT writeData,
    input RegAddrT readAddr1,
    input RegAddrT readAddr2,
    output RegT readData1,
    output RegT readData2
);
  RegT a_o[PrioNum];
  RegT b_o[PrioNum];
  // RegAddrT wa_i[PrioNum];
  // RegT wd_i[PrioNum];
  logic we[PrioNum];
  logic ra_set[PrioNum];

  generate
    for (genvar k = 0; k < PrioNum; k++) begin : gen_rf
      register_file rf (
          .clk_i(clk),
          .rst_ni(reset),
          //Read port R1
          .raddr_a_i(readAddr1),
          .rdata_a_o(a_o[k]),
          //Read port R2
          .raddr_b_i(readAddr2),
          .rdata_b_o(b_o[k]),
          // Write port W1
          // .waddr_a_i(wa_i[k]),
          // .wdata_a_i(wd_i[k]),
          .waddr_a_i(writeAddr),
          .wdata_a_i(writeData),
          .we_a_i(we[k]),
          // magic
          .ra_set(ra_set[k])
      );
    end
  endgenerate

  RegT  sp_a_o;
  RegT  sp_b_o;
  logic sp_we;
  // RegT  sp_wdata;

  rf #(
      .RegNum(1)  // A single instance for Ra
  ) sp (
      // Clock and Reset
      .clk_i(clk),
      .rst_ni(reset),
      // Read port R1
      .raddr_a_i(0),
      .rdata_a_o(sp_a_o),
      // Read port R2
      .raddr_b_i(0),
      .rdata_b_o(sp_b_o),
      // Write port W1
      .waddr_a_i(0),
      //.wdata_a_i(sp_wdata),
      .wdata_a_i(writeData),
      .we_a_i(sp_we)
  );


  always_comb begin
    // Writes
    // Sp
    sp_we = writeEn && (writeAddr == Sp);

    // Register Ra and > Sp
    for (integer k = 0; k < PrioNum; k++) begin
      we[k] = (level == PrioT'(k)) && writeEn && (writeAddr == Ra || (writeAddr > Sp));
      ra_set[k] = 0;
    end

    // Ra (on interrupt)
    if (writeRaEn) ra_set[level-1] = 1;

    // Reads to rs1
    if (readAddr1 == Zero) readData1 = 0;
    else if (readAddr1 == Sp) readData1 = sp_a_o;
    else readData1 = a_o[level];
    // Reads to rs2
    if (readAddr2 == Zero) readData2 = 0;
    else if (readAddr2 == Sp) readData2 = sp_b_o;
    else readData2 = b_o[level];
  end

endmodule
