warning: unused import: `hippomenes_core::Peripherals`
 --> examples/rust_blinky.rs:5:5
  |
5 | use hippomenes_core::Peripherals;
  |     ^^^^^^^^^^^^^^^^^^^^^^^^^^^^
  |
  = note: `#[warn(unused_imports)]` on by default

warning: unused import: `hippomenes_core::OutputPin`
 --> examples/rust_blinky.rs:8:5
  |
8 | use hippomenes_core::OutputPin; // trait
  |     ^^^^^^^^^^^^^^^^^^^^^^^^^^

warning: 2 warnings emitted


rust_blinky:	file format elf32-littleriscv

Disassembly of section .text:

00000000 <_start>:
;     loop {}
       0: 97 11 00 50  	auipc	gp, 327681
       4: 93 81 01 80  	addi	gp, gp, -2048

00000008 <.Lpcrel_hi1>:
       8: 17 13 00 50  	auipc	t1, 327681
       c: 13 03 83 ff  	addi	t1, t1, -8
      10: 13 71 03 ff  	andi	sp, t1, -16

00000014 <.Lpcrel_hi2>:
      14: 97 02 00 50  	auipc	t0, 327680
      18: 93 82 c2 fe  	addi	t0, t0, -20

0000001c <.Lpcrel_hi3>:
      1c: 97 03 00 50  	auipc	t2, 327680
      20: 93 83 43 fe  	addi	t2, t2, -28

00000024 <.Lpcrel_hi4>:
      24: 17 03 00 50  	auipc	t1, 327680
      28: 13 03 c3 fd  	addi	t1, t1, -36
      2c: 63 fc 72 00  	bgeu	t0, t2, 0x44 <.Lline_table_start0+0x44>
      30: 03 2e 03 00  	lw	t3, 0(t1)
      34: 13 03 43 00  	addi	t1, t1, 4
      38: 23 a0 c2 01  	sw	t3, 0(t0)
      3c: 93 82 42 00  	addi	t0, t0, 4
      40: e3 e8 72 fe  	bltu	t0, t2, 0x30 <.Lline_table_start0+0x30>

00000044 <.Lpcrel_hi5>:
      44: 97 02 00 50  	auipc	t0, 327680
      48: 93 82 c2 fb  	addi	t0, t0, -68

0000004c <.Lpcrel_hi6>:
      4c: 97 03 00 50  	auipc	t2, 327680
      50: 93 83 43 fb  	addi	t2, t2, -76
      54: 63 f8 72 00  	bgeu	t0, t2, 0x64 <.Lline_table_start0+0x5>
      58: 23 a0 02 00  	sw	zero, 0(t0)
      5c: 93 82 42 00  	addi	t0, t0, 4
      60: e3 ec 72 fe  	bltu	t0, t2, 0x58 <.Lline_table_start0+0x58>
      64: 97 00 00 00  	auipc	ra, 0
      68: e7 80 40 01  	jalr	20(ra)
      6c: 6f 00 80 00  	j	0x74 <.Lline_table_start0+0x15>

00000070 <DefaultHandler>:
      70: 6f 00 00 00  	j	0x70 <.Lline_table_start0+0x11>

00000074 <main>:
;     loop {}
      74: 6f 00 00 00  	j	0x74 <.Lline_table_start0+0x15>

00000078 <_setup_interrupts>:
;     write_csr_as!(0xB00);
      78: 37 05 00 00  	lui	a0, 0
      7c: 13 05 c5 0a  	addi	a0, a0, 172
      80: 13 55 25 00  	srli	a0, a0, 2
      84: f3 15 05 b0  	csrrw	a1, mcycle, a0
;     write_csr_as!(0xB01);
      88: 37 05 00 00  	lui	a0, 0
      8c: 13 05 c5 0a  	addi	a0, a0, 172
      90: 13 55 25 00  	srli	a0, a0, 2
      94: f3 15 15 b0  	csrrw	a1, 2817, a0
;     write_csr_as!(0xB02);
      98: 37 05 00 00  	lui	a0, 0
      9c: 13 05 c5 0a  	addi	a0, a0, 172
      a0: 13 55 25 00  	srli	a0, a0, 2
      a4: f3 15 25 b0  	csrrw	a1, minstret, a0
; }
      a8: 67 80 00 00  	ret

000000ac <Interrupt2>:
;     loop {}
      ac: 6f 00 00 00  	j	0xac <.Lline_table_start0+0x4d>
