.option  norvc
.text
.section .init
# EXPECTED BEHAVIOR
# Every ~.25s (@20MHz), hippo!!!! is written to UART

init:       la      sp, _stack_start        # set stack pointer
           
main:       li t1, 0x217068
            li t2, 0x216F69
            li t3, 0x212170
            csrwi 0x347, 1   # open RTMT frame
loop:
            csrw   0x51, t1  # lowest byte of t1 to UART
            csrw   0x51, t2  # lowest byte of t2 to UART
            csrw   0x51, t3  # lowest byte of t3 to UART
            srl t1, t1, 8    # lowest bytes have now been printed, shift them out
            srl t2, t2, 8
            srl t3, t3, 8
            bne zero, t1, loop    # if there are some bytes to be printed still, repeat
            csrwi 0x347, 0   # close RTMT frame
            # else, wait for some time
            li t4, 5000000

loop2:
            addi t4, t4, -1
            bnez t4, loop2
            j main
            
stop:  j stop
rodata:       .rodata
