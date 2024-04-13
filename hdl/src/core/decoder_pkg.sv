// decoder_pkg
`timescale 1ns / 1ps

import config_pkg::*;
package decoder_pkg;

  typedef enum logic [2:0] {
    ECALL  = 3'b000,
    // EBREAK = 3'b000,
    CSRRW  = 3'b001,
    CSRRS  = 3'b010,
    CSRRC  = 3'b011,
    CSRRWI = 3'b101,
    CSRRSI = 3'b110,
    CSRRCI = 3'b111
  } csr_op_t;

  typedef enum logic {
    PC_NEXT   = 'b0,
    PC_BRANCH = 'b1
  } pc_branch_mux_t;

  typedef enum logic {
    PC_NORMAL    = 'b0,
    PC_INTERRUPT = 'b1
  } pc_interrupt_mux_t;

  typedef enum logic [1:0] {
    MUL_MUL    = 'b00,
    MUL_MULH   = 'b01,
    MUL_MULHSU = 'b10,
    MUL_MULHU  = 'b11
  } mul_op_t;

  typedef enum logic [2:0] {
    ALU_ADD  = 3'b000,  // ADDI
    ALU_SLL  = 3'b001,  // SLLI
    ALU_SLT  = 3'b010,  // SLLI
    ALU_SLTU = 3'b011,  // SLTIU
    ALU_EXOR = 3'b100,  // EXORI
    ALU_SR   = 3'b101,  // SRL, SRA, SRLI, SRAI
    ALU_OR   = 3'b110,  // ORI
    ALU_AND  = 3'b111   // ANDI
  } alu_op_t;

  typedef enum logic [1:0] {
    A_IMM  = 2'b00,
    A_RS1  = 2'b01,
    A_ZERO = 2'b10
  } alu_a_mux_t;

  typedef enum {
    B_RS2,
    B_IMM_EXT,
    B_PC_PLUS_4,
    B_PC,
    B_SHAMT
  } alu_b_mux_t;

  typedef enum logic [2:0] {
    BL_BEQ  = 'b000,
    BL_BNE  = 'b001,
    BL_BLT  = 'b100,
    BL_BGE  = 'b101,
    BL_BLTU = 'b110,
    BL_BGEU = 'b111
  } branch_op_t;

  typedef enum {
    WB_ALU,
    WB_DM,
    WB_CSR,
    WB_PC_PLUS_4,
    WB_MUL
  } wb_mux_t;

  typedef logic [4:0] r;
  typedef logic [31:0] word;

endpackage


