.option  norvc
.text
.section .init 
# This test checks if an interrupt does not happens when accessing inside the tasks local stack.
# EXPECTED BEHAVIOR:
# writes terminated to uart if working correctly

init:   
        la      sp, _stack_start # set stack pointer
        
        csrwi   0x300, 8                # enable global interrupts

        la      t1, _memexhandler
        srl     t1, t1, 2
        csrw    0xb08, t1               #set memexhandler jump adrs

        la      t1, mem_ex
        sll     t1, t1, 14
        addi    t1, t1, 0x21
        csrw    0x420, t1

        la      t1, secret_key
        sll     t1, t1, 14
        addi    t1, t1, 0x2D
        csrw    0x404, t1

        la      t1, tsk1
        srl     t1, t1, 2
        csrw    0xB01, t1               # setup tsk0 address

        
        la      t1, tsk2
        srl     t1, t1, 2
        csrw    0xB02, t1               # setup tsk0 address

        la      t1,  0b0111             # prio 0b01, enable, 0b1, pend 0b1
        csrw    0xB21, t1



        
        j exit

tsk1:
        la      t1,  0b1111             # prio 0b10, enable, 0b1, pend 0b0
        csrw    0xB22, t1

        la      t0, secret_key
key:
        lb      t1, 0(t0)
        beqz    t1, key_end
        csrw    0x51, t1
        addi    t0, t0, 1
        j       key
key_end:        
        jr      ra


_memexhandler:    
        la      t0, mem_ex
mem:
        lb      t1, 0(t0)
        beqz    t1, mem_end
        csrw    0x51, t1
        addi    t0, t0, 1
        j       mem
mem_end:        
        csrwi   0x300, 0
        csrwi   0x347, 1

exit:   j       exit

tsk2:
        lw      t1, 4(sp)
        jr      ra
.global 

.rodata
mem_ex:
.word 0x5F6D656D, 0x00746E69
secret_key:
.word 0x72636573, 0x6B5F7465, 0x00007965