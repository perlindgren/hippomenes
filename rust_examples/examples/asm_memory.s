            .option  norvc
            .text
            .section .init
# This bench is meant to be run in simulation
# EXPECTED BEHAVIOR
# The values specified in the comments should appear in the target registers
init:       la      sp, _stack_start        # set stack pointer

main:

      la t1, word1
      lw t2, 0(t1) ### 0x00000001
      la t1, word2
      lw t1, 0(t1) ### 0x00000002
      add t3, t2, t1
      lw t4, -5(t3)
      sw t4, -1(t3)
      lw t5, -1(t3)
      sb t5, -1(t3)
      lw t6, -1(t3)
      sb t6, 0(t3)
      lw t5, -1(t3)
      sb t6, 1(t3)
      lw t4, -1(t3)
      sb t6, 2(t3)
      lw t3, -1(t3)
      la t1, led
      li t2, 0x789A1234
      sw t2, 0(t1)
      lw t3, 0(t1)
      lb t4, 0(t1)
      lb t5, 1(t1)
      lb t6, 2(t1)
      lbu s1, 2(t1) ### 0x0000009a
      lhu s2, 2(t1) ### 0x0000789a
      lhu s3, 1(t1) ### 0x00009a12
      lh  s4, 1(t1) ### 0xFFFF9a12
      sb  t5, 2(t1)  ### 0x00000012
      lw  s0, 0(t1)  ### 0x78121234
      sw  s4, 4(t1)
      lw  s5, 2(t1)  ### 0x9a127812
      lw  s5, 1(t1)  ### 0x12781212
      lw  s5, 3(t1)  ### 0xFF9a1278
      lhu s5, 3(t1)  ### 0x00001278
      lh  s5, 3(t1)  ### 0x00001278
      lh  s5, -1(t1) ### 0x000034XX
      li s1, 0xFF 
      sw s1, 4(t1)
      lh s5, 3(t1)  ### 0xFFFFFF78
blink: 
          j       blink
data:       .data

rodata:     .rodata
led:              .word 0x00000001
word1:            .word 0x00000002
word2:            .word 0x00000003
