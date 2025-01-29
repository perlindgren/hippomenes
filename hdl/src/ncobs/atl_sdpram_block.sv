module atl_sdpram_block #(
    parameter integer FifoSizeBits = 1024,
    parameter integer AddrSize = FifoBlockAddrWidth
) (
    input logic clk,
    input logic reset,
    input [AddrSize-1:0] address_write,
    input [AddrSize-1:0] address_read,
    input logic write_enable,
    input logic [7:0] data_in,
    output logic [7:0] data_out
);
  logic [7:0] throwaway;
  xilinx_dp_BRAM #(
      .RAM_WIDTH(8),  // Specify RAM data width
      .RAM_DEPTH(FifoSizeBits / 8)  // Specify RAM depth (number of entries)
  ) block (
      .addra(address_write),  // Port A address bus, width determined from RAM_DEPTH
      .addrb(address_read),  // Port B address bus, width determined from RAM_DEPTH
      .dina(data_in),  // Port A RAM input data
      .dinb(0),  // Port B RAM input data
      .clka(clk),  // Clock
      .wea(write_enable),  // Port A write enable
      .web(0),  // Port B write enable
      .ena(1),  // Port A RAM Enable, for additional power savings, disable port when not in use
      .enb(1),  // Port B RAM Enable, for additional power savings, disable port when not in use
      .rsta(reset),  // Port A output reset (does not affect memory contents)
      .rstb(reset),  // Port B output reset (does not affect memory contents)
      .regcea(0),  // Port A output register enable
      .regceb(1),  // Port B output register enable
      .douta(throwaway),  // Port A RAM output data
      .doutb(data_out)  // Port B RAM output data
  );
endmodule
