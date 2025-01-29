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
//  - Version 1.2: Replace with byte enable template (AN - 170624)
//  - Version 1.3: Strip down, rename signals to more conventional names (AN - 131124)
//------------------------------------------------------------------------------


//  Xilinx Single Port Byte-Write Write First RAM
//  This code implements a parameterizable single-port byte-write write-first memory where when data
//  is written to the memory, the output reflects the new memory contents.
//  If a reset or enable is not necessary, it may be tied off or removed from the code.
//  Modify the parameters for the desired RAM characteristics.

module xilinx_sp_BRAM #(
    parameter string INIT_FILE = "",
    parameter int unsigned NB_COL = 4,  // Specify number of columns (number of bytes)
    parameter int unsigned COL_WIDTH = 8,  // Specify column width (byte width, typically 8 or 9)
    parameter int unsigned RAM_DEPTH = 1024,  // Specify RAM depth (number of entries)
    localparam int unsigned DataWidth = NB_COL * COL_WIDTH
) (
    input  logic                         clk_i,
    input  logic                         rst_ni,
    input  logic                         req_i,
    input  logic [$clog2(RAM_DEPTH)-1:0] addr_i,
    input  logic [        DataWidth-1:0] wdata_i,
    input  logic [           NB_COL-1:0] bwe_i,
    output logic [        DataWidth-1:0] rdata_o
);

  logic [DataWidth-1:0] BRAM[RAM_DEPTH];
  //logic [$clog2(RAM_DEPTH)-1:0] addr_q;

  generate
    integer ram_index;
    initial begin
      if (INIT_FILE == "") begin
        for (ram_index = 0; ram_index < RAM_DEPTH; ram_index++)
        BRAM[ram_index] = {(DataWidth) {1'b0}};
      end else begin
        $readmemh(INIT_FILE, BRAM);
      end
    end
  endgenerate

  for (genvar i = 0; i < NB_COL; i = i + 1) begin : g_byte_write
    always @(posedge clk_i) begin
      if (req_i)
        if (bwe_i[i]) begin
          BRAM[addr_i][(i+1)*COL_WIDTH-1:i*COL_WIDTH] <= wdata_i[(i+1)*COL_WIDTH-1:i*COL_WIDTH];
        end
    end
  end : g_byte_write

  always_ff @(posedge clk_i) begin
    if (~rst_ni) rdata_o <= '0;
    else if (req_i) rdata_o <= BRAM[addr_i];
  end

endmodule

// The following is an instantiation template for xilinx_single_port_byte_write_ram_write_first
/*
  //  Xilinx Single Port Byte-Write Write First RAM
  xilinx_single_port_byte_write_ram_write_first #(
    .NB_COL(4),                           // Specify number of columns (number of bytes)
    .COL_WIDTH(9),                        // Specify column width (byte width, typically 8 or 9)
    .RAM_DEPTH(1024),                     // Specify RAM depth (number of entries)
    .RAM_PERFORMANCE("HIGH_PERFORMANCE"), // Select "HIGH_PERFORMANCE" or "LOW_LATENCY"
    .INIT_FILE("")                        // Specify name/location of RAM initialization file if using one (leave blank if not)
  ) your_instance_name (
    .addra(addra),     // Address bus, width determined from RAM_DEPTH
    .dina(dina),       // RAM input data, width determined from DATA_WIDTH
    .clka(clka),       // Clock
    .wea(wea),         // Byte-write enable, width determined from NB_COL
    .ena(ena),         // RAM Enable, for additional power savings, disable port when not in use
    .rsta(rsta),       // Output reset (does not affect memory contents)
    .regcea(regcea),   // Output register enable
    .douta(douta)      // RAM output data, width determined from DATA_WIDTH
  );
*/
