#!/bin/bash
elf2mem -f $1
        
cd ..
make verilate
make simv
make wave
        