            .option  norvc
            .text
init:       la      sp, _stack_start        # set stack pointer

main: addi t1, zero, 2
      addi t2, zero, 3
      add t3, t1, t2
      add t4, t3, t3
      nop
      add t5, t4, t4

#main:       csrwi   0x0, 1  # led-on
#            csrwi   0x0, 0  # led-off
#            la t1, rodata
#            lw t2, 0(t1)
#            csrw 0x50, t2
#            j       main

data:       .data

rodata:     .rodata
            .word 0xDEADBEEF
