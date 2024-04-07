// fpga_arty
`timescale 1ns / 1ps

import arty_pkg::*;

module fpga_arty (
    input sysclk,

    // bcsan related
    // input  S_BSCAN_bscanid_en,
    // input  S_BSCAN_capture,
    // input  S_BSCAN_drck,
    // input  S_BSCAN_reset,
    // input  S_BSCAN_runtest,
    // input  S_BSCAN_sel,
    // input  S_BSCAN_shift,
    // input  S_BSCAN_tck,
    // input  S_BSCAN_tdi,
    // input  S_BSCAN_tms,
    // input  S_BSCAN_update,
    // output S_BSCAN_tdo,

    // input JTAG_TDO_GLBL,
    // input JTAG_TCK_GLBL,
    // input JTAG_TDI_GLBL,
    // input JTAG_TMS_GLBL,
    // input JTAG_TRST_GLBL,
    // input JTAG_CAPTURE_GLBL,
    // input JTAG_RESET_GLBL,
    // input JTAG_SHIFT_GLBL,
    // input JTAG_UPDATE_GLBL,
    // input JTAG_RUNTEST_GLBL,
    // input JTAG_SEL1_GLBL,
    // input JTAG_SEL2_GLBL,
    // input JTAG_SEL3_GLBL,
    // input JTAG_SEL4_GLBL,
    // input JTAG_USER_TDO1_GLBL,
    // input JTAG_USER_TDO2_GLBL,
    // input JTAG_USER_TDO3_GLBL,
    // input JTAG_USER_TDO4_GLBL,

    // input  JTAG_TDO,
    // output JTAG_TDI,
    // output JTAG_TMS,
    // output JTAG_TCK,

    output LedT led,
    output LedT led_r,
    output LedT led_g,
    output LedT led_b,
    input  SwT  sw,

    output logic rx,  // seen from host side 
    input  logic tx,

    input BtnT btn
);

  logic clk;

  logic [31:0] r_count;
  logic locked;

  always_comb begin
    for (integer k = 0; k < LedWidth; k++) begin
      // if (k != 0 || k != 1) led_r[k] = 0;  // used for clock
      // if (k != 0) led_r[k] = 0;  // used for clock
      led_g[k] = 0;
      led_b[k] = 0;
    end
  end

  top_arty hippo (
      .clk,
      .reset(sw[1]),
      .btn,
      .led
  );

  // logic JTAG_TDO;
  // logic JTAG_TDI;
  // logic JTAG_TMS;
  // logic JTAG_TCK;

  // assign S_BSCAN_tdo = 0;
  // assign led_r[1] = JTAG_CAPTURE_GLBL;
  // assign led_r[2] = JTAG_TCK_GLBL;
  // assign led_r[3] = JTAG_TDI_GLBL;
  // assign JTAG_TDI = 0;
  // assign JTAG_TMS = 0;
  // assign JTAG_TCK = 0;


  //   BSCANE2   : In order to incorporate this function into the design,
  //   Verilog   : the following instance declaration needs to be placed
  //  instance   : in the body of the design code.  The instance name
  // declaration : (BSCANE2_inst) and/or the port declarations within the
  //    code     : parenthesis may be changed to properly reference and
  //             : connect this function to the design.  All inputs
  //             : and outputs must be connected.

  //  <-----Cut code below this line---->

  // BSCANE2: Boundary-Scan User Instruction
  //          Artix-7
  // Xilinx HDL Language Template, version 2023.2

  logic CAPTURE;
  logic DRCK;
  logic RESET;
  logic RUNTEST;
  logic SEL;
  logic SHIFT;
  logic TCK;
  logic TDI;
  logic TMS;
  logic UPDATE;
  logic TDO;

  assign TDO = 0;

  assign led_r[1] = TCK;
  assign led_r[2] = TDI;
  assign led_r[3] = TMS;

  BSCANE2 #(
      .JTAG_CHAIN(1)  // Value for USER command.
  ) BSCANE2_inst (
      .CAPTURE(CAPTURE),  // 1-bit output: CAPTURE output from TAP controller.
      .DRCK(DRCK),       // 1-bit output: Gated TCK output. When SEL is asserted, DRCK toggles when CAPTURE or
                         // SHIFT are asserted.

      .RESET(RESET),  // 1-bit output: Reset output for TAP controller.
      .RUNTEST(RUNTEST), // 1-bit output: Output asserted when TAP controller is in Run Test/Idle state.
      .SEL(SEL),  // 1-bit output: USER instruction active output.
      .SHIFT(SHIFT),  // 1-bit output: SHIFT output from TAP controller.
      .TCK(TCK),  // 1-bit output: Test Clock output. Fabric connection to TAP Clock pin.
      .TDI(TDI),  // 1-bit output: Test Data Input (TDI) output from TAP controller.
      .TMS(TMS),  // 1-bit output: Test Mode Select output. Fabric connection to TAP.
      .UPDATE(UPDATE),  // 1-bit output: UPDATE output from TAP controller
      .TDO(TDO)  // 1-bit input: Test Data Output (TDO) input for USER function.
  );

  //bscan_jtag_0 bscan (
  //      .S_BSCAN_bscanid_en(1),  // always enable
  //      .S_BSCAN_capture(JTAG_CAPTURE_GLBL),
  //      .S_BSCAN_drck(JTAG_TCK_GLBL),
  //      .S_BSCAN_reset(),
  //      .S_BSCAN_runtest(),
  //      .S_BSCAN_sel(),
  //      .S_BSCAN_shift(JTAG_SHIFT_GLBL),
  //      .S_BSCAN_tck(),
  //      .S_BSCAN_tdi(JTAG_TDI_GLBL),
  //      .S_BSCAN_tms(),  // not connected
  //      .S_BSCAN_update(),  // not connected
  //      .S_BSCAN_tdo(), // JTAG_TDO_GLBL
  //      .JTAG_TDO,
  //      .JTAG_TDI,
  //      .JTAG_TMS,
  //      .JTAG_TCK 
  //  );

  clk_wiz_0 clk_gen (
      // Clock in ports
      .clk_in1(sysclk),
      // Clock out ports
      .clk_out1(clk),
      // Status and control signals
      .reset(sw[0]),
      .locked
  );

  // clock devider
  always @(posedge clk) begin
    r_count  <= r_count + 1;
    led_r[0] <= r_count[22];
  end

endmodule
