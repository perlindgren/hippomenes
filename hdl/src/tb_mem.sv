// Data memory

module tb_mem;
  import config_pkg::*;
  import mem_pkg::*;

  parameter integer MemSize = 'h0000_1000;
  localparam integer MemAddrWidth = $clog2(MemSize);  // derived

  logic clk;
  logic write_enable;
  mem_width_t width;
  logic sign_extend;
  logic [MemAddrWidth-1:0] address;
  logic [31:0] data_in;
  logic [31:0] data_out;
  logic alignment_error;

  mem dut (
      .clk(clk),
      .write_enable(write_enable),
      .width(width),
      .sign_extend(sign_extend),
      .address(address),
      .data_in(data_in),
      .data_out(data_out),
      .alignment_error(alignment_error)
  );

  initial begin
    $dumpfile("mem.fst");
    $dumpvars;

    address = 0;
    width   = WORD;
    #10 assert ((data_out == 'h1234_5678) && !alignment_error);

    address = 4;
    #10 assert ((data_out == 'h0000_1111) && !alignment_error);

    address = 8;
    #10
    assert ((data_out == 'h1111_0000) && !alignment_error);
    else $error("got %h, alignment_error %d", data_out, alignment_error);

    address = 0;
    width = BYTE;
    sign_extend = 0;
    #10
    assert ((data_out == 'h0000_0078) && !alignment_error);
    else $error("got %h, alignment_error %d", data_out, alignment_error);

    address = 0;
    width = BYTE;
    sign_extend = 1;
    #10
    assert ((data_out == 'h0000_0078) && !alignment_error);
    else $error("got %h, alignment_error %d", data_out, alignment_error);

    address = 1;
    width = BYTE;
    sign_extend = 1;
    #10
    assert ((data_out == 'h0000_0056) && !alignment_error);
    else $error("got %h, alignment_error %d", data_out, alignment_error);

    address = 2;
    width = BYTE;
    sign_extend = 1;
    #10
    assert ((data_out == 'h0000_0034) && !alignment_error);
    else $error("got %h, alignment_error %d", data_out, alignment_error);

    address = 3;
    width = BYTE;
    sign_extend = 1;
    #10
    assert ((data_out == 'h0000_0012) && !alignment_error);
    else $error("got %h, alignment_error %d", data_out, alignment_error);

    address = 12;
    width = BYTE;
    sign_extend = 0;
    #10
    assert ((data_out == 'h0000_0080) && !alignment_error);
    else $error("got %h, alignment_error %d", data_out, alignment_error);

    address = 12;
    width = BYTE;
    sign_extend = 1;
    #10
    assert ((data_out == 'hFFFF_FF80) && !alignment_error);
    else $error("got %h, alignment_error %d", data_out, alignment_error);

    address = 13;
    width = BYTE;
    sign_extend = 1;
    #10
    assert ((data_out == 'hFFFF_FF90) && !alignment_error);
    else $error("got %h, alignment_error %d", data_out, alignment_error);

    address = 14;
    width = BYTE;
    sign_extend = 1;
    #10
    assert ((data_out == 'hFFFF_FFa0) && !alignment_error);
    else $error("got %h, alignment_error %d", data_out, alignment_error);

    address = 15;
    width = BYTE;
    sign_extend = 1;
    #10
    assert ((data_out == 'hFFFF_FFb0) && !alignment_error);
    else $error("got %h, alignment_error %d", data_out, alignment_error);

    address = 0;
    width = HALFWORD;
    sign_extend = 0;
    #10
    assert ((data_out == 'h0000_5678) && !alignment_error);
    else $error("got %h, alignment_error %d", data_out, alignment_error);

    address = 2;
    width = HALFWORD;
    sign_extend = 0;
    #10
    assert ((data_out == 'h0000_1234) && !alignment_error);
    else $error("got %h, alignment_error %d", data_out, alignment_error);

    address = 0;
    width = HALFWORD;
    sign_extend = 1;
    #10
    assert ((data_out == 'h0000_5678) && !alignment_error);
    else $error("got %h, alignment_error %d", data_out, alignment_error);

    address = 2;
    width = HALFWORD;
    sign_extend = 1;
    #10
    assert ((data_out == 'h0000_1234) && !alignment_error);
    else $error("got %h, alignment_error %d", data_out, alignment_error);

    address = 12;
    width = HALFWORD;
    sign_extend = 1;
    #10
    assert ((data_out == 'hFFFF_9080) && !alignment_error);
    else $error("got %h, alignment_error %d", data_out, alignment_error);

    address = 14;
    width = HALFWORD;
    sign_extend = 1;
    #10
    assert ((data_out == 'hFFFF_b0a0) && !alignment_error);
    else $error("got %h, alignment_error %d", data_out, alignment_error);

    address = 13;
    width = HALFWORD;
    sign_extend = 1;
    #10
    assert ((data_out == 'hFFFF_9080) && alignment_error);
    else $error("got %h, alignment_error %d", data_out, alignment_error);

    address = 15;
    width = HALFWORD;
    sign_extend = 1;
    #10
    assert ((data_out == 'hFFFF_b0a0) && alignment_error);
    else $error("got %h, alignment_error %d", data_out, alignment_error);

    address = 12;
    width = WORD;
    sign_extend = 1;
    #10
    assert ((data_out == 'hb0a09080) && !alignment_error);
    else $error("got %h, alignment_error %d", data_out, alignment_error);

    address = 13;
    width = WORD;
    sign_extend = 1;
    #10
    assert ((data_out == 'hb0a09080) && alignment_error);
    else $error("got %h, alignment_error %d", data_out, alignment_error);

    address = 14;
    width = WORD;
    sign_extend = 1;
    #10
    assert ((data_out == 'hb0a09080) && alignment_error);
    else $error("got %h, alignment_error %d", data_out, alignment_error);

    address = 15;
    width = WORD;
    sign_extend = 1;
    #10
    assert ((data_out == 'hb0a09080) && alignment_error);
    else $error("got %h, alignment_error %d", data_out, alignment_error);

    // test write operations
    write_enable = 1;
    address = 0;
    width = BYTE;
    sign_extend = 1;
    data_in = 'h0000_0077;
    clk = 0;
    #10 clk = 1;
    #10;
    assert ((data_out == 'h0000_0077) && !alignment_error);
    else $error("got %h, alignment_error %d", data_out, alignment_error);

    address = 1;
    width = BYTE;
    sign_extend = 1;
    data_in = 'h0000_0066;
    clk = 0;
    #10 clk = 1;
    #10;
    assert ((data_out == 'h0000_0066) && !alignment_error);
    else $error("got %h, alignment_error %d", data_out, alignment_error);

    address = 2;
    width = BYTE;
    sign_extend = 1;
    data_in = 'h0000_0055;
    clk = 0;
    #10 clk = 1;
    #10;
    assert ((data_out == 'h0000_0055) && !alignment_error);
    else $error("got %h, alignment_error %d", data_out, alignment_error);

    address = 3;
    width = BYTE;
    sign_extend = 1;
    data_in = 'h0000_0044;
    clk = 0;
    #10 clk = 1;
    #10;
    assert ((data_out == 'h0000_0044) && !alignment_error);
    else $error("got %h, alignment_error %d", data_out, alignment_error);

    address = 7;
    width = BYTE;
    sign_extend = 1;
    data_in = 'h0000_0022;
    clk = 0;
    #10 clk = 1;
    #10;
    assert ((data_out == 'h0000_0022) && !alignment_error);
    else $error("got %h, alignment_error %d", data_out, alignment_error);

    // check read back word
    address = 0;
    write_enable = 0;
    width = WORD;
    sign_extend = 1;
    #10;
    assert ((data_out == 'h4455_6677) && !alignment_error);
    else $error("got %h, alignment_error %d", data_out, alignment_error);

    address = 4;
    write_enable = 0;
    width = WORD;
    sign_extend = 1;
    #10;
    assert ((data_out == 'h2200_1111) && !alignment_error);
    else $error("got %h, alignment_error %d", data_out, alignment_error);

    // check write half word
    write_enable = 1;
    address = 8;
    width = HALFWORD;
    sign_extend = 1;
    data_in = 'h0000_AA33;
    clk = 0;
    #10 clk = 1;
    #10;
    assert ((data_out == 'hFFFF_AA33) && !alignment_error);
    else $error("got %h, alignment_error %d", data_out, alignment_error);

    address = 10;
    width = HALFWORD;
    sign_extend = 1;
    data_in = 'h0000_BB44;
    clk = 0;
    #10 clk = 1;
    #10;
    assert ((data_out == 'hFFFF_BB44) && !alignment_error);
    else $error("got %h, alignment_error %d", data_out, alignment_error);

    address = 11;
    width = HALFWORD;
    sign_extend = 1;
    data_in = 'h0000_BB44;
    clk = 0;
    #10 clk = 1;
    #10;
    assert ((data_out == 'hFFFF_BB44) && alignment_error);
    else $error("got %h, alignment_error %d", data_out, alignment_error);

    // check read back word
    address = 8;
    write_enable = 0;
    width = WORD;
    sign_extend = 1;
    #10;
    assert ((data_out == 'hBB44_AA33) && !alignment_error);
    else $error("got %h, alignment_error %d", data_out, alignment_error);

    // check write word
    write_enable = 1;
    address = 16;
    width = WORD;
    sign_extend = 1;
    data_in = 'hFFEE_DDCC;
    clk = 0;
    #10 clk = 1;
    #10;
    assert ((data_out == 'hFFEE_DDCC) && !alignment_error);
    else $error("got %h, alignment_error %d", data_out, alignment_error);

    // check write word
    write_enable = 1;
    address = 21;
    width = WORD;
    sign_extend = 1;
    data_in = 'hFFEE_DDCC;
    clk = 0;
    #10 clk = 1;
    #10;
    assert ((data_out == 'hFFEE_DDCC) && alignment_error);
    else $error("got %h, alignment_error %d", data_out, alignment_error);

    address = 22;
    width = WORD;
    sign_extend = 1;
    data_in = 'hFFEE_DD00;
    clk = 0;
    #10 clk = 1;
    #10;
    assert ((data_out == 'hFFEE_DD00) && alignment_error);
    else $error("got %h, alignment_error %d", data_out, alignment_error);

    address = 23;
    width = WORD;
    sign_extend = 1;
    data_in = 'hFF00_DD00;
    clk = 0;
    #10 clk = 1;
    #10;
    assert ((data_out == 'hFF00_DD00) && alignment_error);
    else $error("got %h, alignment_error %d", data_out, alignment_error);

    $finish;
  end
endmodule
