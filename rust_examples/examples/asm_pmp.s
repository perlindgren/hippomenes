.option  norvc
.text
.section .init

init:       
        la      sp, _stack_start        # set stack pointer
        csrwi   0x300, 8                # enable global interrupts

        la      t1, tsk0
        srl     t1, t1, 2
        csrw    0xB00, t1               # setup tsk0 address

        la      t1,  0b0110             # prio 0b01, enable, 0b1, pend 0b0
        csrw    0xB20, t1

        csrsi   0xB20, 1                # queue interrupt
main:   
        csrwi   0x0, 0
        
        nop
        nop
        nop
        j main
        nop
tsk0:
        li      t1, 0x400 # t1 =0x400 
        slli    t1, t1, 16
        addi    t1, t1, 0x400
        csrw    0x400, t1       #entry for accessing between 0x400 and 0x400
        li      t1, 0xFF
        csrw    0x480, t1       #enable reading and writing
        
        addi    t1, x0, 0x400
        lw      t0, 0(t1) 
        csrwi   0x0, 0
        lw      t0, 4(t1) 
        nop
        nop
        csrwi   0x0, 1
        nop
        jr      ra
        nop
end:    
        j end
        nop
.rodata