.option  norvc
.text
.section .init 

init:       
        la      sp, _stack_start        # set stack pointer
        csrwi   0x300, 8                # enable global interrupts
        
        la      t1, _memexhandler
        srl     t1, t1, 2
        csrw    0xb08, t1               #set memexhandler jump adrs

        li      t1, 0x0400 # t1 =0x400 
        slli    t1, t1, 16
        addi    t1, t1, 0xF3
        csrw    0x400, t1       #entry for accessing between 0x400 and 0x400

        la      t1, tsk0
        srl     t1, t1, 2
        csrw    0xB00, t1               # setup tsk0 address
        

        la      t1,  0b0110             # prio 0b01, enable, 0b1, pend 0b0
        csrw    0xB20, t1

        
main:   
        nop                # queue interrupt
        j       main
        nop
tsk0:
        
        
        addi    t1, x0, 0x400
        lw      t0, 0(sp) 
        nop
        csrwi   0x0, 1
        lw      t0, 0(t1)
        nop 
        csrwi   0x0, 4
        lw      t0, -4(t1) 
        nop
        nop
        csrwi   0x0, 8
        nop
        jr      ra
        nop
        
_memexhandler:    
        nop
        csrwi   0x0, 2
        j       _memexhandler


.global 

.rodata