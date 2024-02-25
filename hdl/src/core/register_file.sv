// Register file

module register_file #(
    parameter integer unsigned DataWidth  = 32,
    parameter integer unsigned NumRegs    = 32,
    parameter integer unsigned IndexWidth = $clog2(NumRegs)
) (
    input  reg                  clk,
    input  reg                  reset,
    input  reg                  writeEn,
    input  reg [IndexWidth-1:0] writeAddr,
    input  reg [ DataWidth-1:0] writeData,
    input  reg [IndexWidth-1:0] readAddr1,
    input  reg [IndexWidth-1:0] readAddr2,
    output reg [ DataWidth-1:0] readData1,
    output reg [ DataWidth-1:0] readData2
);

  logic [NumRegs-1:0][DataWidth-1:0] regs;

  always_ff @(posedge clk) begin
    // do not write to register 0
    if (reset) begin
      regs <= 0;
    end else if (writeEn && (writeAddr != 0)) begin
      regs[writeAddr] <= writeData;
    end
  end

  assign readData1 = (writeEn && (readAddr1==writeAddr) && writeAddr != 0) ?
  writeData : regs[readAddr1];
  assign readData2 = (writeEn && (readAddr2==writeAddr) && writeAddr != 0) ?
  writeData : regs[readAddr2];

endmodule
