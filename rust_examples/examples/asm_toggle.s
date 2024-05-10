            .option  norvc
            .text
            .section .init

init:       la      sp, _stack_start        # set stack pointer
            la      t0, data
            sw      zero, 0(t0)

           
main:       lw      t1, 0(t0)
            csrw    0x0, t1                 # led-on
            xori    t1, t1, 1               # toggle lowest bit
            sw      t1, 0(t0)
        
            j       main

            .data
data:       .word   0
