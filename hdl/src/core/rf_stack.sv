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
  localparam RegAddrT Zero = 0;  // x0
  localparam RegAddrT Ra = 1;  // x1
  localparam RegAddrT Sp = 2;  // x2

  RegT a_o[PrioNum];
  RegT b_o[PrioNum];
  RegAddrT wa_i[PrioNum];
  RegT wd_i[PrioNum];
  logic we[PrioNum];

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
          .waddr_a_i(wa_i[k]),
          .wdata_a_i(wd_i[k]),
          .we_a_i(we[k])
      );

    end
  endgenerate

  always_latch begin
    for (integer k = 0; k < PrioNum; k++) begin
      we[k]   = 0;
      wa_i[k] = writeAddr;
      wd_i[k] = writeData;

      // only one will match
      if (level == PrioT'(k)) begin
        readData1 = (writeEn && (writeAddr == readAddr1)) ? writeData : a_o[k];
        readData2 = (writeEn && (writeAddr == readAddr2)) ? writeData : b_o[k];
      end
      // Sp goes to all levels
      we[k] = writeEn & ((level == PrioT'(k)) | (writeAddr == Sp));
    end

    if (writeRaEn) begin
      we[level-1]   = 1;
      wa_i[level-1] = Ra;
      wd_i[level-1] = ~0;
    end
  end

endmodule

// logic [NumLevels-1:0][NumRegs-1:0][DataWidth-1:0] regs;

// LevelT level_minus_1;

// always_comb level_minus_1 = level - 1;

// always_ff @(posedge clk) begin
//   if (reset) begin
//     regs <= 0;
//   end else begin  // do not write to register 0
//     if (writeEn && (writeAddr != Zero)) begin
//       if (writeAddr == Sp) regs[0][writeAddr] <= writeData;
//       else regs[level][writeAddr] <= writeData;
//     end
//     // update ra with marker
//     if (writeRaEn) begin
//       $display("INTERRUPT_REG_FILE = %d, level-1 %d", writeRaEn, level_minus_1);
//       regs[level_minus_1][Ra] <= ~0;
//     end
//   end
// end

// always_comb begin
//   if (readAddr1 == Zero) begin
//     readData1 = 0;
//   end else if (writeEn && (readAddr1 == writeAddr)) begin
//     readData1 = writeData;  // read write through
//   end else if (readAddr1 == Sp) begin
//     readData1 = regs[0][readAddr1];  // sp on level 0
//   end else readData1 = regs[level][readAddr1];

//   if (readAddr2 == Zero) begin
//     readData2 = 0;
//   end else if (writeEn && (readAddr2 == writeAddr)) begin
//     readData2 = writeData;  // read write through
//   end else if (readAddr2 == Sp) begin
//     readData2 = regs[0][readAddr2];  // sp on level 0
//   end else readData2 = regs[level][readAddr2];
// end
