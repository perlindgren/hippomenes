.option  norvc
.text
.section .init 

# EXPECTED BEHAVIOR:
# writes [SOF Interrupt Id: 8, Interrupt Priority: 7]33:mem_int[EOF]75 to uart ith decoder

init:   
        la      sp, _stack_start # set stack pointer
        
        csrwi   0x300, 8                # enable global interrupts

        la      t1, _memexhandler
        srl     t1, t1, 2
        csrw    0xb08, t1               #set memexhandler jump adrs

        la      t1, mem_ex
        sll     t1, t1, 16
        addi    t1, t1, 0x21
        csrw    0x420, t1

        la      t1, secret_key
        sll     t1, t1, 16
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
        li      t0, 0x69
        addi    sp, sp, -4
        sw      t0, 4(sp)
        
        
        la      t1,  0b1111             # prio 0b11, enable, 0b1, pend 0b0
        csrw    0xB22, t1

        la      t0, secret_key
key:
        lb      t1, 0(t0) # gets memex
        nop
        csrw    0x0, 1
        beqz    t1, key_end
        csrw    0x51, t1
        addi    t0, t0, 1
        j       key
key_end:        
        jr      ra


_memexhandler:    
        la      t0, mem_ex
        nop
        
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
        lw      t1, 0(sp) #Switch 4 to 0 for "secret_key" output
        jr      ra
.global 

.rodata
mem_ex:
.word 0x5F6D656D, 0x00746E69
secret_key:
.word 0x72636573, 0x6B5F7465, 0x00007965