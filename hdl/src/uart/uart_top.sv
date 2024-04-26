// uart_top
`timescale 1ns / 1ps


module uart_top (
    input sysclk,
    input logic [1:0] sw,
    output logic rx  // host
);

  logic clk;
  logic tmp_sw1;
  logic locked;
  assign tmp_sw1 = sw[1];
  clk_wiz_0 clk_gen (
      // Clock in ports
      .clk_in1(sysclk),
      // Clock out ports
      .clk_out1(clk),
      // Status and control signals
      .reset(tmp_sw0),
      .locked
  );

  logic [7:0] fifo_data;
  logic uart_next;
  logic fifo_have_next;
  logic fifo_write_enable_in;
  word prescaler;
  word  r_count;
  logic [7:0] fifo_data_in;
  assign prescaler = 0;
  uart uart_i (
      .clk_i    (clk),
      .reset_i  (tmp_sw1),
      .prescaler(prescaler),       // this can be a config register, for now just wire it to a 0
      .d_in     (fifo_data),       // data in from fifo
      .rts      (fifo_have_next),  // queue ready signal
      //input logic cmp,
      .tx       (rx),              // the tx pin of the UART
      .next     (uart_next)        // next word request to the fifo
  );

  fifo fifo_i (
      .clk_i(clk),
      .reset_i(tmp_sw1),
      .next(uart_next),
      .data_i(fifo_data_in),
      .write_enable(fifo_write_enable_in),
      //input logic cmp,
      .data(fifo_data),
      .have_next(fifo_have_next)
  );
  
  always_ff @(posedge clk) begin
    if (r_count[22] == 1) begin
      fifo_data_in <= 'h41;
      fifo_write_enable_in <= 1;
      r_count <= 0;
    end else begin
      fifo_write_enable_in <= 0;
      r_count <= r_count + 1;
    end
  end
  // clock devider
endmodule
