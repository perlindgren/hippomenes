            .option  norvc
            .text
            .section .init

init:       la      sp, _stack_start        # set stack pointer
           
main:       csrwi   0x0, 1  # led-on
            csrwi   0x0, 0  # led-off
            csrwi   0x0, 0  # led-off
            csrwi   0x0, 0  # led-off
            csrwi   0x0, 0  # led-off
            csrwi   0x0, 0  # led-off
            csrwi   0x0, 0  # led-off
            j       main

data:       .data
