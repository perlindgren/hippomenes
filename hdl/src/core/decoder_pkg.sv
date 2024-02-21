// decoder stuff
package decoder_pkg;

  typedef enum {
    PC_NEXT,
    PC_BRANCH
  } pc_mux_t;

  typedef enum {
    ALU,
    DM
  } wb_data_mux_t;

  typedef enum {
    RD,
    XXX
  } wb_reg_mux_t;

  typedef enum {
    IMM,
    RS1,
    ZERO
  } alu_a_mux_t;

  typedef enum {
    RS2,
    IMM_EXT,
    PC_PLUS_4,
    PC
  } alu_b_mux_t;

endpackage


