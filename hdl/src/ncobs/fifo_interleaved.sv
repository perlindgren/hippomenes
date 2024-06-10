// fifo_interleaved
`timescale 1ns / 1ps

import decoder_pkg::*;
import config_pkg::*;
module fifo_interleaved (
    input logic clk_i,
    input logic reset_i,

    // write interface
    input logic write_enable,
    input logic [FifoEntryWidthBits-1:0] write_data,
    input logic [FifoEntryWidthSize:0] write_width,

    // read interface
    input logic ack,
    output logic [7:0] data,
    output logic have_next

);
  logic spram_we;
  logic [FifoEntryWidthBits-1:0] spram_din;
  logic [7:0] buffer[2];
  FifoPtrT mem_in_ptr;
  FifoPtrT mem_out_ptr;
  logic [1:0] buffer_in_ptr;
  logic [7:0] spram_dout;
  logic spram_read_addr;
  logic spram_write_addr;
  logic memory_written;
  logic [2:0] read_from_memory;
  logic [FifoEntryWidthSize:0] stored_width;
  logic [FifoEntryWidthSize:0] write_width_memory;
  interleaved_memory queue_memory (
      .clk(clk_i),
      .reset(reset_i),
      .read_addr(mem_out_ptr),
      .write_addr(mem_in_ptr),
      .write_enable(spram_we),
      .write_width(write_width_memory),
      .data_in(spram_din),
      .data_out(spram_dout)
  );
  always_comb begin
    data = buffer[0];
    spram_read_addr = mem_out_ptr;
    spram_write_addr = mem_in_ptr;
    //write_width_memory = write_width - (2 - buffer_in_ptr);

  end

  always_ff @(posedge clk_i) begin
    if (reset_i) begin
      spram_we <= 0;
      mem_in_ptr <= 0;
      mem_out_ptr <= 0;
      buffer_in_ptr <= 0;
      buffer <= '{default: 0};
      memory_written <= 0;
      read_from_memory <= 0;
      write_width_memory <= 0;
      spram_din <= 0;
      have_next <= 0;
      //write_data <= 0;
      //spram_din <= 0;
    end else begin
      spram_we <= 0;
      // delay incrementing the in pointer until the write is finished
      if (memory_written) begin
        memory_written <= 0;
        mem_in_ptr <= mem_in_ptr + write_width_memory;
      end
      // delay pop from memory until we are sure that any readwrites are finished
      if (read_from_memory > 1) begin
        read_from_memory <= read_from_memory - 1;
      end else if (read_from_memory == 1) begin
        mem_out_ptr <= mem_out_ptr + 1;
        buffer[1] <= spram_dout;
        read_from_memory <= 0;
      end
      if (write_enable) begin
        if ((buffer_in_ptr < 2) && (read_from_memory == 0)) begin
          for (integer i = 0; i < 2; i++) begin
            if ((i - buffer_in_ptr < write_width) && (i - buffer_in_ptr >= 0)) begin
              buffer[i] <= write_data >> (((write_width - 1) - (i - buffer_in_ptr)) * 8);
              buffer_in_ptr <= i + 1;
            end
          end
          //buffer[buffer_in_ptr] <= write_data;
          //buffer_in_ptr <= buffer_in_ptr + 1;
          if (buffer_in_ptr + write_width > 2) begin
            spram_we <= 1;
            memory_written <= 1;
            write_width_memory <= write_width - (2 - buffer_in_ptr);
            spram_din <= write_data;
            // stored_width <= write_width - (2 - buffer_in_ptr);
          end
        end else begin
          spram_we <= 1;
          //spram_din <= write_data;
          memory_written <= 1;
          write_width_memory <= write_width - (2 - buffer_in_ptr);
          spram_din <= write_data;
          // stored_width <= write_width - (2 - buffer_in_ptr);
        end
      end
      if (buffer_in_ptr > 0) begin
        have_next <= 1;
      end else begin
        have_next <= 0;
      end
      if (ack) begin
        buffer[0] <= buffer[1];
        if ((mem_in_ptr != mem_out_ptr) || (write_enable && buffer_in_ptr >= 2)) begin
          //buffer_in_ptr <= buffer_in_ptr - 1;
          read_from_memory <= 3;
        end else begin
          buffer_in_ptr <= buffer_in_ptr - 1;
        end
      end

    end
  end

endmodule

