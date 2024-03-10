// time_stamp
`timescale 1ns / 1ps


module time_stamp
  import config_pkg::*;
  import decoder_pkg::*;
(
    input logic clk,
    input logic reset,
    input MonoTimerT mono_timer,

    /* verilator lint_off MULTIDRIVEN */
    input logic pend[VecSize],
    input CsrAddrT csr_addr,
    output word csr_out
);
  logic      old_pend          [VecSize];

  TimeStampT ext_data;
  logic      ext_write_enable  [VecSize];
  logic      ext_stretch_enable[VecSize];
  word       temp_out          [VecSize];

  generate
    for (genvar k = 0; k < VecSize; k++) begin : gen_stamp
      csr #(
          .CsrWidth(TimeStampWidth),
          .Write(0)
      ) csr_stamp (
          .clk,
          .reset,
          .csr_enable(0),
          .csr_addr(0),
          .csr_op(0),
          .rs1_zimm(0),
          .rs1_data(0),
          // external access for side effects
          .ext_data,
          .ext_write_enable(ext_write_enable[k]),
          .out(temp_out[k])
      );

      always_ff @(posedge pend[k]) begin : gen_trig
        ext_write_enable[k]   <= 1;
        ext_stretch_enable[k] <= 1;
      end

      // ensure that we have at least a full period to reliably capture the timer
      always_ff @(posedge clk) begin : gen_un_trig
        if (ext_stretch_enable[k]) ext_stretch_enable[k] <= 0;
        else ext_write_enable[k] <= 0;
      end

    end
  endgenerate

  assign ext_data = TimeStampT'(mono_timer >> TimeStampPreScaler);

  // set csr_out
  always_latch begin
    for (int k = 0; k < VecSize; k++) begin
      if (csr_addr == CsrAddrT'(TimeStampCsrBase + CsrAddrT'(k))) begin
        csr_out = temp_out[k];
        break;
      end
    end
  end

endmodule

// emutated edge trigger
// always_ff @(posedge clk) begin : gen_trig
//   if (~old_pend[k] && pend[k]) begin
//     ext_write_enable[k] <= 1;
//   end else ext_write_enable[k] <= 0;
//   old_pend[k] <= pend[k];
// end
