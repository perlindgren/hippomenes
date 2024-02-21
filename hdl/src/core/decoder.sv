// Instruction decoder

import decoder_pkg::*;

module decoder (
    input logic [31:0] instr,
    output pc_mux_t pc_mux_sel,
    output wb_data_mux_t wb_data_mux_sel,
    output wb_reg_mux_t wb_reg_mux_sel,
    output logic wb_enable,
    output alu_a_mux_t alu_a_mux_sel,
    output alu_b_mux_t alu_b_mux_sel
);
  // https://riscv.org/wp-content/uploads/2017/05/riscv-spec-v2.2.pdf
  // table on page 104
  typedef enum {
    OP_LUI    = 'b0110111,
    OP_AUIPC  = 'b0010111,
    OP_JAL    = 'b1101111,
    OP_JALR   = 'b1100111,
    OP_BRANCH = 'b1100011,
    OP_LOAD   = 'b0000011,
    OP_STORE  = 'b0100011,
    OP_ALUI   = 'b0010011,
    OP_ALU    = 'b0110011,
    OP_FENCE  = 'b0001111,
    OP_CSR    = 'b1110011
  } op_t;

  typedef enum {
    ECALL,
    CSRRW,
    CSRRS,
    CSRRC,
    CSRRWI,
    CSRRSI,
    CSRRCI
  } csr_t;

  // R-type
  logic [ 6:0] funct7;
  logic [ 4:0] rs2;
  logic [ 4:0] rs1;
  logic [ 2:0] funct3;
  logic [ 4:0] rd;
  logic [ 6:0] opcode;

  logic [31:0] imm;


  always begin
    // R type
    {funct7, rs2, rs1, funct3, rd, opcode} = instr;

    // {imm_20, imm_10_1, imm_11j, imm_19_12} = instruction[31:12];
    case (instr)
      OP_LUI: begin
        imm = {instr[31:12], {12{1'b0}}};
        alu_a_mux_sel = IMM;
        // wb_data_mux_sel = ALU;
        wb_reg_mux_sel = RD;
        wb_enable = 1;
      end

      OP_AUIPC: begin
        imm = {instr[31:12], {12{1'b0}}};
        wb_data_mux_sel = ALU;
        wb_reg_mux_sel = RD;
        wb_enable = 0;
      end

      OP_JAL: begin
      end

      OP_JALR: begin
      end

      OP_BRANCH: begin
      end

      OP_LOAD: begin
      end

      OP_STORE: begin
      end

      OP_ALUI: begin
      end

      OP_ALU: begin
      end

      OP_FENCE: begin
      end

      OP_CSR: begin
      end

      default: begin
      end
    endcase

  end

endmodule
