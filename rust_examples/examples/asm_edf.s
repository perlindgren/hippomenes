            .option  norvc
            .text
            .section .init
# EDF module sanity check
# Expected behavior:
# the .winner signal of the EDF module should start at 0, move to 1 for a couple of cycles
# then settle at 2
init:       la      sp, _stack_start        # set stack pointer
main:       csrwi   0x300, 8                # enable global interrupts
            li      t1, 0x1000100           # example deadline
            csrw    0x08A, t1               # write the deadline to interrupt 1 cfg
            li      t1, 0x1000010           # short deadline, should beat interrupt 1
            csrw    0x08B, t1               # write the deadline to interrupt 2 cfg 
            li      t1, 0x1010001           # this is way off in the future, should not affect current winner
            csrw    0x08C, t1               # write to interrupt 3
            li      t1, 0x0000001           # low deadline, but not pending
            csrw    0x08D, t1               # write to interrupt 4
            nop
            nop
            nop
stop:       
            csrci 0x0, 1                    # turn led off
            j       stop                    # wait for interrupt

isr_1:      
            csrsi 0x0, 1                    # turn led on
            jr ra

.rodata
