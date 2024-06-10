            .option  norvc
            .text
            .section .init

init:       la      sp, _stack_start        # set stack pointer
           
main:       li t1, 3
            li t2, 5
            mul t3, t1, t2
            j       main

data:       .data
