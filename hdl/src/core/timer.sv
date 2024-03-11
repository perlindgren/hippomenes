// timer
`timescale 1ns / 1ps

//  Programmable timer peripheral
module timer
  import config_pkg::*;
  import decoder_pkg::*;

(
    input logic clk,
    input logic reset,

    input logic csr_enable,
    input CsrAddrT csr_addr,
    input csr_op_t csr_op,
    input r rs1_zimm,
    input word rs1_data,

    // external access for side effects
    input  TimerT ext_data,
    input  logic  ext_write_enable,
    output word   direct_out,
    output word   out
);
  TimerWidthT counter;

  TimerT timer;

  csr #(
      .CsrWidth(TimerTWidth)
  ) csr_timer (
      // in
      .clk,
      .reset,

      .csr_enable,
      .csr_addr,
      .csr_op,
      .rs1_zimm,
      .rs1_data,

      // external access for side effects
      .ext_data,
      .ext_write_enable,
      // out
      .direct_out,
      .out
  );

  assign timer = csr_timer.data;

  always_ff @(posedge clk) begin
    if (reset) counter <= 0;
    else if (timer.counter_top == counter) begin
      $display("counter top: counter = %d", counter);
      counter <= 0;
    end else counter <= counter + 1;
  end

endmodule
