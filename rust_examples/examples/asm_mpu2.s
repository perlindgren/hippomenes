.option  norvc
.text
.section .init 
# This test checks if an interrupt happens when accessing outside the tasks local stack.
# EXPECTED BEHAVIOR:
# LED 1 should turn on if working correctly
# LED 2 should not turn on
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
        nop

main:                  # queue interrupt
        csrwi   0x0, 2
        j       main
        nop
tsk0:
        
        lw      t0, -4(sp) 
        j       main
        nop


_memexhandler:    

        csrwi   0x0, 1
        j       _memexhandler
        nop

.global 

.rodata