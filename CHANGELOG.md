# Changelog

Staging:

- Fixes to decoder and ALU involving SUB
- Improvements to Rust based examples crate
    - Now uses the same linker script for both Asm and Rust
    - Now uses the newest version of Elf2Mem
    - Additional examples

2024-03-12 Version 0.1.0

Initial release. HDL design of RISC-V RT featuring
- N-CLIC
- Hardware time-stamping for all interrupt sources using a single monotonic timer
- CRS based peripherals
  - Timer peripheral with configurable precision
  - Example Led GPIO
