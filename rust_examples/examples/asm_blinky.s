            .option  norvc
            .text
            .section .init
init:       la      sp, _stack_start        # set stack pointer
           
main:       csrwi   0x0, 0b1111  # leds-on
            csrwi   0x0, 0b0000  # leds-off 
            j       main

data:       .data
