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
    output reg branch_always,
    output reg branch_instr,
    output branch_op_t branch_op,
    // alu
    output alu_a_mux_t alu_a_mux_sel,
    output alu_b_mux_t alu_b_mux_sel,
    output alu_op_t alu_op,
    output reg sub_arith,
    // data memory
    output reg dmem_write_enable,
    // csr
    output reg csr_enable,
    // write back
    output wb_mux_t wb_mux_sel,
    output r rd,
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
    OP_SYSTEM = 'b1110011
  } op_t;

  // R-type
  reg [6:0] funct7;
  reg [2:0] funct3;
  reg [6:0] op;

  always @instr begin
    // R type
    {funct7, rs2, rs1, funct3, rd, op} = instr;

    $display();  // new line
    $display("inst %h, rs2 %b, rs1 %b, rd %b, opcode %b", instr, rs2, rs1, rd, op);

    csr_enable = 0;  // set only for csr
    branch_instr = 0;  // set only for branch logic operation
    branch_always = 0;  // set only for jal/jalr
    wb_write_enable = 0;  // set only for instructions writing to rf

    // {imm_20, imm_10_1, imm_11j, imm_19_12} = instruction[31:12];
    case (op_t'(op))
      OP_LUI: begin
        $display("lui");
        imm = {instr[31:12], {12{1'b0}}};
        alu_a_mux_sel = A_ZERO;
        alu_b_mux_sel = B_IMM_EXT;
        alu_op = ALU_OR;
        wb_mux_sel = WB_ALU;
        wb_write_enable = 1;
      end

      OP_AUIPC: begin
        $display("auipc");
        imm = {instr[31:12], {12{1'b0}}};  // 20 bit immediate + pc
        alu_a_mux_sel = A_IMM;
        alu_b_mux_sel = B_PC;
        alu_op = ALU_ADD;
        wb_mux_sel = WB_ALU;
        wb_write_enable = 1;

      end

      OP_JAL: begin
        $display("jal");
        wb_write_enable = 1;
        imm = {12'($signed(instr[31])), instr[19:12], instr[20], instr[30:21], 1'b0};
        $display("--------  bl imm %h", imm);
        alu_a_mux_sel = A_IMM;
        alu_b_mux_sel = B_PC;
        wb_mux_sel = WB_PC_PLUS_4;
        branch_always = 1;
      end

      OP_JALR: begin
        $display("jalr");
        wb_write_enable = 1;
        alu_a_mux_sel = A_IMM;
        alu_b_mux_sel = B_PC;
        wb_mux_sel = WB_PC_PLUS_4;
        branch_always = 1;
      end

      OP_BRANCH: begin
        $display("branch");
        branch_instr = 1;
        wb_write_enable = 0;
        imm = {20'($signed(instr[31])), instr[7], instr[30:25], instr[11:8], 1'b0};
        $display("--------  bl imm %h", imm);
        branch_op = branch_op_t'(funct3);
        alu_a_mux_sel = A_IMM;
        alu_b_mux_sel = B_PC;
        alu_op = ALU_ADD;
      end

      OP_LOAD: begin
        $display("load");
      end

      OP_STORE: begin
        $display("store");
      end

      OP_ALUI: begin
        $display("alui");
        imm = 32'($signed(instr[31:20]));
        alu_a_mux_sel = A_RS1;
        alu_b_mux_sel = B_IMM_EXT;
        alu_op = alu_op_t'(funct3);
        wb_mux_sel = WB_ALU;
        wb_write_enable = 1;
      end

      OP_ALU: begin
        $display("alu");
      end

      OP_FENCE: begin
        $display("fence");
      end

      OP_SYSTEM: begin
        $display("system");
        // TODO
        wb_write_enable = 0;
        csr_enable = 1;
      end

      default: begin
        $display("-- non matched op --");
      end
    endcase

  end

endmodule
