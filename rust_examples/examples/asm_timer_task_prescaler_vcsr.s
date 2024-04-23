            .option  norvc
            .text
            .section .init
# EXPECTED BEHAVIOR:
# The interrupt blinks the LED at a ~1s period (@20MHz)
init:       la      sp, _stack_start        # set stack pointer
            la      t0, toggled 
            sw      zero, 0(t0)
main:       csrwi   0x300, 8                # enable global interrupts
            la      t1, isr_0
            srl     t1, t1, 2
            csrw    0xB00, t1               # setup isr_0 address
            # setup VCSR
            # point to 0x400, bit offset 14, width 5
            li t3, 0b1000000000001110101 
            # write config to VCSR0_CFG
            csrw    0x100, t3
            # write prescaler (14) directly to timer config
            csrwi    0x400, 0b1110               # timer
            # now write cmp value via VCSR0: 1 at bit 14 gives cmp value 512 (bits 5:0 are prescaler)
            # 512*2^14 ~ 8.4M, yields ~2.38 Hz at 20MHz
            csrwi   0x110, 1

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

            .rodata
toggled:    .word   0x0                     # state
            .word   0x0                     # time-stamp
