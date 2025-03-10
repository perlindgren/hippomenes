.option  norvc
.text
.section .init
# EXPECTED BEHAVIOR:
#LED 1 turns on
init:   la      sp, _stack_start        # set stack pointer

main:   csrwi 0x0, 1 # led 1
        csrwi 0x4FF, 0
        csrwi 0x0, 2 # led 2
loop:   j loop 
.rodata

