.option  norvc
.text
.section .init 
# This test checks if an interrupt does not happens when accessing inside the tasks local stack.
# EXPECTED BEHAVIOR:
# writes terminated to uart if working correctly

init:   
        nop     #hippo skipps first instruction for some reason
        la      sp, _stack_start # set stack pointer
        
        csrwi   0x300, 8                # enable global interrupts

        la      t1, _memexhandler
        srl     t1, t1, 2
        csrw    0xb08, t1               #set memexhandler jump adrs

        la      t1, tsk0
        srl     t1, t1, 2
        csrw    0xB01, t1               # setup tsk0 address


        la      t1,  0b0111             # prio 0b01, enable, 0b1, pend 0b0
        csrw    0xB21, t1


loop:   j loop
        nop

tsk0:
        
        lw      t0, 0(sp) 
        j       terminated
        nop

terminated:                  
        li      t1, 0x6D726574
        li      t2, 0x74616E69
        li      t3, 0x00006465

term:   csrw    0x51, t1     # rightmost byte of t1 to UART
        srl     t1, t1, 8    # shift rightmost byte out
        bnez    t1, term     # if we have bytes left in register, write them, else continue
inat:   csrw    0x51, t2     # rightmost byte of t1 to UART
        srl     t2, t2, 8    # shift rightmost byte out
        bnez    t2, inat     # if we have bytes left in register, write them, else continue
ed:     csrw    0x51, t3     # rightmost byte of t1 to UART
        srl     t3, t3, 8    # shift rightmost byte out
        bnez    t3, ed     # if we have bytes left in register, write them, else continue

        j       exit
        nop

_memexhandler:    
        li      t1, 0x5F6D656D
        li      t2, 0x00746E69

mem_:   csrw    0x51, t1     # rightmost byte of t1 to UART
        srl     t1, t1, 8    # shift rightmost byte out
        bnez    t1, mem_     # if we have bytes left in register, write them, else continue
int:    csrw    0x51, t2     # rightmost byte of t1 to UART
        srl     t2, t2, 8    # shift rightmost byte out
        bnez    t2, int     # if we have bytes left in register, write them, else continue

        j       exit
        nop

exit:   j       exit
.global 

.rodata