            .option  norvc
            .text
            .section .init

init:       la      sp, _stack_start        # set stack pointer
           
main:       csrwi   0x0, 1                  # led-on
            li      t0, 50000             # shorter wait

l1:         addi    t0, t0, -1
            bne     t0, zero, l1

            csrwi   0x0, 0                  # led-off
            li      t0, 20000000            # short wait
l2:         addi    t0, t0, -1
            bne     t0, zero, l2

            j       main

data:       .data
