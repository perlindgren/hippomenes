# Changelog

2024-04-25 Version 0.2.0

- Data memory is now implemented as Block RAM, improving the size, performance, and workflow ergonomics. [Issue #15](https://github.com/perlindgren/hippomenes/issues/15)
- Added UART peripheral implementing the NCOBS protocol [Issue #14](https://github.com/perlindgren/hippomenes/issues/14)
- Added VCSR [Issue #17](https://github.com/perlindgren/hippomenes/issues/17)
- Added support for Zmmul extension [Issue #12](https://github.com/perlindgren/hippomenes/issues/12)
- Bug fixes to decoder and ALU touching the SUB instruction
- Ergonomics improvement to programming workflow
- Additional examples

2024-03-12 Version 0.1.0

Initial release. HDL design of RISC-V RT featuring
- N-CLIC
- Hardware time-stamping for all interrupt sources using a single monotonic timer
- CRS based peripherals
  - Timer peripheral with configurable precision
  - Example Led GPIO
