            .option  norvc
            .text
            .section .init
# EXPECTED BEHAVIOR
# Every ~.25s (@20MHz), hippo!!! is written to UART
init:       la      sp, _stack_start        # set stack pointer
           
main:       li t1, 0x70706968
            li t2, 0x2121216F
            li t3, 0x74726175
loop:
            csrw   0x51, t1  # ASCII hipp to UART
            csrw   0x51, t2  # ASCII o!!! to UART
            csrw   0x51, t3  # ASCII uart to UART
            csrwi  0x51, 0
            # now wait for couple of seconds
            li t4, 5000000

loop2:
            addi t4, t4, -1
            bnez t4, loop2
            j loop
            
stop:  j stop
rodata:       .rodata
