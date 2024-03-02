// mem_pkg
`timescale 1ns / 1ps

package mem_pkg;

  typedef enum logic [1:0] {
    BYTE = 'b00,
    HALFWORD = 'b01,
    WORD = 'b10
  } mem_width_t;

endpackage
