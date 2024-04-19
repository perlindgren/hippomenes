            .option  norvc
            .text
            .section .init
# EXPECTED BEHAVIOR:
# LED 4 is PWM at a very low duty cycle,
# i.e. lights up very faintly
init:       la      sp, _stack_start        # set stack pointer
           
main:       csrwi   0x0, 1  # led-on
            csrwi   0x0, 0  # led-off
            csrwi   0x0, 0  # led-off
            csrwi   0x0, 0  # led-off
            csrwi   0x0, 0  # led-off
            csrwi   0x0, 0  # led-off
            csrwi   0x0, 0  # led-off
            j       main

.rodata
