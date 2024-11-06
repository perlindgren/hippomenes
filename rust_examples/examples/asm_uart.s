.option  norvc
.text
.section .init
# EXPECTED BEHAVIOR
# Every ~.25s (@20MHz), hippo!!! is written to UART

init:       la      sp, _stack_start        # set stack pointer
           
main:       li t1, 0x70706968 # ppih
            li t2, 0x2121216F # !!!o
            li t3, 0x74726175 # trau

hipp:       csrw   0x51, t1  # rightmost byte of t1 to UART
            srl t1, t1, 8    # shift rightmost byte out
            bnez t1, hipp     # if we have bytes left in register, write them, else continue

o:          csrw   0x51, t2  # rightmost byte of t2 to UART
            srl t2, t2, 8    # shift rightmost byte out
            bnez t2, o    # if we have bytes left in register, write them, else continue

uart:       csrw   0x51, t3  # rightmost byte of t3 to UART
            srl t3, t3, 8    # shift rightmost byte out
            bnez t3, uart # if we have bytes left in register, write them, else continue

            # now wait for some time
            li t4, 5000000

loop2:
            addi t4, t4, -1
            bnez t4, loop2
            j main           // reload payload and write it to UART again
            
stop:  j stop
rodata:       .rodata