// uart
`timescale 1ns / 1ps

module uart (
    input  logic       clk_i,
    input  logic       reset_i,
    input  word        prescaler,  // this can be a config register, for now just wire it to a 0
    input  logic [7:0] d_in,       // data in from fifo
    input  logic       rts,        // queue ready signal
    //input logic cmp,
    output logic       tx,         // the tx pin of the UART
    output logic       next        // next word request to the fifo
);
  import decoder_pkg::*;
  word counter;
  word bit_counter;
  // word prescaler;
  logic [7:0] data;
  word cmp;
  word w;
  logic next_int;
  always_comb begin
    next = next_int && rts;
  end
  always_ff @(posedge clk_i) begin
    if (reset_i) begin
      counter <= 0;
      data <= 0;
      bit_counter <= 0;
      cmp <= UartCmpVal; //potentially this could be configurable, however with a configurable prescaler,
      // this can be set to yield highest standard baudrate at prescaler = 0, with the rest being reachable through prescaler config;
      tx <= 1;
      w <= 0;
      next_int <= 1;
    end else begin
      if (next) begin
        data <= d_in;
        next_int <= 0;
        //tx   <= 1;
      end else if (next_int == 1) begin
        //tx <= 1;
      end else if ((counter == (cmp << prescaler)) && next_int == 0) begin
        if (w > 0) begin  // see if we're stop bit waiting
          w <= w - 1;  // emitting stop bit, wait
        end else if (bit_counter == 0) begin
          tx <= 0;  // start bit
          bit_counter <= bit_counter + 1;  //increase bit counter
        end else if (bit_counter == 9) begin
          tx <= 1;  // stop bit
          bit_counter <= 0;  //reset bit counter
          w <= 10;  // emit stop bit for 10 bit periods
          next_int <= 1;  // notify we want more data
        end else begin
          tx <= data[0] & 1;  // set tx pin to bit
          bit_counter <= bit_counter + 1;  // increase bit count
          data <= data >> 1;  //shift to next bit
        end
        counter <= 1;  // increase cycle counter
      end else if (next_int == 0) begin
        counter <= counter + 1;  // increase cycle counter
      end
    end
  end
endmodule
