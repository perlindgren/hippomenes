            .option  norvc
            .text
            .section .init
# EXPECTED BEHAVIOR
# hippo!!! should be written to UART every .25s at @20MHz
init:       la      sp, _stack_start        # set stack pointer
           
main:      
    la t2, led
    lw t0, 0(t2)
    csrw 0x0, t0
    xori t0, t0, 1
    sw t0, 0(t2)
    la t0, rodata 
loop:
    lw t1, 0(t0)
    csrw 0x51, t1
    addi t0, t0, 1
    bne t0, t2, loop

    # now wait for a while (.25s)
    li t4, 5000000

loop2:
    addi t4, t4, -1
    bnez t4, loop2
    j main
            
stop:  j stop


       .rodata
rodata: .word 0x70706968
        .word 0x2121216F
        .word 0x74726175
led:    .word 0x00000001

