.option  norvc
.text
.section .init 
# This test checks if an interrupt happens when reading and writing in an allowed area outside of stack with the correct permissions.
# EXPECTED BEHAVIOR:
# LED 2 should turn on if working correctly
# LED 1 should not turn on
init:   
        nop     #hippo skipps first instruction for some reason
        la      sp, _stack_start # set stack pointer
        
        csrwi   0x300, 8                # enable global interrupts

        la      t1, _memexhandler
        srl     t1, t1, 2
        csrw    0xb08, t1               #set memexhandler jump adrs

        li      t1, 0x0400 # t1 =0x400 
        slli    t1, t1, 16      # bits 31:18 is the start/lowest address 
        addi    t1, t1, 0b1111     # bits 0 is for reading enable, bit 1 is for writing enable and bits 18:2 is for the length. length + start address is the higher limit. all access below is granted
        csrw    0x400, t1       #entry for accessing between 0x400 and 0x404

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
        li    t1, 0x400
        lw      t0, 0(t1) 
        sw      t0, 0(t1) 
        jr      ra
        nop


_memexhandler:    

        csrwi   0x0, 1
        j       _memexhandler
        nop

.global 

.rodata