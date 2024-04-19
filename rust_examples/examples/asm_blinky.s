            .option  norvc
.text
.section .init
# EXPECTED BEHAVIOR:
# LED 4 is PWM at 33% duty cycle, 
# i.e. it lights up quite faintly
init:       la      sp, _stack_start        # set stack pointer

main:   csrsi 0x0, 1 # led on
        csrci 0x0, 1 # led off
        j main 
.rodata
