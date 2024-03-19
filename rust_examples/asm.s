            .option  norvc
            .text
init:       la      sp, _stack_start        # set stack pointer
main:       csrwi   0x300, 8                # enable global interrupts
            la      t1, isr_0
            srl     t1, t1, 2
            csrw    0xB00, t1               # setup isr_0 address
            la      t2, isr_1
            srl     t2, t2, 2
            csrw    0xB01, t2               # setup isr_1 address
            #li      t2, 0b11110000         # interrupt every 15 cycles, cmp value 0b1111 = 15, prescaler 0b0000                                           
            #csrw    0x400, t2              # timer.counter_top CSR
            la t1,  0b1110                  # prio 0b11, enable, 0b1, pend 0b0
            csrw    0xB21, t1
            la t1,  0b1                     # pended 
            csrs    0xB21, t1
            #csrw    0xB20, t1              # write above to interrupt 0 (timer interrupt)
stop:       j       stop                    # wait for interrupt

isr_0:      la      t0, .toggled            # &static mut toggled state
            lw      t1, 0(t0)               # deref toggled
            xori    t1, t1, 1               # toggle bit 0
            csrw    0x0, t1                 # set bit 0 (t1 = 1) in GPIO CSR (LED on/off)
            sw      t1, 0(t0)               # store toggled value
            csrr    t3, 0xB40               # read captured timestamp
            sw      t3, 4(t0)               # store timestamp
            jr      ra                      # return 

isr_1:      la a1, 0x1337                   # load magic number, let's see what this does
            jr      ra                      # return

            .data
.toggled:   .word   0x0                     # state
            .word   0x0                     # time-stamp
