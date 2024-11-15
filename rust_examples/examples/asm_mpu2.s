.option  norvc
.text
.section .init 
init:   
        la      sp, _stack_start # set stack pointer
        
        csrwi   0x300, 8                # enable global interrupts

        la      t1, _memexhandler
        srl     t1, t1, 2
        csrw    0xb08, t1               #set memexhandler jump adrs

        la      t1, tsk1
        srl     t1, t1, 2
        csrw    0xB01, t1               # setup tsk1 address

        
        la      t1, tsk2
        srl     t1, t1, 2
        csrw    0xB02, t1               # setup tsk2 address

        la      t1,  0b0111             # prio 0b01, enable, 0b1, pend 0b1
        csrw    0xB21, t1
        
        j exit

tsk1:
        la      t1,  0b1111             # prio 0b10, enable, 0b1, pend 0b0
        csrw    0xB22, t1
        jr      ra
tsk2:
        jr      ra

exit:   j       exit


.global 

.rodata
