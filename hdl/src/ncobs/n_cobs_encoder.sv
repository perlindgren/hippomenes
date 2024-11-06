// n_cobs_encoder
`timescale 1ns / 1ps

module n_cobs_encoder
  import config_pkg::*;
  import decoder_pkg::*;
(
    input logic clk_i,
    input logic reset_i,

    // 1 byte for writing
    // fill rest with timer
    input MonoTimerT timer,

    input logic [7:0] id,
    input logic csr_enable,
    input CsrAddrT csr_addr,

    input word rs1_data,

    input PrioT level,
    
    input logic tail_chain,

    output [FifoEntryWidthBits-1:0] write_data,
    output [FifoEntryWidthSize:0] write_width,
    output write_enable
);
  PrioT                               old_level;
  logic        [FifoEntryWidthSize:0] tmp_write_width;
  // Byte
  FifoDataT                           tmp_data;
  FifoPtrT                            tmp_length;
  FifoPtrT                            eof_length;
  // stack
  FifoPtrT                            length          [PrioNum];
  FifoDataIdxT                        write_index;
  FifoDataIdxT                        write_index_tmp;
  assign write_data   = {<<byte{tmp_data<<((FifoEntryWidth- write_width) * 8)}};
  assign write_width  = write_index;
  assign write_enable = write_index != 0;
  function automatic void enqueue(logic [7:0] val, ref FifoPtrT offset, ref FifoDataT write_data,
                                  ref FifoDataIdxT write_index);
    if (val == 0) begin
      offset = ($signed(offset) > 0) ? offset : offset - 1;
      write_data[write_index] = offset;
      offset = 1;
    end else begin
      write_data[write_index] = val;
      offset = ($signed(offset) > 0) ? offset + 1 : offset - 1;
    end
    write_index = write_index + 1;
  endfunction
  function automatic void n_cobs_eof(ref FifoPtrT offset, ref FifoDataT write_data,
                                     ref FifoDataIdxT write_index);
    write_data[write_index] = offset;
    write_data[write_index+1] = 0;  // sentinel

    write_index = write_index + 2;
  endfunction
  always_ff @(posedge clk_i) begin
    if (reset_i) begin
      old_level <= level;  //PrioT'(PrioNum - 1);
      length <= '{default: 0};  // not strictly needed
    end else begin
      tmp_data = 0;
      tmp_length = length[level];
      write_index = 0;
      if (level > old_level) begin
        // push frame
        tmp_length = 0;
        enqueue(8'((id << 4) | level), tmp_length, tmp_data, write_index);
        for (integer i = 0; i < MonoTimerWidthBytes; i++) begin
          enqueue(8'(timer >> ((MonoTimerWidthBytes - 1 - i) * 8)), tmp_length, tmp_data,
                  write_index);
        end
        write_index = 5;
      end else if (tail_chain) begin
        n_cobs_eof(length[old_level], tmp_data, write_index);
        write_index = 2;
        enqueue(8'((id << 4) | level), tmp_length, tmp_data, write_index);
        for (integer i = 0; i < MonoTimerWidthBytes; i++) begin
          enqueue(8'(timer >> ((MonoTimerWidthBytes - 1 - i) * 8)), tmp_length, tmp_data,
                  write_index);
        end
        write_index = 7;
      end else if (level < old_level) begin
        // pop frame
        tmp_length = length[old_level];
        for (integer i = 0; i < MonoTimerWidthBytes; i++) begin
          enqueue(8'(timer >> ((MonoTimerWidthBytes - 1 - i) * 8)), tmp_length, tmp_data,
                  write_index);
        end
        write_index = 4;
        n_cobs_eof(tmp_length, tmp_data, write_index);
        write_index = 6;
        tmp_length = length[level];
      end
      if (csr_enable == 1 && csr_addr == FifoByteCsrAddr) begin
        // write byte
        enqueue(8'(rs1_data), tmp_length, tmp_data, write_index);
      end
      old_level <= level;


      length[level] <= tmp_length;
    end
  end
endmodule

