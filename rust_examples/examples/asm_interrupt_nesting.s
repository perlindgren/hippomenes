            .option  norvc
            .text
            .section .init
# EXPECTED BEHAVIOR:
# The interrupt handler should PWM the LED at about 50% duty cycle,
# the LED glows accordingly.
init:       la      sp, _stack_start        # set stack pointer
            la      t0, toggled 
            sw      zero, 0(t0)
main:       csrwi   0x300, 8                # enable global interrupts
            la      t1, isr_0
            la      t2, isr_1
            srl     t1, t1, 2
            srl     t2, t2, 2
            la      t3, exception
            csrw    0xB00, t1               # setup isr_0 address
            csrw    0xB01, t2
            csrw    0xB09, t3
            li      t2, 0b11110000          # interrupt every 16 cycles, cmp value 0b1111 = 15, prescaler 0b0000                                           
            csrw    0x400, t2               # timer.counter_top CSR
            la t1,  0b0110                  # prio 0b01, enable, 0b1, pend 0b0
            la t2,  0b1010                  # prio 0b10, enable 0b1, pend 0b0
            csrw    0xB21, t2
            csrw    0xB20, t1
            nop
            nop
            nop
stop:       j       stop                    # wait for interrupt

isr_0:      la      t0, toggled             # &static mut toggled state
            lw      t1, 0(t0)               # deref toggled
            xori    t1, t1, 1               # toggle bit 0
            csrw    0x0, t1                 # set bit 0 (t1 = 1) in GPIO CSR (LED on/off)
            csrwi  0x347, 3
            sw      t1, 0(t0)               # store toggled value
            csrsi   0xB21, 1                # pend interrupt 1
            jr      ra                      # return 

isr_1:      nop
            nop
            jr ra

            .rodata
toggled:    .word   0x0                     # state
            .word   0x0                     # time-stamp

exception:
    j exception