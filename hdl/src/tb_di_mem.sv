// Data memor   y

module tb_di_mem;
  import config_pkg::*;
  import mem_pkg::*;

  logic clk;

  // Data memory
  logic d_write_enable;
  mem_width_t d_width;
  logic d_sign_extend;
  logic [DMemAddrWidth-1:0] d_address;
  logic [31:0] d_data_in;
  logic [31:0] d_data_out;
  logic d_alignment_error;

  // Instruction memory
  logic i_write_enable;
  mem_width_t i_width;
  logic i_sign_extend;
  logic [IMemAddrWidth-1:0] i_address;
  logic [31:0] i_data_in;
  logic [31:0] i_data_out;
  logic i_alignment_error;

  mem d_mem (
      .clk(clk),
      .write_enable(d_write_enable),
      .width(d_width),
      .sign_extend(d_sign_extend),
      .address(d_address),
      .data_in(d_data_in),
      .data_out(d_data_out),
      .alignment_error(d_alignment_error)
  );

  mem i_mem (
      .clk(clk),
      .write_enable(i_write_enable),
      .width(i_width),
      .sign_extend(i_sign_extend),
      .address(i_address),
      .data_in(i_data_in),
      .data_out(i_data_out),
      .alignment_error(i_alignment_error)
  );

  initial begin
    $dumpfile("di_mem.fst");
    $dumpvars;

    // test successful data mem
    d_address = 0;
    d_width   = WORD;

    // test read instruction mem with alignment error
    i_address = 5;
    i_width   = WORD;
    #10;
    assert ((d_data_out == 'h1234_5678) && !d_alignment_error);
    assert ((i_data_out == 'h0000_1111) && i_alignment_error);

    // test write operations
    d_write_enable = 1;
    d_address = 0;
    d_width = BYTE;
    d_sign_extend = 1;
    d_data_in = 'h0000_0077;

    i_write_enable = 1;
    i_address = 3;
    i_width = BYTE;
    i_sign_extend = 1;
    i_data_in = 'h0000_00cc;

    clk = 0;
    #10 clk = 1;
    #10;
    assert ((d_data_out == 'h0000_0077) && !d_alignment_error);
    else $error("got %h, alignment_error %d", d_data_out, d_alignment_error);

    assert ((i_data_out == 'hFFFF_FFCC) && !i_alignment_error);
    else $error("got %h, alignment_error %d", i_data_out, i_alignment_error);

    d_address = 0;
    d_write_enable = 0;
    d_width = WORD;

    i_address = 0;
    i_write_enable = 0;
    i_width = WORD;

    #10;
    assert ((d_data_out == 'h1234_5677) && !d_alignment_error);
    else $error("got %h, alignment_error %d", d_data_out, d_alignment_error);

    assert ((i_data_out == 'hcc34_5678) && !i_alignment_error);
    else $error("got %h, alignment_error %d", i_data_out, i_alignment_error);

    $finish;
  end
endmodule
