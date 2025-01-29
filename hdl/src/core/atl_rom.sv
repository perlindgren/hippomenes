// Wrapper around inferred block ram as suggested by Antti

module atl_rom
  import config_pkg::*;
#(
) (
    input logic clk_i,
    input logic rst_i,

    input IMemAddrT addr_i,

    output word data_o
);

  xilinx_sp_BRAM #() bram (
      .clk_i,
      .rst_ni(~rst_i),

      // this is a ROM we are probably fine with
      // tying this to 1?
      .req_i(1),

      // same here
      .wdata_i(0),

      .addr_i(addr_i),

      // yes ?
      .bwe_i(0),

      .rdata_o(data_o)
  );

endmodule
