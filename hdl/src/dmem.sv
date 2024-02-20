// Data memory

module dmem
  import config_pkg::*;
  import dmem_pkg::*;
#(
    // parameter integer RamStart = RamStart;
) (
    input logic clk,
    input logic write_enable,
    input dmem_width_t width,
    input logic sign_extend,
    input logic [DMemAddrWidth-1:0] address,
    input logic [31:0] data_in,
    output logic [31:0] data_out,
    output logic alignment_error
);

  logic [31:0] mem[DMemSize >> 2];
  logic [3:0][7:0] read_word;

  //   always_ff @(posedge clk) begin
  //     // do not write to register 0
  //     if (writeEn) begin
  //     //if (writeEn & writeAddr != '0') begin
  //       regs[writeAddr] <= writeData;
  //     end
  //   end

  initial begin
    mem[0] = 'h1234_5678;
    mem[1] = 'h0000_1111;
    mem[2] = 'h1111_0000;
    mem[3] = 'hb0a0_9080;
  end

  always @(address, sign_extend, width) begin
    read_word = mem[address[DMemAddrWidth-1:2]];

    case (width)
      BYTE: begin
        alignment_error = 0;
        data_out = {
          24'($signed(read_word[address[1:0]][7:7] && sign_extend)), read_word[address[1:0]]
        };
      end
      HALFWORD: begin
        alignment_error = address[0:0];
        data_out = {
          16'($signed(read_word[{address[1:1], 1'(1)}][7:7] && sign_extend)),
          read_word[{address[1:1], 1'(1)}],
          read_word[{address[1:1], 1'(0)}]
        };
      end
      WORD: begin
        alignment_error = (address[1:0] != 0);
        data_out = read_word;
      end
      default: data_out = 0;
    endcase

    $display("data = %h", data_out);
  end

endmodule
