            .option  norvc
            .text
            .section .init
# This tests that the one instruction ISR corner case works.
# Should be run in conjunction with another interrupt test to make sure interrupts are actually working
# EXPECTED BEHAVIOR:
# The timer interrupt keeps returning as expected, and the LED is PWM at a 33% duty cycle, it lights up like 
# asm_blinky.
init:       la      sp, _stack_start        # set stack pointer
            la      t0, toggled 
            sw      zero, 0(t0)
main:       csrwi   0x300, 8                # enable global interrupts
            la      t1, isr_0
            srl     t1, t1, 2
            csrw    0xB00, t1               # setup isr_0 address
            li      t2, 0b11110000          # interrupt every 16 cycles, cmp value 0b1111 = 15, prescaler 0b0000                                           
            csrw    0x400, t2               # timer.counter_top CSR
            la t1,  0b1110                  # prio 0b11, enable, 0b1, pend 0b0
            csrw    0xB20, t1
            nop
            nop
            nop
stop:       
            csrsi 0x0, 1                   # blink LED to prove interrupt has returned
            csrci 0x0, 1
            j       stop                    # wait for interrupt

isr_0:      jr ra
            .rodata
toggled:    .word   0x0                     # state
            .word   0x0                     # time-stamp
