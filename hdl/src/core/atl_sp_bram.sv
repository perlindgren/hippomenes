// Wrapper around inferred block ram as suggested by Antti

module atl_sp_bram
  import config_pkg::*;
#(
    parameter string INIT_FILE = "",
    parameter integer BRAM_WIDTH_BITS = 8,
    parameter integer BRAM_DEPTH = 1024
) (
    input logic clk_i,
    input logic rst_i,

    input IMemAddrT addr_i,

    input logic we_i,

    input logic [BRAM_WIDTH_BITS-1:0] data_i,


    output word data_o
);

  xilinx_sp_BRAM #(
      .INIT_FILE(INIT_FILE),
      .NB_COL(BRAM_WIDTH_BITS / 8),
      .RAM_DEPTH(BRAM_DEPTH)
  ) bram (
      .clk_i,
      .rst_ni(~rst_i),

      // this is a ROM we are probably fine with
      // tying this to 1?
      .req_i(1),

      // same here
      .wdata_i(0),

      .addr_i(addr_i),

      // yes ?
      .bwe_i({BRAM_WIDTH_BITS{we_i}}),

      .rdata_o(data_o)
  );

endmodule
