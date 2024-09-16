.option  norvc
.text
.section .init

init:       
        la      sp, _stack_start        # set stack pointer

        csrwi   0x300, 8                # enable global interrupts

        la      t1, tsk0
        srl     t1, t1, 2
        csrw    0xB00, t1               # setup tsk0 address

        la t1,  0b0110                  # prio 0b01, enable, 0b1, pend 0b0
        csrw    0xB20, t1

        csrsi   0xB20, 1                # queue interrupt
main:   
        csrwi   0x0, 1
        
        nop
        nop
        nop
        j main
        nop
tsk0:
        //sw      t0, -4(sp) // current SP
        lw      t0, 0(sp) // Latched SP
        nop
        csrwi   0x0, 0
        nop
        jr      ra
        nop
end:    
        j end
        nop
.rodata