.option  norvc
.text
.section .init
# EXPECTED BEHAVIOR:
# Timer interrupt occurs every ~0.75s at 20 MHz, prints "Timer" to UART
# Timer ISR gets preempted between the printing of 'i' and 'm' by a software interrupt
# which prints "Software" to UART.

init:       la      sp, _stack_start        # set stack pointer

main:       csrwi   0x300, 8                # enable global interrupts
            la      t1, isr_0
            srl     t1, t1, 2
            csrw    0xB00, t1               # setup interrupt 0 (timer interrupt) service routine address
            la      t1, isr_1
            srl     t1, t1, 2
            csrw    0xB01, t1               # setup interrupt 1 service routine address
            # setup VCSR
            # point to 0x400, bit offset 14, width 5
            li t3, 0b100000000000111000101
            # write config to VCSR0_CFG
            csrw    0x100, t3
            # write prescaler (14) directly to timer config
            csrwi    0x400, 0b1110               # timer
            # now write cmp value via VCSR0: 1 at bit 14 gives cmp value 512 (bits 5:0 are prescaler)
            # 512*2^15 ~ 16.8M, yields ~0.75Hz at 20MHz
            csrwi   0x110, 1

            li t1,  0b0110                  # prio 0b1, enable, 0b1, pend 0b0
            csrw    0xB20, t1               # write to timer interrupt (interrupt 0)
            li t1,  0b1110                  # prio 0b11, enable 0b1, pend 0b0
            csrw    0xB21, t1               # write to interrupt 1
stop:       j       stop                    # wait for interrupt

isr_0:
            la t2, timer_string             # load address to timer interrupt string
            li s0, 0x6D                     # 'm'
isr_0_loop: lb t1, 0(t2)                    # load current char
            bne t1, s0, skip                # if we are on 'm', pend the SW interrupt (should preempt), else skip
            csrwi 0xB21, 0b1111             # set pending bit
            nop
skip:       beqz t1, isr_0_exit             # if current char is 0, exit ISR
            csrw 0x51, t1                   # else write it to UART
            addi t2, t2, 1                  # increment the pointer by 1
            j isr_0_loop                    # and repeat
isr_0_exit: jr      ra                      # return


isr_1:
            la t4, sw_isr_string            # load address to sw interrupt string
isr_1_loop: lb t3, 0(t4)
            beqz t3, isr_1_exit
            csrw 0x51, t3
            addi t4, t4, 1
            j isr_1_loop
isr_1_exit: jr ra

.rodata

timer_string: .string "Timer"
sw_isr_string: .string "Software"
