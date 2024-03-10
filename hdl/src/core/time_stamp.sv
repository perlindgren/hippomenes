// time_stamp
`timescale 1ns / 1ps

// Timestamps valid only after being triggered
module time_stamp
  import config_pkg::*;
(
    input logic clk,
    input logic reset,
    input logic pend[VecSize],
    /* verilator lint_off MULTIDRIVEN */
    output TimeStampT vec_stamp[VecSize]
);
  TimerT timer;

  always_ff @(posedge clk) begin
    if (reset) timer <= 0;
    else timer <= timer + 1;
  end

  generate
    for (genvar k = 0; k < VecSize; k++) begin : gen_stamp
      always_ff @(posedge pend[k]) begin
        vec_stamp[k] <= TimeStampT'(timer >> TimeStampPreScaler);
      end
    end
  endgenerate
endmodule
