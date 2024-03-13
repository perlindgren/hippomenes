// rf_stack
`timescale 1ns / 1ps

module rf_stack
  import config_pkg::*;
#(
    parameter  integer unsigned DataWidth   = 32,
    parameter  integer unsigned NumRegs     = 32,
    parameter  integer unsigned NumLevels   = 8,
    localparam integer unsigned RegsWidth   = $clog2(NumRegs),
    localparam integer unsigned LevelsWidth = $clog2(NumLevels),

    localparam type DataT  = logic [  DataWidth-1:0],
    localparam type LevelT = logic [LevelsWidth-1:0],
    localparam type AddrT  = logic [  RegsWidth-1:0],

    localparam AddrT Zero = 0,  // x0
    localparam AddrT Ra   = 1,  // x1
    localparam AddrT Sp   = 2   // x2
) (
    input  logic  clk,
    input  logic  reset,
    input  logic  writeEn,
    input  logic  writeRaEn,
    input  LevelT level,
    input  AddrT  writeAddr,
    input  DataT  writeData,
    input  AddrT  readAddr1,
    input  AddrT  readAddr2,
    output DataT  readData1,
    output DataT  readData2
);

  DataT a [NumLevels];
  DataT b [NumLevels];
  logic we[NumLevels];

  generate
    for (genvar k = 0; k < NumLevels; k++) begin : gen_rf
      register_file rf (
          .clk_i(clk),
          .rst_ni(reset),
          //Read port R1
          .raddr_a_i(readAddr1),
          .rdata_a_o(a[k]),
          //Read port R2
          .raddr_b_i(readAddr2),
          .rdata_b_o(b[k]),
          // Write port W1
          .waddr_a_i(writeAddr),
          .wdata_a_i(writeData),
          .we_a_i(we[k])
      );

    end
  endgenerate

  always_comb begin

    for (int k = 0; k < NumLevels; k++) begin
      // we know that this happens only for one case
      we[k] = 0;
      if (level == k) begin
        readData1 = a[k];
        readData2 = b[k];
        we[k] = writeEn;
      end
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
