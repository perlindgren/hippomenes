:: Just do "run.cmd your_rust_program_here"
echo off 
set arg1=%1
cd ..\rust_examples\
cargo build --example %1 --release
if %errorlevel% neq 0 exit /b %errorlevel%
elf2mem -f ./target/riscv32i-unknown-none-elf/release/examples/%1
cd ..\fpga
program_arty.cmd
