// decoder stuff
package decoder_pkg;

  typedef enum {
    ECALL,
    CSRRW,
    CSRRS,
    CSRRC,
    CSRRWI,
    CSRRSI,
    CSRRCI
  } csr_t;

  typedef enum {
    PC_NEXT   = 'b0,
    PC_BRANCH = 'b1
  } pc_mux_t;

  // typedef enum {
  //   WB_ALU,
  //   WB_DM
  //   // WB_CLIC
  // } wb_data_mux_t;

  typedef enum {
    ALU_ADD  = 'b000,
    ALU_SLL  = 'b001,
    ALU_SLT  = 'b010,
    ALU_SLTU = 'b011,
    ALU_EXOR = 'b100,
    ALU_SR   = 'b101,
    ALU_OR   = 'b110,
    ALU_AND  = 'b111
  } alu_op_t;

  typedef enum {
    A_IMM,
    A_RS1,
    A_ZERO
  } alu_a_mux_t;

  typedef enum {
    B_RS2,
    B_IMM_EXT,
    B_PC_PLUS_4,
    B_PC,
    B_SHAMT
  } alu_b_mux_t;

  typedef enum {
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
    WB_PC_PLUS_4
  } wb_mux_t;

  typedef logic [31:0] word;
  typedef logic [4:0] r;

endpackage


