// mem
`timescale 1ns / 1ps

module d_mem_spram
  import config_pkg::*;
  import mem_pkg::*;
(
    input logic clk,
    input logic reset,
    // input logic write_enable,
    input mem_width_t width,
    input logic sign_extend,
    input logic [DMemAddrWidth-1:0] addr,
    input logic [31:0] data_in,
    input logic write_enable,
    output logic [31:0] data_out
);

  logic [7:0] block_0_dout;
  logic [7:0] block_1_dout;
  logic [7:0] block_2_dout;
  logic [7:0] block_3_dout;
  logic [7:0] block_0_din;
  logic [7:0] block_1_din;
  logic [7:0] block_2_din;
  logic [7:0] block_3_din;
  logic [DMemAddrWidth-2:0] block_0_addr;
  logic [DMemAddrWidth-2:0] block_1_addr;
  logic [DMemAddrWidth-2:0] block_2_addr;
  logic [DMemAddrWidth-2:0] block_3_addr;
  logic block_0_we;
  logic block_1_we;
  logic block_2_we;
  logic block_3_we;

  spram_block #(
      .MemFileName("data0.mem")
  ) block_0 (
      .clk(clk),
      .reset(reset),
      .address(block_0_addr),
      .write_enable(block_0_we),
      .data_in(block_0_din),
      .data_out(block_0_dout)
  );
  spram_block #(
      .MemFileName("data1.mem")
  ) block_1 (
      .clk(clk),
      .reset(reset),
      .address(block_1_addr),
      .write_enable(block_1_we),
      .data_in(block_1_din),
      .data_out(block_1_dout)
  );
  spram_block #(
      .MemFileName("data2.mem")
  ) block_2 (
      .clk(clk),
      .reset(reset),
      .address(block_2_addr),
      .write_enable(block_2_we),
      .data_in(block_2_din),
      .data_out(block_2_dout)
  );
  spram_block #(
      .MemFileName("data3.mem")
  ) block_3 (
      .clk(clk),
      .reset(reset),
      .address(block_3_addr),
      .write_enable(block_3_we),
      .data_in(block_3_din),
      .data_out(block_3_dout)
  );
  always_comb begin
    if (addr % 4 == 1) begin
      block_0_addr = addr[DMemAddrWidth-1:2] + 1;
      block_1_addr = addr[DMemAddrWidth-1:2];
      block_2_addr = addr[DMemAddrWidth-1:2];
      block_3_addr = addr[DMemAddrWidth-1:2];
      data_out = {block_0_dout, block_3_dout, block_2_dout, block_1_dout};
      block_0_din = data_in[31:24];
      block_1_din = data_in[7:0];
      block_2_din = data_in[15:8];
      block_3_din = data_in[23:16];
      if (write_enable) begin
        case (width)
          BYTE: begin
            block_0_we = 0;
            block_1_we = 1;
            block_2_we = 0;
            block_3_we = 0;
          end
          HALFWORD: begin
            block_0_we = 0;
            block_1_we = 1;
            block_2_we = 1;
            block_3_we = 0;
          end
          WORD: begin
            block_0_we = 1;
            block_1_we = 1;
            block_2_we = 1;
            block_3_we = 1;
          end
          default: begin
            block_0_we = 0;
            block_1_we = 0;
            block_2_we = 0;
            block_3_we = 0;
          end
        endcase
      end
    end else if (addr % 4 == 2) begin
      block_0_addr = addr[DMemAddrWidth-1:2] + 1;
      block_1_addr = addr[DMemAddrWidth-1:2] + 1;
      block_2_addr = addr[DMemAddrWidth-1:2];
      block_3_addr = addr[DMemAddrWidth-1:2];
      data_out = {block_1_dout, block_0_dout, block_3_dout, block_2_dout};
      block_0_din = data_in[23:16];
      block_1_din = data_in[31:24];
      block_2_din = data_in[7:0];
      block_3_din = data_in[15:8];
      case (width)
        BYTE: begin
          block_0_we = 0;
          block_1_we = 0;
          block_2_we = 1;
          block_3_we = 0;
        end
        HALFWORD: begin
          block_0_we = 0;
          block_1_we = 0;
          block_2_we = 1;
          block_3_we = 1;
        end
        WORD: begin
          block_0_we = 1;
          block_1_we = 1;
          block_2_we = 1;
          block_3_we = 1;
        end
        default: begin
          block_0_we = 0;
          block_1_we = 0;
          block_2_we = 0;
          block_3_we = 0;
        end
      endcase
    end else if (addr % 4 == 3) begin
      block_0_addr = addr[DMemAddrWidth-1:2] + 1;
      block_1_addr = addr[DMemAddrWidth-1:2] + 1;
      block_2_addr = addr[DMemAddrWidth-1:2] + 1;
      block_3_addr = addr[DMemAddrWidth-1:2];
      data_out = {block_2_dout, block_1_dout, block_0_dout, block_3_dout};
      block_0_din = data_in[15:8];
      block_1_din = data_in[23:16];
      block_2_din = data_in[31:24];
      block_3_din = data_in[7:0];
      case (width)
        BYTE: begin
          block_0_we = 0;
          block_1_we = 0;
          block_2_we = 0;
          block_3_we = 1;
        end
        HALFWORD: begin
          block_0_we = 1;
          block_1_we = 0;
          block_2_we = 0;
          block_3_we = 1;
        end
        WORD: begin
          block_0_we = 1;
          block_1_we = 1;
          block_2_we = 1;
          block_3_we = 1;
        end
        default: begin
          block_0_we = 0;
          block_1_we = 0;
          block_2_we = 0;
          block_3_we = 0;
        end
      endcase
    end else if (addr % 4 == 0) begin
      block_0_addr = addr[DMemAddrWidth-1:2];
      block_1_addr = addr[DMemAddrWidth-1:2];
      block_2_addr = addr[DMemAddrWidth-1:2];
      block_3_addr = addr[DMemAddrWidth-1:2];
      data_out = {block_3_dout, block_2_dout, block_1_dout, block_0_dout};
      block_0_din = data_in[7:0];
      block_1_din = data_in[15:8];
      block_2_din = data_in[23:16];
      block_3_din = data_in[31:24];
      case (width)
        BYTE: begin
          block_0_we = 1;
          block_1_we = 0;
          block_2_we = 0;
          block_3_we = 0;
        end
        HALFWORD: begin
          block_0_we = 1;
          block_1_we = 1;
          block_2_we = 0;
          block_3_we = 0;
        end
        WORD: begin
          block_0_we = 1;
          block_1_we = 1;
          block_2_we = 1;
          block_3_we = 1;
        end
        default: begin
          block_0_we = 0;
          block_1_we = 0;
          block_2_we = 0;
          block_3_we = 0;
        end
      endcase
    end
    case (width)
      BYTE: begin
        if (sign_extend) begin
          data_out = signed'(data_out[7:0]);
        end else begin
          data_out = unsigned'(data_out[7:0]);
        end
      end
      HALFWORD: begin
        if (sign_extend) begin
          data_out = signed'(data_out[15:0]);
        end else begin
          data_out = unsigned'(data_out[15:0]);
        end
      end
      WORD: begin
        // sign extension doesnt matter for word wide access
      end
      default: begin
      end
    endcase
    if (!write_enable) begin
      block_0_we = 0;
      block_1_we = 0;
      block_2_we = 0;
      block_3_we = 0;
    end
  end

endmodule
