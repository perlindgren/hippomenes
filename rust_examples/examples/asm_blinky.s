            .option  norvc
            .text
init:       la      sp, _stack_start        # set stack pointer

main: #li t1, 1
      #li t2, 2
      #add t3, t1, t2
      #add t3, t3, t3
      li t1, 4
     # sw t1, 0(t1)
      lw t2, 0(t1)
      add t3, t2, t1
blink: 
          j       blink
data:       .data

rodata:     .rodata
led:              .word 0x00000001
word1:            .word 0x00000002
word2:            .word 0x00000003
