            .option  norvc
            .text
            .section .init
# EXPECTED BEHAVIOR
# hippo!!! should be written to UART every .25s at @20MHz
init:       la      sp, _stack_start        # set stack pointer
           
main:       
    la t0, rodata
    lw t1, 0(t0)
    lw t2, 4(t0)
    lw t3, 8(t0) 
           
loop:
    csrw   0x50, t1  # ASCII hipp to UART
    csrw   0x50, t2  # ASCII o!!! to UART
    csrw   0x50, t3  # ASCII uart to UART
    # now wait for a while (.25s)
    li t4, 5000000

loop2:
    addi t4, t4, -1
    bnez t4, loop2
    j loop
            
stop:  j stop


       .rodata
rodata: .word 0x70706968
        .word 0x2121216F
        .word 0x74726175

