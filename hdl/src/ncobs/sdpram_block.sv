
// XPM_MEMORY instantiation template for Simple Dual Port RAM configurations
// Refer to the targeted device family architecture libraries guide for XPM_MEMORY documentation
// =======================================================================================================================

// Parameter usage table, organized as follows:
// +---------------------------------------------------------------------------------------------------------------------+
// | Parameter name       | Data type          | Restrictions, if applicable                                             |
// |---------------------------------------------------------------------------------------------------------------------|
// | Description                                                                                                         |
// +---------------------------------------------------------------------------------------------------------------------+
// +---------------------------------------------------------------------------------------------------------------------+
// | ADDR_WIDTH_A         | Integer            | Range: 1 - 20. Default value = 6.                                       |
// |---------------------------------------------------------------------------------------------------------------------|
// | Specify the width of the port A address port addra, in bits.                                                        |
// | Must be large enough to access the entire memory from port A, i.e. &gt;= $clog2(MEMORY_SIZE/WRITE_DATA_WIDTH_A).    |
// +---------------------------------------------------------------------------------------------------------------------+
// | ADDR_WIDTH_B         | Integer            | Range: 1 - 20. Default value = 6.                                       |
// |---------------------------------------------------------------------------------------------------------------------|
// | Specify the width of the port B address port addrb, in bits.                                                        |
// | Must be large enough to access the entire memory from port B, i.e. &gt;= $clog2(MEMORY_SIZE/READ_DATA_WIDTH_B).     |
// +---------------------------------------------------------------------------------------------------------------------+
// | AUTO_SLEEP_TIME      | Integer            | Range: 0 - 15. Default value = 0.                                       |
// |---------------------------------------------------------------------------------------------------------------------|
// | Number of clk[a|b] cycles to auto-sleep, if feature is available in architecture.                                   |
// |                                                                                                                     |
// |   0 - Disable auto-sleep feature                                                                                    |
// |   3-15 - Number of auto-sleep latency cycles                                                                        |
// |                                                                                                                     |
// | Do not change from the value provided in the template instantiation.                                                |
// +---------------------------------------------------------------------------------------------------------------------+
// | BYTE_WRITE_WIDTH_A   | Integer            | Range: 1 - 4608. Default value = 32.                                    |
// |---------------------------------------------------------------------------------------------------------------------|
// | To enable byte-wide writes on port A, specify the byte width, in bits.                                              |
// |                                                                                                                     |
// |   8- 8-bit byte-wide writes, legal when WRITE_DATA_WIDTH_A is an integer multiple of 8                              |
// |   9- 9-bit byte-wide writes, legal when WRITE_DATA_WIDTH_A is an integer multiple of 9                              |
// |                                                                                                                     |
// | Or to enable word-wide writes on port A, specify the same value as for WRITE_DATA_WIDTH_A.                          |
// +---------------------------------------------------------------------------------------------------------------------+
// | CASCADE_HEIGHT       | Integer            | Range: 0 - 64. Default value = 0.                                       |
// |---------------------------------------------------------------------------------------------------------------------|
// | 0- No Cascade Height, Allow Vivado Synthesis to choose.                                                             |
// | 1 or more - Vivado Synthesis sets the specified value as Cascade Height.                                            |
// +---------------------------------------------------------------------------------------------------------------------+
// | CLOCKING_MODE        | String             | Allowed values: common_clock, independent_clock. Default value = common_clock.|
// |---------------------------------------------------------------------------------------------------------------------|
// | Designate whether port A and port B are clocked with a common clock or with independent clocks.                     |
// |                                                                                                                     |
// |   "common_clock"- Common clocking; clock both port A and port B with clka                                           |
// |   "independent_clock"- Independent clocking; clock port A with clka and port B with clkb                            |
// +---------------------------------------------------------------------------------------------------------------------+
// | ECC_BIT_RANGE        | String             | Default value = 7:0.                                                    |
// |---------------------------------------------------------------------------------------------------------------------|
// | This parameter is only used by synthesis. Specify the ECC bit range on the provided data.                           |
// | "7:0" - it specifies lower 8 bits are ECC bits.                                                                     |
// +---------------------------------------------------------------------------------------------------------------------+
// | ECC_MODE             | String             | Allowed values: no_ecc, both_encode_and_decode, decode_only, encode_only. Default value = no_ecc.|
// |---------------------------------------------------------------------------------------------------------------------|
// |                                                                                                                     |
// |   "no_ecc" - Disables ECC                                                                                           |
// |   "encode_only" - Enables ECC Encoder only                                                                          |
// |   "decode_only" - Enables ECC Decoder only                                                                          |
// |   "both_encode_and_decode" - Enables both ECC Encoder and Decoder                                                   |
// +---------------------------------------------------------------------------------------------------------------------+
// | ECC_TYPE             | String             | Allowed values: none, ECCHSIAO32-7, ECCHSIAO64-8, ECCHSIAO128-9, ECCH32-7, ECCH64-8. Default value = none.|
// |---------------------------------------------------------------------------------------------------------------------|
// | This parameter is only used by synthesis. Specify the algorithm used to generate the ecc bits outside the XPM Memory.|
// | XPM Memory does not performs ECC operation with this parameter.                                                     |
// |                                                                                                                     |
// |   "none" - No ECC                                                                                                   |
// |   "ECCH32-7" - 32 bit ECC Hamming algorithm is used                                                                 |
// |   "ECCH64-8" - 64 bit ECC Hamming algorithm is used                                                                 |
// |   "ECCHSIAO32-7" - 32 bit ECC HSIAO algorithm is used                                                               |
// |   "ECCHSIAO64-8" - 64 bit ECC HSIAO algorithm is used                                                               |
// |   "ECCHSIAO128-9" - 128 bit ECC HSIAO algorithm is used                                                             |
// +---------------------------------------------------------------------------------------------------------------------+
// | IGNORE_INIT_SYNTH    | Integer            | Range: 0 - 1. Default value = 0.                                        |
// |---------------------------------------------------------------------------------------------------------------------|
// | 0 - Initiazation file if specified will applies for both simulation and synthesis                                   |
// | 1 - Initiazation file if specified will applies for only simulation and will ignore for synthesis                   |
// +---------------------------------------------------------------------------------------------------------------------+
// | MEMORY_INIT_FILE     | String             | Default value = none.                                                   |
// |---------------------------------------------------------------------------------------------------------------------|
// | Specify "none" (including quotes) for no memory initialization, or specify the name of a memory initialization file.|
// | Enter only the name of the file with .mem extension, including quotes but without path (e.g. "my_file.mem").        |
// | File format must be ASCII and consist of only hexadecimal values organized into the specified depth by              |
// | narrowest data width generic value of the memory. Initialization of memory happens through the file name specified only|
// | when parameter MEMORY_INIT_PARAM value is equal to "".                                                              |
// | When using XPM_MEMORY in a project, add the specified file to the Vivado project as a design source.                |
// +---------------------------------------------------------------------------------------------------------------------+
// | MEMORY_INIT_PARAM    | String             | Default value = 0.                                                      |
// |---------------------------------------------------------------------------------------------------------------------|
// | Specify "" or "0" (including quotes) for no memory initialization through parameter, or specify the string          |
// | containing the hex characters. Enter only hex characters with each location separated by delimiter (,).             |
// | Parameter format must be ASCII and consist of only hexadecimal values organized into the specified depth by         |
// | narrowest data width generic value of the memory.For example, if the narrowest data width is 8, and the depth of    |
// | memory is 8 locations, then the parameter value should be passed as shown below.                                    |
// | parameter MEMORY_INIT_PARAM = "AB,CD,EF,1,2,34,56,78"                                                               |
// | Where "AB" is the 0th location and "78" is the 7th location.                                                        |
// +---------------------------------------------------------------------------------------------------------------------+
// | MEMORY_OPTIMIZATION  | String             | Allowed values: true, false. Default value = true.                      |
// |---------------------------------------------------------------------------------------------------------------------|
// | Specify "true" to enable the optimization of unused memory or bits in the memory structure. Specify "false" to      |
// | disable the optimization of unused memory or bits in the memory structure.                                          |
// +---------------------------------------------------------------------------------------------------------------------+
// | MEMORY_PRIMITIVE     | String             | Allowed values: auto, block, distributed, mixed, ultra. Default value = auto.|
// |---------------------------------------------------------------------------------------------------------------------|
// | Designate the memory primitive (resource type) to use.                                                              |
// |                                                                                                                     |
// |   "auto"- Allow Vivado Synthesis to choose                                                                          |
// |   "distributed"- Distributed memory                                                                                 |
// |   "block"- Block memory                                                                                             |
// |   "ultra"- Ultra RAM memory                                                                                         |
// |   "mixed"- Mixed memory                                                                                             |
// |                                                                                                                     |
// | NOTE: There may be a behavior mismatch if Block RAM or Ultra RAM specific features, like ECC or Asymmetry, are selected with MEMORY_PRIMITIVE set to "auto".|
// +---------------------------------------------------------------------------------------------------------------------+
// | MEMORY_SIZE          | Integer            | Range: 2 - 150994944. Default value = 2048.                             |
// |---------------------------------------------------------------------------------------------------------------------|
// | Specify the total memory array size, in bits. For example, enter 65536 for a 2kx32 RAM.                             |
// |                                                                                                                     |
// |   When ECC is enabled and set to "encode_only", then the memory size has to be multiples of READ_DATA_WIDTH_B       |
// |   When ECC is enabled and set to "decode_only", then the memory size has to be multiples of WRITE_DATA_WIDTH_A      |
// +---------------------------------------------------------------------------------------------------------------------+
// | MESSAGE_CONTROL      | Integer            | Range: 0 - 1. Default value = 0.                                        |
// |---------------------------------------------------------------------------------------------------------------------|
// | Specify 1 to enable the dynamic message reporting such as collision warnings, and 0 to disable the message reporting|
// +---------------------------------------------------------------------------------------------------------------------+
// | RAM_DECOMP           | String             | Allowed values: auto, area, power. Default value = auto.                |
// |---------------------------------------------------------------------------------------------------------------------|
// |  Specifies the decomposition of the memory.                                                                         |
// |  "auto" - Synthesis selects default.                                                                                |
// |  "power" - Synthesis selects a strategy to reduce switching activity of RAMs and maps using widest configuration possible.|
// |  "area" - Synthesis selects a strategy to reduce RAM resource count.                                                |
// +---------------------------------------------------------------------------------------------------------------------+
// | READ_DATA_WIDTH_B    | Integer            | Range: 1 - 4608. Default value = 32.                                    |
// |---------------------------------------------------------------------------------------------------------------------|
// | Specify the width of the port B read data output port doutb, in bits.                                               |
// |                                                                                                                     |
// |   When ECC is enabled and set to "encode_only", then READ_DATA_WIDTH_B has to be multiples of 72-bits               |
// |   When ECC is enabled and set to "decode_only" or "both_encode_and_decode", then READ_DATA_WIDTH_B has to be        |
// | multiples of 64-bits                                                                                                |
// +---------------------------------------------------------------------------------------------------------------------+
// | READ_LATENCY_B       | Integer            | Range: 0 - 100. Default value = 2.                                      |
// |---------------------------------------------------------------------------------------------------------------------|
// | Specify the number of register stages in the port B read data pipeline. Read data output to port doutb takes this   |
// | number of clkb cycles (clka when CLOCKING_MODE is "common_clock").                                                  |
// | To target block memory, a value of 1 or larger is required- 1 causes use of memory latch only; 2 causes use of      |
// | output register. To target distributed memory, a value of 0 or larger is required- 0 indicates combinatorial output.|
// | Values larger than 2 synthesize additional flip-flops that are not retimed into memory primitives.                  |
// +---------------------------------------------------------------------------------------------------------------------+
// | READ_RESET_VALUE_B   | String             | Default value = 0.                                                      |
// |---------------------------------------------------------------------------------------------------------------------|
// | Specify the reset value of the port B final output register stage in response to rstb input port is assertion.      |
// | As this parameter is a string, please specify the hex values inside double quotes. As an example,                   |
// | If the read data width is 8, then specify READ_RESET_VALUE_B = "EA";                                                |
// | When ECC is enabled, reset value is not supported.                                                                  |
// +---------------------------------------------------------------------------------------------------------------------+
// | RST_MODE_A           | String             | Allowed values: SYNC, ASYNC. Default value = SYNC.                      |
// |---------------------------------------------------------------------------------------------------------------------|
// | Describes the behaviour of the reset                                                                                |
// |                                                                                                                     |
// |   "SYNC" - when reset is applied, synchronously resets output port douta to the value specified by parameter READ_RESET_VALUE_A|
// |   "ASYNC" - when reset is applied, asynchronously resets output port douta to zero                                  |
// +---------------------------------------------------------------------------------------------------------------------+
// | RST_MODE_B           | String             | Allowed values: SYNC, ASYNC. Default value = SYNC.                      |
// |---------------------------------------------------------------------------------------------------------------------|
// | Describes the behaviour of the reset                                                                                |
// |                                                                                                                     |
// |   "SYNC" - when reset is applied, synchronously resets output port doutb to the value specified by parameter READ_RESET_VALUE_B|
// |   "ASYNC" - when reset is applied, asynchronously resets output port doutb to zero                                  |
// +---------------------------------------------------------------------------------------------------------------------+
// | SIM_ASSERT_CHK       | Integer            | Range: 0 - 1. Default value = 0.                                        |
// |---------------------------------------------------------------------------------------------------------------------|
// | 0- Disable simulation message reporting. Messages related to potential misuse will not be reported.                 |
// | 1- Enable simulation message reporting. Messages related to potential misuse will be reported.                      |
// +---------------------------------------------------------------------------------------------------------------------+
// | USE_EMBEDDED_CONSTRAINT| Integer            | Range: 0 - 1. Default value = 0.                                        |
// |---------------------------------------------------------------------------------------------------------------------|
// | Specify 1 to enable the set_false_path constraint addition between clka of Distributed RAM and doutb_reg on clkb    |
// +---------------------------------------------------------------------------------------------------------------------+
// | USE_MEM_INIT         | Integer            | Range: 0 - 1. Default value = 1.                                        |
// |---------------------------------------------------------------------------------------------------------------------|
// | Specify 1 to enable the generation of below message and 0 to disable generation of the following message completely.|
// | "INFO - MEMORY_INIT_FILE and MEMORY_INIT_PARAM together specifies no memory initialization.                         |
// | Initial memory contents will be all 0s."                                                                            |
// | NOTE: This message gets generated only when there is no Memory Initialization specified either through file or      |
// | Parameter.                                                                                                          |
// +---------------------------------------------------------------------------------------------------------------------+
// | USE_MEM_INIT_MMI     | Integer            | Range: 0 - 1. Default value = 0.                                        |
// |---------------------------------------------------------------------------------------------------------------------|
// | Specify 1 to expose this memory information to be written out in the MMI file.                                      |
// +---------------------------------------------------------------------------------------------------------------------+
// | WAKEUP_TIME          | String             | Allowed values: disable_sleep, use_sleep_pin. Default value = disable_sleep.|
// |---------------------------------------------------------------------------------------------------------------------|
// | Specify "disable_sleep" to disable dynamic power saving option, and specify "use_sleep_pin" to enable the           |
// | dynamic power saving option                                                                                         |
// +---------------------------------------------------------------------------------------------------------------------+
// | WRITE_DATA_WIDTH_A   | Integer            | Range: 1 - 4608. Default value = 32.                                    |
// |---------------------------------------------------------------------------------------------------------------------|
// | Specify the width of the port A write data input port dina, in bits.                                                |
// | The values of WRITE_DATA_WIDTH_A and READ_DATA_WIDTH_A must be equal.                                               |
// | When ECC is enabled and set to "encode_only" or "both_encode_and_decode", then WRITE_DATA_WIDTH_A must be           |
// | multiples of 64-bits.                                                                                               |
// | When ECC is enabled and set to "decode_only", then WRITE_DATA_WIDTH_A must be multiples of 72-bits.                 |
// +---------------------------------------------------------------------------------------------------------------------+
// | WRITE_MODE_B         | String             | Allowed values: no_change, read_first, write_first. Default value = no_change.|
// |---------------------------------------------------------------------------------------------------------------------|
// | Write mode behavior for port B output data port, doutb.                                                             |
// +---------------------------------------------------------------------------------------------------------------------+
// | WRITE_PROTECT        | Integer            | Range: 0 - 1. Default value = 1.                                        |
// |---------------------------------------------------------------------------------------------------------------------|
// | Default value is 1, means write is protected through enable and write enable and hence the LUT is placed before the memory. This is the default behaviour to access memory.|
// | When 0, disables write protection. Write enable (WE) directly connected to memory.                                  |
// | NOTE: Disable this option only if the advanced users can guarantee that the write enable (WE) cannot be given without enable (EN).|
// +---------------------------------------------------------------------------------------------------------------------+

// Port usage table, organized as follows:
// +---------------------------------------------------------------------------------------------------------------------+
// | Port name      | Direction | Size, in bits                         | Domain  | Sense       | Handling if unused     |
// |---------------------------------------------------------------------------------------------------------------------|
// | Description                                                                                                         |
// +---------------------------------------------------------------------------------------------------------------------+
// +---------------------------------------------------------------------------------------------------------------------+
// | addra          | Input     | ADDR_WIDTH_A                          | clka    | NA          | Required               |
// |---------------------------------------------------------------------------------------------------------------------|
// | Address for port A write operations.                                                                                |
// +---------------------------------------------------------------------------------------------------------------------+
// | addrb          | Input     | ADDR_WIDTH_B                          | clkb    | NA          | Required               |
// |---------------------------------------------------------------------------------------------------------------------|
// | Address for port B read operations.                                                                                 |
// +---------------------------------------------------------------------------------------------------------------------+
// | clka           | Input     | 1                                     | NA      | Rising edge | Required               |
// |---------------------------------------------------------------------------------------------------------------------|
// | Clock signal for port A. Also clocks port B when parameter CLOCKING_MODE is "common_clock".                         |
// +---------------------------------------------------------------------------------------------------------------------+
// | clkb           | Input     | 1                                     | NA      | Rising edge | Required               |
// |---------------------------------------------------------------------------------------------------------------------|
// | Clock signal for port B when parameter CLOCKING_MODE is "independent_clock".                                        |
// | Unused when parameter CLOCKING_MODE is "common_clock".                                                              |
// +---------------------------------------------------------------------------------------------------------------------+
// | dbiterrb       | Output    | 1                                     | clkb    | Active-high | DoNotCare              |
// |---------------------------------------------------------------------------------------------------------------------|
// | Status signal to indicate double bit error occurrence on the data output of port B.                                 |
// +---------------------------------------------------------------------------------------------------------------------+
// | dina           | Input     | WRITE_DATA_WIDTH_A                    | clka    | NA          | Required               |
// |---------------------------------------------------------------------------------------------------------------------|
// | Data input for port A write operations.                                                                             |
// +---------------------------------------------------------------------------------------------------------------------+
// | doutb          | Output    | READ_DATA_WIDTH_B                     | clkb    | NA          | Required               |
// |---------------------------------------------------------------------------------------------------------------------|
// | Data output for port B read operations.                                                                             |
// +---------------------------------------------------------------------------------------------------------------------+
// | ena            | Input     | 1                                     | clka    | Active-high | Required               |
// |---------------------------------------------------------------------------------------------------------------------|
// | Memory enable signal for port A.                                                                                    |
// | Must be high on clock cycles when write operations are initiated. Pipelined internally.                             |
// +---------------------------------------------------------------------------------------------------------------------+
// | enb            | Input     | 1                                     | clkb    | Active-high | Required               |
// |---------------------------------------------------------------------------------------------------------------------|
// | Memory enable signal for port B.                                                                                    |
// | Must be high on clock cycles when read operations are initiated. Pipelined internally.                              |
// +---------------------------------------------------------------------------------------------------------------------+
// | injectdbiterra | Input     | 1                                     | clka    | Active-high | Tie to 1'b0            |
// |---------------------------------------------------------------------------------------------------------------------|
// | Controls double bit error injection on input data when ECC enabled (Error injection capability is not available in  |
// | "decode_only" mode).                                                                                                |
// +---------------------------------------------------------------------------------------------------------------------+
// | injectsbiterra | Input     | 1                                     | clka    | Active-high | Tie to 1'b0            |
// |---------------------------------------------------------------------------------------------------------------------|
// | Controls single bit error injection on input data when ECC enabled (Error injection capability is not available in  |
// | "decode_only" mode).                                                                                                |
// +---------------------------------------------------------------------------------------------------------------------+
// | regceb         | Input     | 1                                     | clkb    | Active-high | Tie to 1'b1            |
// |---------------------------------------------------------------------------------------------------------------------|
// | Clock Enable for the last register stage on the output data path.                                                   |
// +---------------------------------------------------------------------------------------------------------------------+
// | rstb           | Input     | 1                                     | clkb    | Active-high | Required               |
// |---------------------------------------------------------------------------------------------------------------------|
// | Reset signal for the final port B output register stage.                                                            |
// | Synchronously resets output port doutb to the value specified by parameter READ_RESET_VALUE_B.                      |
// +---------------------------------------------------------------------------------------------------------------------+
// | sbiterrb       | Output    | 1                                     | clkb    | Active-high | DoNotCare              |
// |---------------------------------------------------------------------------------------------------------------------|
// | Status signal to indicate single bit error occurrence on the data output of port B.                                 |
// +---------------------------------------------------------------------------------------------------------------------+
// | sleep          | Input     | 1                                     | NA      | Active-high | Tie to 1'b0            |
// |---------------------------------------------------------------------------------------------------------------------|
// | sleep signal to enable the dynamic power saving feature.                                                            |
// +---------------------------------------------------------------------------------------------------------------------+
// | wea            | Input     | WRITE_DATA_WIDTH_A/BYTE_WRITE_WIDTH_A | clka    | Active-high | Required               |
// |---------------------------------------------------------------------------------------------------------------------|
// | Write enable vector for port A input data port dina. 1 bit wide when word-wide writes are used.                     |
// | In byte-wide write configurations, each bit controls the writing one byte of dina to address addra.                 |
// | For example, to synchronously write only bits [15-8] of dina when WRITE_DATA_WIDTH_A is 32, wea would be 4'b0010.   |
// +---------------------------------------------------------------------------------------------------------------------+


// xpm_memory_sdpram : In order to incorporate this function into the design,
//      Verilog      : the following instance declaration needs to be placed
//     instance      : in the body of the design code.  The instance name
//    declaration    : (xpm_memory_sdpram_inst) and/or the port declarations within the
//       code        : parenthesis may be changed to properly reference and
//                   : connect this function to the design.  All inputs
//                   : and outputs must be connected.

//  Please reference the appropriate libraries guide for additional information on the XPM modules.

//  <-----Cut code below this line---->

// xpm_memory_sdpram: Simple Dual Port RAM
// Xilinx Parameterized Macro, version 2023.2
module sdpram_block
  import config_pkg::*;
#(
    parameter integer FifoSizeBits = FifoQueueSize * 8,
    parameter integer AddrSize = FifoPtrSize
) (
    input logic clk,
    input logic reset,
    input [AddrSize-1:0] address_write,
    input [AddrSize-1:0] address_read,
    input logic write_enable,
    input logic [7:0] data_in,
    output logic [7:0] data_out
);
  logic dbiterra;
  logic sbiterrb;
  logic injectdbiterra;
  logic injectsbiterra;
  logic regceb;
  assign regceb = 1;
  assign injectdbiterra = 0;
  assign injectsbiterra = 0;
  logic sleep;
  assign sleep = 0;
  logic wea;
  xpm_memory_sdpram #(
      .ADDR_WIDTH_A(AddrSize),  // DECIMAL
      .ADDR_WIDTH_B(AddrSize),  // DECIMAL
      .AUTO_SLEEP_TIME(0),  // DECIMAL
      .BYTE_WRITE_WIDTH_A(FifoDataWidth),  // DECIMAL
      .CASCADE_HEIGHT(0),  // DECIMAL
      .CLOCKING_MODE("common_clock"),  // String
      .ECC_BIT_RANGE("7:0"),  // String
      .ECC_MODE("no_ecc"),  // String
      .ECC_TYPE("none"),  // String
      .IGNORE_INIT_SYNTH(0),  // DECIMAL
      .MEMORY_INIT_FILE("none"),  // String
      .MEMORY_INIT_PARAM("0"),  // String
      .MEMORY_OPTIMIZATION("false"),  // String
      .MEMORY_PRIMITIVE("block"),  // String
      .MEMORY_SIZE(FifoSizeBits),  // DECIMAL
      .MESSAGE_CONTROL(0),  // DECIMAL
      .RAM_DECOMP("auto"),  // String
      .READ_DATA_WIDTH_B(FifoDataWidth),  // DECIMAL
      .READ_LATENCY_B(1),  // DECIMAL
      .READ_RESET_VALUE_B("0"),  // String
      .RST_MODE_A("SYNC"),  // String
      .RST_MODE_B("SYNC"),  // String
      .SIM_ASSERT_CHK(0),  // DECIMAL; 0=disable simulation messages, 1=enable simulation messages
      .USE_EMBEDDED_CONSTRAINT(0),  // DECIMAL
      .USE_MEM_INIT(1),  // DECIMAL
      .USE_MEM_INIT_MMI(0),  // DECIMAL
      .WAKEUP_TIME("disable_sleep"),  // String
      .WRITE_DATA_WIDTH_A(FifoDataWidth),  // DECIMAL
      .WRITE_MODE_B("no_change"),  // String
      .WRITE_PROTECT(1)  // DECIMAL
  ) xpm_memory_sdpram_inst (
      .dbiterrb(dbiterrb),  // 1-bit output: Status signal to indicate double bit error occurrence
                            // on the data output of port B.

      .doutb   (data_out),  // READ_DATA_WIDTH_B-bit output: Data output for port B read operations.
      .sbiterrb(sbiterrb),  // 1-bit output: Status signal to indicate single bit error occurrence
                            // on the data output of port B.

      .addra(address_write),  // ADDR_WIDTH_A-bit input: Address for port A write operations.
      .addrb(address_read),   // ADDR_WIDTH_B-bit input: Address for port B read operations.
      .clka (clk),            // 1-bit input: Clock signal for port A. Also clocks port B when
                              // parameter CLOCKING_MODE is "common_clock".

      .clkb(clk),  // 1-bit input: Clock signal for port B when parameter CLOCKING_MODE is
                   // "independent_clock". Unused when parameter CLOCKING_MODE is
                   // "common_clock".

      .dina(data_in),      // WRITE_DATA_WIDTH_A-bit input: Data input for port A write operations.
      .ena (write_enable), // 1-bit input: Memory enable signal for port A. Must be high on clock
      // cycles when write operations are initiated. Pipelined internally.

      .enb(1),  // 1-bit input: Memory enable signal for port B. Must be high on clock
      // cycles when read operations are initiated. Pipelined internally.

      .injectdbiterra(injectdbiterra), // 1-bit input: Controls double bit error injection on input data when
                                       // ECC enabled (Error injection capability is not available in
                                       // "decode_only" mode).

      .injectsbiterra(injectsbiterra), // 1-bit input: Controls single bit error injection on input data when
                                       // ECC enabled (Error injection capability is not available in
                                       // "decode_only" mode).

      .regceb(regceb),  // 1-bit input: Clock Enable for the last register stage on the output
                        // data path.

      .rstb(reset),  // 1-bit input: Reset signal for the final port B output register stage.
                     // Synchronously resets output port doutb to the value specified by
                     // parameter READ_RESET_VALUE_B.
      //.rsta(reset),

      .sleep(sleep),  // 1-bit input: sleep signal to enable the dynamic power saving feature.
      .wea  (write_enable)     // WRITE_DATA_WIDTH_A/BYTE_WRITE_WIDTH_A-bit input: Write enable vector
      // for port A input data port dina. 1 bit wide when word-wide writes are
      // used. In byte-wide write configurations, each bit controls the
      // writing one byte of dina to address addra. For example, to
      // synchronously write only bits [15-8] of dina when WRITE_DATA_WIDTH_A
      // is 32, wea would be 4'b0010.

  );
endmodule

