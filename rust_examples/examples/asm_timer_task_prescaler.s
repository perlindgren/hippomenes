            .option  norvc
            .text
            .section .init

init:       la      sp, _stack_start        # set stack pointer
            la      t0, toggled 
            sw      zero, 0(t0)
main:       csrwi   0x300, 8                # enable global interrupts
            la      t1, isr_0
            srl     t1, t1, 2
            csrw    0xB00, t1               # setup isr_0 address
            #li      t2, 0b1000001010    # interrupt every 1024 << 10 cycles ~ 10_000_000 ~ 0.5Hz  
            li      t2,  0b100000000001110 #interrupt every 1048 << 14 cycles ~ 20MHz/16.7Mhz = 1.19 Hz 
            csrw    0x400, t2               # timer.counter_top CSR
            la t1,  0b1110                  # prio 0b11, enable, 0b1, pend 0b0
            csrw    0xB20, t1
stop:       j       stop                    # wait for interrupt

isr_0:      la      t0, toggled             # &static mut toggled state
            lw      t1, 0(t0)               # deref toggled
            xori    t1, t1, 1               # toggle bit 0
            csrw    0x0, t1                 # set bit 0 (t1 = 1) in GPIO CSR (LED on/off)
            sw      t1, 0(t0)               # store toggled value
            csrr    t3, 0xB40               # read captured timestamp
            sw      t3, 4(t0)               # store timestamp
            jr      ra                      # return 

            .data
toggled:    .word   0x0                     # state
            .word   0x0                     # time-stamp
