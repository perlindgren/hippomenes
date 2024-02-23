// decoder stuff
package decoder_pkg;

  typedef enum {
    PC_NEXT,
    PC_BRANCH
  } pc_mux_t;

  typedef enum {
    ALU,
    DM,
    CLIC
  } wb_data_mux_t;

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
    IMM,
    RS1,
    ZERO
  } alu_a_mux_t;

  typedef enum {
    RS2,
    IMM_EXT,
    PC_PLUS_4,
    PC,
    SHAMT
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
    WB_DM
  } wb_mux_t;

  typedef logic [31:0] word;
  typedef logic [4:0] r;

endpackage


