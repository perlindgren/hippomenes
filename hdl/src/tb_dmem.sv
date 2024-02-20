// Data memory

module tb_dmem;
  import config_pkg::*;
  import dmem_pkg::*;

  logic clk;
  logic write_enable;
  dmem_width_t width;
  logic sign_extend;
  logic [DMemAddrWidth-1:0] address;
  logic [31:0] data_in;
  logic [31:0] data_out;
  logic alignment_error;

  dmem dut (
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
    $dumpfile("dmem.fst");
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

    $finish;
  end
endmodule
