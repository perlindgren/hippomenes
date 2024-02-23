// Instruction decoder

import decoder_pkg::*;

module decoder (
    input word instr,
    // pc
    //  output pc_mux_t pc_mux_sel,
    // register file
    output r rs1,
    output r rs2,
    output word imm,
    // branch logic
    output reg branch_instr,
    output branch_op_t branch_op,
    // alu
    output alu_a_mux_t alu_a_mux_sel,
    output alu_b_mux_t alu_b_mux_sel,
    output alu_op_t alu_op,
    output reg sub_arith,
    // data memory
    output reg dmem_write_enable,
    // write back
    output wb_mux_t wb_mux_sel,
    output r wb_r,
    output logic wb_write_enable
);
  // https://riscv.org/wp-content/uploads/2017/05/riscv-spec-v2.2.pdf
  // table on page 104
  typedef enum integer {
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
  logic [6:0] funct7;
  logic [2:0] funct3;
  logic [4:0] rd;
  logic [6:0] op;

  always @instr begin
    // R type
    {funct7, rs2, rs1, funct3, rd, op} = instr;

    $display("inst %h, rs2 %b, rs1 %b, rd %b, opcode %b, op %s", instr, rs2, rs1, rd, op,);

    wb_r = rd;

    // {imm_20, imm_10_1, imm_11j, imm_19_12} = instruction[31:12];
    case (op_t'(op))
      OP_LUI: begin
        $display("lui");
        imm = {instr[31:12], {12{1'b0}}};
        alu_a_mux_sel = IMM;
        alu_b_mux_sel = PC;
        wb_mux_sel = WB_ALU;
        wb_write_enable = 1;
      end

      OP_AUIPC: begin
        $display("auipc");
        imm = {instr[31:12], {12{1'b0}}};  // 20 bit immediate + pc
        alu_a_mux_sel = IMM;
        alu_b_mux_sel = PC;
        alu_op = ALU_ADD;
        wb_mux_sel = WB_ALU;
        wb_write_enable = 1;
      end

      OP_JAL: begin
        $display("jal");
      end

      OP_JALR: begin
        $display("jalr");
      end

      OP_BRANCH: begin
        $display("branch");

      end

      OP_LOAD: begin
        $display("load");
      end

      OP_STORE: begin
        $display("store");
      end

      OP_ALUI: begin
        $display("alui");
      end

      OP_ALU: begin
        $display("alu");
      end

      OP_FENCE: begin
        $display("fence");
      end

      OP_CSR: begin
        $display("csr");
      end

      default: begin
        $display("-- non matched op --");
      end
    endcase

  end

endmodule
