// timer
`timescale 1ns / 1ps

//  Programmable timer peripheral
module timer
  import config_pkg::*;
  import decoder_pkg::*;
(
    input logic clk,
    input logic reset,

    input logic    csr_enable,
    input CsrAddrT csr_addr,
    input csr_op_t csr_op,
    input r        rs1_zimm,
    input word     rs1_data,
    input TimerT   ext_data,
    input logic    ext_write_enable,
    input logic    interrupt_clear,

    output logic interrupt_set,
    output word  csr_direct_out,
    output word  csr_out
);
  TimerCounterT counter;
  TimerT timer;

  csr #(
      .CsrWidth(TimerTWidth),
      .Addr(TimerAddr)
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
      .direct_out(csr_direct_out),
      .out(csr_out)
  );

  assign timer = csr_timer.data;

  always_ff @(posedge clk) begin
    if (reset) begin
      counter <= 0;
      interrupt_set <= 0;
    end else begin
      if ((TimerCounterT'(timer.counter_top) << timer.prescaler) == counter) begin
        $display("counter top: counter = %d", counter);
        counter <= 0;
        interrupt_set <= 1;
      end else begin
        if (interrupt_clear) interrupt_set <= 0;
        counter <= counter + 1;
      end
    end
  end

endmodule
