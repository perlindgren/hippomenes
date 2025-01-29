//------------------------------------------------------------------------------
// Module   : xilinx_sp_BRAM.sv
//
// Project  : RT-SS
// Author(s): Tom Szymkowiak <thomas.szymkowiak@tuni.fi>
// Created  : 22-Nov-2022
//
// Description: Modified code taken from the single port BRAM taken from
// Xilinx templates.
//
// Parameters:
//  - RAM_WIDTH: Bit width of each row
//  - RAM_DEPTH: Number of rows
//  - INIT_FILE: Path to .mem file which is used to initialise RAM contents
//
// Inputs:
//  - addra: Address line
//  - dina: Write data in
//  - clka: Clock
//  - wea: Write enable
//  - ena: Read enable
//
// Outputs:
//  - douta: Read data out
//
// Revision History:
//  - Version 1.0: Initial release
//  - Version 1.1: Corrected formatting (03-Dec-2023 - Tom Szymkowiak)
//
//------------------------------------------------------------------------------

module xilinx_dp_BRAM #(
    parameter RAM_WIDTH = 18,  // Specify RAM data width
    parameter RAM_DEPTH = 1024,  // Specify RAM depth (number of entries)
    parameter RAM_PERFORMANCE = "LOW_LATENCY",  // Select "HIGH_PERFORMANCE" or "LOW_LATENCY" 
    parameter INIT_FILE = ""                   // Specify name/location of RAM initialization file if using one (leave blank if not)
) (
    // Port A address bus, width determined from RAM_DEPTH
    input logic [clogb2(RAM_DEPTH-1)-1:0] addra,
    // Port B address bus, width determined from RAM_DEPTH
    input logic [clogb2(RAM_DEPTH-1)-1:0] addrb,
    input logic [RAM_WIDTH-1:0] dina,  // Port A RAM input data
    input logic [RAM_WIDTH-1:0] dinb,  // Port B RAM input data
    input logic clka,  // Clock
    input logic wea,  // Port A write enable
    input logic web,  // Port B write enable
    input logic ena,  // Port A RAM Enable, for additional power savings, disable port when not in use
    input logic enb,  // Port B RAM Enable, for additional power savings, disable port when not in use
    input logic rsta,  // Port A output reset (does not affect memory contents)
    input logic rstb,  // Port B output reset (does not affect memory contents)
    input logic regcea,  // Port A output register enable
    input logic regceb,  // Port B output register enable
    output logic [RAM_WIDTH-1:0] douta,  // Port A RAM output data
    output logic [RAM_WIDTH-1:0] doutb  // Port B RAM output data
);


  //  Xilinx True Dual Port RAM Read First Single Clock
  //  This code implements a parameterizable true dual port memory (both ports can read and write).
  //  The behavior of this RAM is when data is written, the prior memory contents at the write
  //  address are presented on the output port.  If the output data is
  //  not needed during writes or the last read value is desired to be retained,
  //  it is suggested to use a no change RAM as it is more power efficient.
  //  If a reset or enable is not necessary, it may be tied off or removed from the code.


  logic [RAM_WIDTH-1:0] ram[RAM_DEPTH-1:0];
  logic [RAM_WIDTH-1:0] ram_data_a = {RAM_WIDTH{1'b0}};
  logic [RAM_WIDTH-1:0] ram_data_b = {RAM_WIDTH{1'b0}};

  // The following code either initializes the memory values to a specified file or to all zeros to match hardware
  generate
    if (INIT_FILE != "") begin : use_init_file
      initial $readmemh(INIT_FILE, ram, 0, RAM_DEPTH - 1);
    end else begin : init_bram_to_zero
      integer ram_index;
      initial
        for (ram_index = 0; ram_index < RAM_DEPTH; ram_index = ram_index + 1)
          ram[ram_index] = {RAM_WIDTH{1'b0}};
    end
  endgenerate

  always @(posedge clka)
    if (ena) begin
      if (wea) ram[addra] <= dina;
      ram_data_a <= ram[addra];
    end

  always @(posedge clka)
    if (enb) begin
      if (web) ram[addrb] <= dinb;
      ram_data_b <= ram[addrb];
    end

  //  The following code generates HIGH_PERFORMANCE (use output register) or LOW_LATENCY (no output register)
  generate
    if (RAM_PERFORMANCE == "LOW_LATENCY") begin : no_output_register

      // The following is a 1 clock cycle read latency at the cost of a longer clock-to-out timing
      assign douta = ram_data_a;
      assign doutb = ram_data_b;

    end else begin : output_register

      // The following is a 2 clock cycle read latency with improve clock-to-out timing

      logic [RAM_WIDTH-1:0] douta_reg = {RAM_WIDTH{1'b0}};
      logic [RAM_WIDTH-1:0] doutb_reg = {RAM_WIDTH{1'b0}};

      always @(posedge clka)
        if (rsta) douta_reg <= {RAM_WIDTH{1'b0}};
        else if (regcea) douta_reg <= ram_data_a;

      always @(posedge clka)
        if (rstb) doutb_reg <= {RAM_WIDTH{1'b0}};
        else if (regceb) doutb_reg <= ram_data_b;

      assign douta = douta_reg;
      assign doutb = doutb_reg;

    end
  endgenerate

  //  The following function calculates the address width based on specified RAM depth
  function integer clogb2;
    input integer depth;
    for (clogb2 = 0; depth > 0; clogb2 = clogb2 + 1) depth = depth >> 1;
  endfunction

endmodule
