warning: unused variable: `app`
   --> /home/pawel/hippomenes/rtic/rtic-macros/src/codegen/bindings/riscvclic.rs:184:9
    |
184 |         app: &App,
    |         ^^^ help: if this is intentional, prefix it with an underscore: `_app`
    |
    = note: `#[warn(unused_variables)]` on by default

warning: unused variable: `analysis`
   --> /home/pawel/hippomenes/rtic/rtic-macros/src/codegen/bindings/riscvclic.rs:185:9
    |
185 |         analysis: &CodegenAnalysis,
    |         ^^^^^^^^ help: if this is intentional, prefix it with an underscore: `_analysis`

warning: unused variable: `dispatcher_name`
   --> /home/pawel/hippomenes/rtic/rtic-macros/src/codegen/bindings/riscvclic.rs:186:9
    |
186 |         dispatcher_name: Ident,
    |         ^^^^^^^^^^^^^^^ help: if this is intentional, prefix it with an underscore: `_dispatcher_name`

warning: unused variable: `lt`
   --> /home/pawel/hippomenes/rtic/rtic-macros/src/codegen/module.rs:106:9
    |
106 |     let lt = if ctxt.has_shared_resources(app) {
    |         ^^ help: if this is intentional, prefix it with an underscore: `_lt`

warning: 4 warnings emitted

warning: unused variable: `priority`
  --> /home/pawel/hippomenes/rtic/rtic/src/export/riscv_clic.rs:11:15
   |
11 | pub fn run<F>(priority: u8, f: F)
   |               ^^^^^^^^ help: if this is intentional, prefix it with an underscore: `_priority`
   |
   = note: `#[warn(unused_variables)]` on by default

warning: unused variable: `int`
  --> /home/pawel/hippomenes/rtic/rtic/src/export/riscv_clic.rs:80:27
   |
80 | pub fn pend<T: Interrupt>(int: T) {
   |                           ^^^ help: if this is intentional, prefix it with an underscore: `_int`

warning: unused variable: `int`
  --> /home/pawel/hippomenes/rtic/rtic/src/export/riscv_clic.rs:85:29
   |
85 | pub fn unpend<T: Interrupt>(int: T) {
   |                             ^^^ help: if this is intentional, prefix it with an underscore: `_int`

warning: unused variable: `int`
  --> /home/pawel/hippomenes/rtic/rtic/src/export/riscv_clic.rs:89:29
   |
89 | pub fn enable<T: Interrupt>(int: T, prio: u8) {
   |                             ^^^ help: if this is intentional, prefix it with an underscore: `_int`

warning: 4 warnings emitted

warning: fields `pin`, `timer`, and `rate` are never read
  --> /home/pawel/hippomenes/hippomenes-core/hippomenes-hal/src/lib.rs:15:5
   |
14 | pub struct UART<T> {
   |            ---- fields in this struct
15 |     pin: T,
   |     ^^^
16 |     timer: Timer,
   |     ^^^^^
17 |     rate: u32,
   |     ^^^^
   |
   = note: `#[warn(dead_code)]` on by default

warning: 1 warning emitted

warning: unused imports: `Pin0`, `Pin`
 --> examples/uart.rs:8:27
  |
8 |     use hippomenes_core::{Pin, Pin0};
  |                           ^^^  ^^^^
  |
  = note: `#[warn(unused_imports)]` on by default

warning: field `dummy` is never read
  --> examples/uart.rs:12:9
   |
12 |         dummy: bool,
   |         ^^^^^
...
19 |     fn init(cx: init::Context) -> (Shared, Local) {
   |                                    ------ field in this struct
   |
   = note: `#[warn(dead_code)]` on by default

warning: 2 warnings emitted


uart:	file format elf32-littleriscv

Disassembly of section .text:

00000000 <_start>:
       0: 97 11 00 50  	auipc	gp, 327681
       4: 93 81 c1 96  	addi	gp, gp, -1684

00000008 <.Lpcrel_hi1>:
       8: 17 43 00 50  	auipc	t1, 327684
       c: 13 03 83 ff  	addi	t1, t1, -8
      10: 13 71 03 ff  	andi	sp, t1, -16

00000014 <.Lpcrel_hi2>:
      14: 97 02 00 50  	auipc	t0, 327680
      18: 93 82 82 15  	addi	t0, t0, 344

0000001c <.Lpcrel_hi3>:
      1c: 97 03 00 50  	auipc	t2, 327680
      20: 93 83 43 15  	addi	t2, t2, 340

00000024 <.Lpcrel_hi4>:
      24: 17 03 00 50  	auipc	t1, 327680
      28: 13 03 83 14  	addi	t1, t1, 328
      2c: 63 fc 72 00  	bgeu	t0, t2, 0x44 <.Lline_table_start0+0x44>
      30: 03 2e 03 00  	lw	t3, 0(t1)
      34: 13 03 43 00  	addi	t1, t1, 4
      38: 23 a0 c2 01  	sw	t3, 0(t0)
      3c: 93 82 42 00  	addi	t0, t0, 4
      40: e3 e8 72 fe  	bltu	t0, t2, 0x30 <.Lline_table_start0+0x30>

00000044 <.Lpcrel_hi5>:
      44: 97 02 00 50  	auipc	t0, 327680
      48: 93 82 c2 12  	addi	t0, t0, 300

0000004c <.Lpcrel_hi6>:
      4c: 97 03 00 50  	auipc	t2, 327680
      50: 93 83 83 13  	addi	t2, t2, 312
      54: 63 f8 72 00  	bgeu	t0, t2, 0x64 <.Lline_table_start0+0x64>
      58: 23 a0 02 00  	sw	zero, 0(t0)
      5c: 93 82 42 00  	addi	t0, t0, 4
      60: e3 ec 72 fe  	bltu	t0, t2, 0x58 <.Lline_table_start0+0x58>
      64: 97 00 00 00  	auipc	ra, 0
      68: e7 80 00 1b  	jalr	432(ra)
      6c: 6f 00 c0 00  	j	0x78 <.Lline_table_start0+0x78>

00000070 <DefaultHandler>:
      70: 6f 00 00 00  	j	0x70 <.Lline_table_start0+0x70>

00000074 <rust_begin_unwind>:
      74: 6f 00 00 00  	j	0x74 <.Lline_table_start0+0x74>

00000078 <main>:
      78: 13 01 01 ff  	addi	sp, sp, -16
      7c: 23 26 11 00  	sw	ra, 12(sp)
      80: 13 05 80 00  	li	a0, 8
      84: 73 30 05 30  	csrc	mstatus, a0
      88: 97 00 00 00  	auipc	ra, 0
      8c: e7 80 c0 00  	jalr	12(ra)
      90: 6f 00 00 00  	j	0x90 <.Lline_table_start0+0x90>

00000094 <uart::app::main::__rtic_init_resources::hf6760553ed5ad4b7>:
      94: 37 05 00 50  	lui	a0, 327680
      98: 93 05 40 06  	li	a1, 100
      9c: 23 20 b5 18  	sw	a1, 384(a0)
      a0: 73 70 01 b2  	csrci	2848, 2
      a4: 93 05 c0 01  	li	a1, 28
      a8: 73 a0 05 b2  	csrs	2848, a1
      ac: 03 25 05 18  	lw	a0, 384(a0)
      b0: 13 15 45 00  	slli	a0, a0, 4
      b4: f3 15 05 40  	csrrw	a1, 1024, a0
      b8: 37 05 00 50  	lui	a0, 327680
      bc: 93 05 10 00  	li	a1, 1
      c0: 23 06 b5 16  	sb	a1, 364(a0)
      c4: 37 05 00 50  	lui	a0, 327680
      c8: 93 05 05 17  	addi	a1, a0, 368
      cc: 13 06 70 03  	li	a2, 55
      d0: a3 83 c5 00  	sb	a2, 7(a1)
      d4: 13 06 60 03  	li	a2, 54
      d8: 23 83 c5 00  	sb	a2, 6(a1)
      dc: 13 06 50 03  	li	a2, 53
      e0: a3 82 c5 00  	sb	a2, 5(a1)
      e4: 13 06 40 03  	li	a2, 52
      e8: 23 82 c5 00  	sb	a2, 4(a1)
      ec: 13 06 30 03  	li	a2, 51
      f0: a3 81 c5 00  	sb	a2, 3(a1)
      f4: 13 06 20 03  	li	a2, 50
      f8: 23 81 c5 00  	sb	a2, 2(a1)
      fc: 13 06 10 03  	li	a2, 49
     100: a3 80 c5 00  	sb	a2, 1(a1)
     104: 93 05 00 03  	li	a1, 48
     108: 23 08 b5 16  	sb	a1, 368(a0)
     10c: 37 05 00 50  	lui	a0, 327680
     110: 23 2c 05 16  	sw	zero, 376(a0)
     114: 37 05 00 50  	lui	a0, 327680
     118: 23 2e 05 16  	sw	zero, 380(a0)
     11c: 73 60 01 b2  	csrsi	2848, 2
     120: 13 05 80 00  	li	a0, 8
     124: 73 20 05 30  	csrs	mstatus, a0
     128: 67 80 00 00  	ret

0000012c <Interrupt0>:
     12c: 37 05 00 50  	lui	a0, 327680
     130: 83 45 c5 16  	lbu	a1, 364(a0)
     134: 63 80 05 02  	beqz	a1, 0x154 <.Lline_table_start0+0x154>
     138: 73 f0 00 00  	csrci	0, 1
     13c: b7 05 00 50  	lui	a1, 327680
     140: 83 a5 05 18  	lw	a1, 384(a1)
     144: 23 06 05 16  	sb	zero, 364(a0)
     148: 93 95 45 00  	slli	a1, a1, 4
     14c: 73 95 05 40  	csrrw	a0, 1024, a1
     150: 67 80 00 00  	ret
     154: 37 05 00 50  	lui	a0, 327680
     158: 83 25 c5 17  	lw	a1, 380(a0)
     15c: 13 06 80 00  	li	a2, 8
     160: 63 92 c5 04  	bne	a1, a2, 0x1a4 <.Lline_table_start0+0x1a4>
     164: 73 e0 00 00  	csrsi	0, 1
     168: 37 05 00 50  	lui	a0, 327680
     16c: 83 25 85 17  	lw	a1, 376(a0)
     170: 37 06 00 50  	lui	a2, 327680
     174: 93 06 10 00  	li	a3, 1
     178: 13 07 70 00  	li	a4, 7
     17c: 23 06 d6 16  	sb	a3, 364(a2)
     180: 63 f2 e5 06  	bgeu	a1, a4, 0x1e4 <.Lline_table_start0+0x1e4>
     184: 93 85 15 00  	addi	a1, a1, 1
     188: 23 2c b5 16  	sw	a1, 376(a0)
     18c: 37 05 00 50  	lui	a0, 327680
     190: 23 2e 05 16  	sw	zero, 380(a0)
     194: 37 75 02 00  	lui	a0, 39
     198: 13 05 05 10  	addi	a0, a0, 256
     19c: f3 15 05 40  	csrrw	a1, 1024, a0
     1a0: 67 80 00 00  	ret
     1a4: 37 05 00 50  	lui	a0, 327680
     1a8: 03 25 85 17  	lw	a0, 376(a0)
     1ac: 63 7a c5 04  	bgeu	a0, a2, 0x200 <.Lline_table_start0+0x200>
     1b0: 37 06 00 50  	lui	a2, 327680
     1b4: 13 06 06 17  	addi	a2, a2, 368
     1b8: 33 05 a6 00  	add	a0, a2, a0
     1bc: 03 45 05 00  	lbu	a0, 0(a0)
     1c0: 13 f6 75 00  	andi	a2, a1, 7
     1c4: 33 55 c5 00  	srl	a0, a0, a2
     1c8: 13 75 15 00  	andi	a0, a0, 1
     1cc: 93 85 15 00  	addi	a1, a1, 1
     1d0: 37 06 00 50  	lui	a2, 327680
     1d4: 23 2e b6 16  	sw	a1, 380(a2)
     1d8: 63 00 05 02  	beqz	a0, 0x1f8 <.Lline_table_start0+0x1f8>
     1dc: 73 e0 00 00  	csrsi	0, 1
     1e0: 67 80 00 00  	ret
     1e4: 23 2c 05 16  	sw	zero, 376(a0)
     1e8: 37 05 00 50  	lui	a0, 327680
     1ec: 23 2e 05 16  	sw	zero, 380(a0)
     1f0: 73 70 01 b2  	csrci	2848, 2
     1f4: 67 80 00 00  	ret
     1f8: 73 f0 00 00  	csrci	0, 1
     1fc: 67 80 00 00  	ret
     200: b7 05 00 50  	lui	a1, 327680
     204: 13 86 05 04  	addi	a2, a1, 64
     208: 93 05 80 00  	li	a1, 8
     20c: 97 00 00 00  	auipc	ra, 0
     210: e7 80 40 0b  	jalr	180(ra)

00000214 <_setup_interrupts>:
     214: 37 05 00 00  	lui	a0, 0
     218: 13 05 c5 12  	addi	a0, a0, 300
     21c: 13 55 25 00  	srli	a0, a0, 2
     220: f3 15 05 b0  	csrrw	a1, mcycle, a0
     224: 37 05 00 00  	lui	a0, 0
     228: 13 05 85 24  	addi	a0, a0, 584
     22c: 13 55 25 00  	srli	a0, a0, 2
     230: f3 15 15 b0  	csrrw	a1, 2817, a0
     234: 37 05 00 00  	lui	a0, 0
     238: 13 05 85 24  	addi	a0, a0, 584
     23c: 13 55 25 00  	srli	a0, a0, 2
     240: f3 15 25 b0  	csrrw	a1, minstret, a0
     244: 67 80 00 00  	ret

00000248 <Interrupt2>:
     248: 6f 00 00 00  	j	0x248 <.Lline_table_start0+0x248>

0000024c <core::ptr::drop_in_place<core::fmt::Error>::heeee8b9450240777>:
     24c: 67 80 00 00  	ret

00000250 <<T as core::any::Any>::type_id::h2f0dbd42483f0e1c>:
     250: b7 d5 77 58  	lui	a1, 362365
     254: 93 85 f5 4b  	addi	a1, a1, 1215
     258: 23 26 b5 00  	sw	a1, 12(a0)
     25c: b7 f5 6b 91  	lui	a1, 595647
     260: 93 85 b5 34  	addi	a1, a1, 843
     264: 23 24 b5 00  	sw	a1, 8(a0)
     268: b7 d5 88 85  	lui	a1, 546957
     26c: 93 85 85 6a  	addi	a1, a1, 1704
     270: 23 22 b5 00  	sw	a1, 4(a0)
     274: b7 35 ec 8d  	lui	a1, 581315
     278: 93 85 15 1b  	addi	a1, a1, 433
     27c: 23 20 b5 00  	sw	a1, 0(a0)
     280: 67 80 00 00  	ret

00000284 <core::panicking::panic_fmt::h2fd2ec5d5d8b7281>:
     284: 13 01 01 fe  	addi	sp, sp, -32
     288: 23 2e 11 00  	sw	ra, 28(sp)
     28c: 37 06 00 50  	lui	a2, 327680
     290: 13 06 06 07  	addi	a2, a2, 112
     294: 23 24 c1 00  	sw	a2, 8(sp)
     298: 37 06 00 50  	lui	a2, 327680
     29c: 13 06 06 07  	addi	a2, a2, 112
     2a0: 23 26 c1 00  	sw	a2, 12(sp)
     2a4: 23 28 a1 00  	sw	a0, 16(sp)
     2a8: 23 2a b1 00  	sw	a1, 20(sp)
     2ac: 13 05 10 00  	li	a0, 1
     2b0: 23 1c a1 00  	sh	a0, 24(sp)
     2b4: 13 05 81 00  	addi	a0, sp, 8
     2b8: 97 00 00 00  	auipc	ra, 0
     2bc: e7 80 c0 db  	jalr	-580(ra)

000002c0 <core::panicking::panic_bounds_check::h21f1f332d5788ef2>:
     2c0: 13 01 01 fc  	addi	sp, sp, -64
     2c4: 23 2e 11 02  	sw	ra, 60(sp)
     2c8: 23 26 a1 00  	sw	a0, 12(sp)
     2cc: 23 28 b1 00  	sw	a1, 16(sp)
     2d0: 13 05 01 01  	addi	a0, sp, 16
     2d4: 23 26 a1 02  	sw	a0, 44(sp)
     2d8: 37 15 00 00  	lui	a0, 1
     2dc: 13 05 85 ba  	addi	a0, a0, -1112
     2e0: 23 28 a1 02  	sw	a0, 48(sp)
     2e4: 93 05 c1 00  	addi	a1, sp, 12
     2e8: 23 2a b1 02  	sw	a1, 52(sp)
     2ec: 23 2c a1 02  	sw	a0, 56(sp)
     2f0: 37 05 00 50  	lui	a0, 327680
     2f4: 13 05 45 09  	addi	a0, a0, 148
     2f8: 23 2a a1 00  	sw	a0, 20(sp)
     2fc: 13 05 20 00  	li	a0, 2
     300: 23 2c a1 00  	sw	a0, 24(sp)
     304: 23 22 01 02  	sw	zero, 36(sp)
     308: 93 05 c1 02  	addi	a1, sp, 44
     30c: 23 2e b1 00  	sw	a1, 28(sp)
     310: 23 20 a1 02  	sw	a0, 32(sp)
     314: 13 05 41 01  	addi	a0, sp, 20
     318: 93 05 06 00  	mv	a1, a2
     31c: 97 00 00 00  	auipc	ra, 0
     320: e7 80 80 f6  	jalr	-152(ra)

00000324 <core::fmt::Formatter::pad_integral::h54f440eb1409ba0b>:
     324: 13 01 01 fc  	addi	sp, sp, -64
     328: 23 2e 11 02  	sw	ra, 60(sp)
     32c: 23 2c 81 02  	sw	s0, 56(sp)
     330: 23 2a 91 02  	sw	s1, 52(sp)
     334: 23 28 21 03  	sw	s2, 48(sp)
     338: 23 26 31 03  	sw	s3, 44(sp)
     33c: 23 24 41 03  	sw	s4, 40(sp)
     340: 23 22 51 03  	sw	s5, 36(sp)
     344: 23 20 61 03  	sw	s6, 32(sp)
     348: 23 2e 71 01  	sw	s7, 28(sp)
     34c: 23 2c 81 01  	sw	s8, 24(sp)
     350: 23 2a 91 01  	sw	s9, 20(sp)
     354: 23 28 a1 01  	sw	s10, 16(sp)
     358: 23 26 b1 01  	sw	s11, 12(sp)
     35c: 13 84 07 00  	mv	s0, a5
     360: 93 04 07 00  	mv	s1, a4
     364: 93 89 06 00  	mv	s3, a3
     368: 13 0a 06 00  	mv	s4, a2
     36c: 13 09 05 00  	mv	s2, a0
     370: 63 8e 05 04  	beqz	a1, 0x3cc <.Lline_table_start0+0x160>
     374: 03 2b c9 01  	lw	s6, 28(s2)
     378: 93 7c 1b 00  	andi	s9, s6, 1
     37c: b7 0a 11 00  	lui	s5, 272
     380: 63 84 0c 00  	beqz	s9, 0x388 <.Lline_table_start0+0x11c>
     384: 93 0a b0 02  	li	s5, 43
     388: b3 8c 8c 00  	add	s9, s9, s0
     38c: 13 75 4b 00  	andi	a0, s6, 4
     390: 63 08 05 04  	beqz	a0, 0x3e0 <.Lline_table_start0+0x174>
     394: 13 05 00 01  	li	a0, 16
     398: 63 fc a9 04  	bgeu	s3, a0, 0x3f0 <.Lline_table_start0+0x184>
     39c: 13 05 00 00  	li	a0, 0
     3a0: 63 80 09 06  	beqz	s3, 0x400 <.Lline_table_start0+0x194>
     3a4: 93 05 0a 00  	mv	a1, s4
     3a8: 13 86 09 00  	mv	a2, s3
     3ac: 83 86 05 00  	lb	a3, 0(a1)
     3b0: 93 a6 06 fc  	slti	a3, a3, -64
     3b4: 93 c6 16 00  	xori	a3, a3, 1
     3b8: 33 05 d5 00  	add	a0, a0, a3
     3bc: 13 06 f6 ff  	addi	a2, a2, -1
     3c0: 93 85 15 00  	addi	a1, a1, 1
     3c4: e3 14 06 fe  	bnez	a2, 0x3ac <.Lline_table_start0+0x140>
     3c8: 6f 00 80 03  	j	0x400 <.Lline_table_start0+0x194>
     3cc: 03 2b c9 01  	lw	s6, 28(s2)
     3d0: 93 0c 14 00  	addi	s9, s0, 1
     3d4: 93 0a d0 02  	li	s5, 45
     3d8: 13 75 4b 00  	andi	a0, s6, 4
     3dc: e3 1c 05 fa  	bnez	a0, 0x394 <.Lline_table_start0+0x128>
     3e0: 13 0a 00 00  	li	s4, 0
     3e4: 03 25 09 00  	lw	a0, 0(s2)
     3e8: 63 12 05 02  	bnez	a0, 0x40c <.Lline_table_start0+0x1a0>
     3ec: 6f 00 80 04  	j	0x434 <.Lline_table_start0+0x19>
     3f0: 13 05 0a 00  	mv	a0, s4
     3f4: 93 85 09 00  	mv	a1, s3
     3f8: 97 00 00 00  	auipc	ra, 0
     3fc: e7 80 80 2f  	jalr	760(ra)
     400: b3 0c 95 01  	add	s9, a0, s9
     404: 03 25 09 00  	lw	a0, 0(s2)
     408: 63 06 05 02  	beqz	a0, 0x434 <.Lline_table_start0+0x19>
     40c: 03 2d 49 00  	lw	s10, 4(s2)
     410: 63 f2 ac 03  	bgeu	s9, s10, 0x434 <.Lline_table_start0+0x19>
     414: 13 75 8b 00  	andi	a0, s6, 8
     418: 63 1a 05 0c  	bnez	a0, 0x4ec <.Lline_table_start0+0xd1>
     41c: 03 45 09 02  	lbu	a0, 32(s2)
     420: 93 05 10 00  	li	a1, 1
     424: b3 0c 9d 41  	sub	s9, s10, s9
     428: 63 c8 a5 12  	blt	a1, a0, 0x558 <.Lline_table_start0+0x13d>
     42c: 63 12 05 14  	bnez	a0, 0x570 <.Lline_table_start0+0x155>
     430: 6f 00 80 14  	j	0x578 <.Lline_table_start0+0x15d>
     434: 83 2b 49 01  	lw	s7, 20(s2)
     438: 03 29 89 01  	lw	s2, 24(s2)
     43c: 13 85 0b 00  	mv	a0, s7
     440: 93 05 09 00  	mv	a1, s2
     444: 13 86 0a 00  	mv	a2, s5
     448: 93 06 0a 00  	mv	a3, s4
     44c: 13 87 09 00  	mv	a4, s3
     450: 97 00 00 00  	auipc	ra, 0
     454: e7 80 40 20  	jalr	516(ra)
     458: 13 0b 10 00  	li	s6, 1
     45c: 63 02 05 04  	beqz	a0, 0x4a0 <.Lline_table_start0+0x85>
     460: 13 05 0b 00  	mv	a0, s6
     464: 83 20 c1 03  	lw	ra, 60(sp)
     468: 03 24 81 03  	lw	s0, 56(sp)
     46c: 83 24 41 03  	lw	s1, 52(sp)
     470: 03 29 01 03  	lw	s2, 48(sp)
     474: 83 29 c1 02  	lw	s3, 44(sp)
     478: 03 2a 81 02  	lw	s4, 40(sp)
     47c: 83 2a 41 02  	lw	s5, 36(sp)
     480: 03 2b 01 02  	lw	s6, 32(sp)
     484: 83 2b c1 01  	lw	s7, 28(sp)
     488: 03 2c 81 01  	lw	s8, 24(sp)
     48c: 83 2c 41 01  	lw	s9, 20(sp)
     490: 03 2d 01 01  	lw	s10, 16(sp)
     494: 83 2d c1 00  	lw	s11, 12(sp)
     498: 13 01 01 04  	addi	sp, sp, 64
     49c: 67 80 00 00  	ret
     4a0: 03 23 c9 00  	lw	t1, 12(s2)
     4a4: 13 85 0b 00  	mv	a0, s7
     4a8: 93 85 04 00  	mv	a1, s1
     4ac: 13 06 04 00  	mv	a2, s0
     4b0: 83 20 c1 03  	lw	ra, 60(sp)
     4b4: 03 24 81 03  	lw	s0, 56(sp)
     4b8: 83 24 41 03  	lw	s1, 52(sp)
     4bc: 03 29 01 03  	lw	s2, 48(sp)
     4c0: 83 29 c1 02  	lw	s3, 44(sp)
     4c4: 03 2a 81 02  	lw	s4, 40(sp)
     4c8: 83 2a 41 02  	lw	s5, 36(sp)
     4cc: 03 2b 01 02  	lw	s6, 32(sp)
     4d0: 83 2b c1 01  	lw	s7, 28(sp)
     4d4: 03 2c 81 01  	lw	s8, 24(sp)
     4d8: 83 2c 41 01  	lw	s9, 20(sp)
     4dc: 03 2d 01 01  	lw	s10, 16(sp)
     4e0: 83 2d c1 00  	lw	s11, 12(sp)
     4e4: 13 01 01 04  	addi	sp, sp, 64
     4e8: 67 00 03 00  	jr	t1
     4ec: 03 25 09 01  	lw	a0, 16(s2)
     4f0: 23 24 a1 00  	sw	a0, 8(sp)
     4f4: 13 05 00 03  	li	a0, 48
     4f8: 83 4d 09 02  	lbu	s11, 32(s2)
     4fc: 83 2b 49 01  	lw	s7, 20(s2)
     500: 03 2c 89 01  	lw	s8, 24(s2)
     504: 23 28 a9 00  	sw	a0, 16(s2)
     508: 13 0b 10 00  	li	s6, 1
     50c: 23 00 69 03  	sb	s6, 32(s2)
     510: 13 85 0b 00  	mv	a0, s7
     514: 93 05 0c 00  	mv	a1, s8
     518: 13 86 0a 00  	mv	a2, s5
     51c: 93 06 0a 00  	mv	a3, s4
     520: 13 87 09 00  	mv	a4, s3
     524: 97 00 00 00  	auipc	ra, 0
     528: e7 80 00 13  	jalr	304(ra)
     52c: e3 1a 05 f2  	bnez	a0, 0x460 <.Lline_table_start0+0x45>
     530: b3 09 9d 41  	sub	s3, s10, s9
     534: 93 89 19 00  	addi	s3, s3, 1
     538: 93 89 f9 ff  	addi	s3, s3, -1
     53c: 63 80 09 0e  	beqz	s3, 0x61c <.Lline_table_start0+0x71>
     540: 03 26 0c 01  	lw	a2, 16(s8)
     544: 93 05 00 03  	li	a1, 48
     548: 13 85 0b 00  	mv	a0, s7
     54c: e7 00 06 00  	jalr	a2
     550: e3 04 05 fe  	beqz	a0, 0x538 <.Lline_table_start0+0x11d>
     554: 6f f0 df f0  	j	0x460 <.Lline_table_start0+0x45>
     558: 93 05 20 00  	li	a1, 2
     55c: 63 1a b5 00  	bne	a0, a1, 0x570 <.Lline_table_start0+0x155>
     560: 13 d5 1c 00  	srli	a0, s9, 1
     564: 93 8c 1c 00  	addi	s9, s9, 1
     568: 93 dc 1c 00  	srli	s9, s9, 1
     56c: 6f 00 c0 00  	j	0x578 <.Lline_table_start0+0x15d>
     570: 13 85 0c 00  	mv	a0, s9
     574: 93 0c 00 00  	li	s9, 0
     578: 83 2b 49 01  	lw	s7, 20(s2)
     57c: 03 2c 89 01  	lw	s8, 24(s2)
     580: 03 29 09 01  	lw	s2, 16(s2)
     584: 13 0b 15 00  	addi	s6, a0, 1
     588: 13 0b fb ff  	addi	s6, s6, -1
     58c: 63 00 0b 02  	beqz	s6, 0x5ac <.Lline_table_start0+0x1>
     590: 03 26 0c 01  	lw	a2, 16(s8)
     594: 13 85 0b 00  	mv	a0, s7
     598: 93 05 09 00  	mv	a1, s2
     59c: e7 00 06 00  	jalr	a2
     5a0: e3 04 05 fe  	beqz	a0, 0x588 <.Lline_table_start0+0x16d>
     5a4: 13 0b 10 00  	li	s6, 1
     5a8: 6f f0 9f eb  	j	0x460 <.Lline_table_start0+0x45>
     5ac: 13 85 0b 00  	mv	a0, s7
     5b0: 93 05 0c 00  	mv	a1, s8
     5b4: 13 86 0a 00  	mv	a2, s5
     5b8: 93 06 0a 00  	mv	a3, s4
     5bc: 13 87 09 00  	mv	a4, s3
     5c0: 97 00 00 00  	auipc	ra, 0
     5c4: e7 80 40 09  	jalr	148(ra)
     5c8: 13 0b 10 00  	li	s6, 1
     5cc: e3 1a 05 e8  	bnez	a0, 0x460 <.Lline_table_start0+0x45>
     5d0: 83 26 cc 00  	lw	a3, 12(s8)
     5d4: 13 85 0b 00  	mv	a0, s7
     5d8: 93 85 04 00  	mv	a1, s1
     5dc: 13 06 04 00  	mv	a2, s0
     5e0: e7 80 06 00  	jalr	a3
     5e4: e3 1e 05 e6  	bnez	a0, 0x460 <.Lline_table_start0+0x45>
     5e8: b3 04 90 41  	neg	s1, s9
     5ec: 93 09 f0 ff  	li	s3, -1
     5f0: 13 04 f0 ff  	li	s0, -1
     5f4: 33 85 84 00  	add	a0, s1, s0
     5f8: 63 08 35 05  	beq	a0, s3, 0x648 <.Lline_table_start0+0x9d>
     5fc: 03 26 0c 01  	lw	a2, 16(s8)
     600: 13 85 0b 00  	mv	a0, s7
     604: 93 05 09 00  	mv	a1, s2
     608: e7 00 06 00  	jalr	a2
     60c: 13 04 14 00  	addi	s0, s0, 1
     610: e3 02 05 fe  	beqz	a0, 0x5f4 <.Lline_table_start0+0x49>
     614: 33 3b 94 01  	sltu	s6, s0, s9
     618: 6f f0 9f e4  	j	0x460 <.Lline_table_start0+0x45>
     61c: 83 26 cc 00  	lw	a3, 12(s8)
     620: 13 85 0b 00  	mv	a0, s7
     624: 93 85 04 00  	mv	a1, s1
     628: 13 06 04 00  	mv	a2, s0
     62c: e7 80 06 00  	jalr	a3
     630: e3 18 05 e2  	bnez	a0, 0x460 <.Lline_table_start0+0x45>
     634: 13 0b 00 00  	li	s6, 0
     638: 03 25 81 00  	lw	a0, 8(sp)
     63c: 23 28 a9 00  	sw	a0, 16(s2)
     640: 23 00 b9 03  	sb	s11, 32(s2)
     644: 6f f0 df e1  	j	0x460 <.Lline_table_start0+0x45>
     648: 13 84 0c 00  	mv	s0, s9
     64c: 33 bb 9c 01  	sltu	s6, s9, s9
     650: 6f f0 1f e1  	j	0x460 <.Lline_table_start0+0x45>

00000654 <core::fmt::Formatter::pad_integral::write_prefix::hd869759600707ead>:
     654: 13 01 01 fe  	addi	sp, sp, -32
     658: 23 2e 11 00  	sw	ra, 28(sp)
     65c: 23 2c 81 00  	sw	s0, 24(sp)
     660: 23 2a 91 00  	sw	s1, 20(sp)
     664: 23 28 21 01  	sw	s2, 16(sp)
     668: 23 26 31 01  	sw	s3, 12(sp)
     66c: b7 07 11 00  	lui	a5, 272
     670: 13 04 07 00  	mv	s0, a4
     674: 93 84 06 00  	mv	s1, a3
     678: 93 89 05 00  	mv	s3, a1
     67c: 13 09 05 00  	mv	s2, a0
     680: 63 00 f6 02  	beq	a2, a5, 0x6a0 <.Lline_table_start0+0x28>
     684: 83 a6 09 01  	lw	a3, 16(s3)
     688: 13 05 09 00  	mv	a0, s2
     68c: 93 05 06 00  	mv	a1, a2
     690: e7 80 06 00  	jalr	a3
     694: 93 05 05 00  	mv	a1, a0
     698: 13 05 10 00  	li	a0, 1
     69c: 63 9c 05 02  	bnez	a1, 0x6d4 <.Lline_table_start0+0x5c>
     6a0: 63 88 04 02  	beqz	s1, 0x6d0 <.Lline_table_start0+0x58>
     6a4: 03 a3 c9 00  	lw	t1, 12(s3)
     6a8: 13 05 09 00  	mv	a0, s2
     6ac: 93 85 04 00  	mv	a1, s1
     6b0: 13 06 04 00  	mv	a2, s0
     6b4: 83 20 c1 01  	lw	ra, 28(sp)
     6b8: 03 24 81 01  	lw	s0, 24(sp)
     6bc: 83 24 41 01  	lw	s1, 20(sp)
     6c0: 03 29 01 01  	lw	s2, 16(sp)
     6c4: 83 29 c1 00  	lw	s3, 12(sp)
     6c8: 13 01 01 02  	addi	sp, sp, 32
     6cc: 67 00 03 00  	jr	t1
     6d0: 13 05 00 00  	li	a0, 0
     6d4: 83 20 c1 01  	lw	ra, 28(sp)
     6d8: 03 24 81 01  	lw	s0, 24(sp)
     6dc: 83 24 41 01  	lw	s1, 20(sp)
     6e0: 03 29 01 01  	lw	s2, 16(sp)
     6e4: 83 29 c1 00  	lw	s3, 12(sp)
     6e8: 13 01 01 02  	addi	sp, sp, 32
     6ec: 67 80 00 00  	ret

000006f0 <core::str::count::do_count_chars::h8ee695d6c36300eb>:
     6f0: 13 01 01 fd  	addi	sp, sp, -48
     6f4: 23 26 11 02  	sw	ra, 44(sp)
     6f8: 23 24 81 02  	sw	s0, 40(sp)
     6fc: 23 22 91 02  	sw	s1, 36(sp)
     700: 23 20 21 03  	sw	s2, 32(sp)
     704: 23 2e 31 01  	sw	s3, 28(sp)
     708: 23 2c 41 01  	sw	s4, 24(sp)
     70c: 23 2a 51 01  	sw	s5, 20(sp)
     710: 23 28 61 01  	sw	s6, 16(sp)
     714: 23 26 71 01  	sw	s7, 12(sp)
     718: 23 24 81 01  	sw	s8, 8(sp)
     71c: 23 22 91 01  	sw	s9, 4(sp)
     720: 93 06 35 00  	addi	a3, a0, 3
     724: 93 f6 c6 ff  	andi	a3, a3, -4
     728: 33 8c a6 40  	sub	s8, a3, a0
     72c: 63 ec 85 17  	bltu	a1, s8, 0x8a4 <.Lline_table_start0+0x22c>
     730: 33 86 85 41  	sub	a2, a1, s8
     734: 13 5a 26 00  	srli	s4, a2, 2
     738: 63 06 0a 16  	beqz	s4, 0x8a4 <.Lline_table_start0+0x22c>
     73c: 93 75 36 00  	andi	a1, a2, 3
     740: 13 04 00 00  	li	s0, 0
     744: 63 84 a6 02  	beq	a3, a0, 0x76c <.Lline_table_start0+0xf4>
     748: b3 06 d5 40  	sub	a3, a0, a3
     74c: 13 07 05 00  	mv	a4, a0
     750: 83 07 07 00  	lb	a5, 0(a4)
     754: 93 a7 07 fc  	slti	a5, a5, -64
     758: 93 c7 17 00  	xori	a5, a5, 1
     75c: 33 04 f4 00  	add	s0, s0, a5
     760: 93 86 16 00  	addi	a3, a3, 1
     764: 13 07 17 00  	addi	a4, a4, 1
     768: e3 94 06 fe  	bnez	a3, 0x750 <.Lline_table_start0+0xd8>
     76c: 33 0c 85 01  	add	s8, a0, s8
     770: 13 05 00 00  	li	a0, 0
     774: 63 84 05 02  	beqz	a1, 0x79c <.Lline_table_start0+0x124>
     778: 13 76 c6 ff  	andi	a2, a2, -4
     77c: 33 06 cc 00  	add	a2, s8, a2
     780: 83 06 06 00  	lb	a3, 0(a2)
     784: 93 a6 06 fc  	slti	a3, a3, -64
     788: 93 c6 16 00  	xori	a3, a3, 1
     78c: 33 05 d5 00  	add	a0, a0, a3
     790: 93 85 f5 ff  	addi	a1, a1, -1
     794: 13 06 16 00  	addi	a2, a2, 1
     798: e3 94 05 fe  	bnez	a1, 0x780 <.Lline_table_start0+0x108>
     79c: b7 05 01 01  	lui	a1, 4112
     7a0: 13 89 15 10  	addi	s2, a1, 257
     7a4: b7 05 ff 00  	lui	a1, 4080
     7a8: 93 89 f5 0f  	addi	s3, a1, 255
     7ac: b7 04 01 00  	lui	s1, 16
     7b0: 93 84 14 00  	addi	s1, s1, 1
     7b4: 33 04 85 00  	add	s0, a0, s0
     7b8: 6f 00 c0 03  	j	0x7f4 <.Lline_table_start0+0x17c>
     7bc: 13 9c 2b 00  	slli	s8, s7, 2
     7c0: 33 0c 8b 01  	add	s8, s6, s8
     7c4: 33 8a 7a 41  	sub	s4, s5, s7
     7c8: 93 fc 3b 00  	andi	s9, s7, 3
     7cc: 33 75 36 01  	and	a0, a2, s3
     7d0: 13 56 86 00  	srli	a2, a2, 8
     7d4: b3 75 36 01  	and	a1, a2, s3
     7d8: 33 85 a5 00  	add	a0, a1, a0
     7dc: 93 85 04 00  	mv	a1, s1
     7e0: 97 00 00 00  	auipc	ra, 0
     7e4: e7 80 c0 3d  	jalr	988(ra)
     7e8: 13 55 05 01  	srli	a0, a0, 16
     7ec: 33 04 85 00  	add	s0, a0, s0
     7f0: 63 9e 0c 0c  	bnez	s9, 0x8cc <.Lline_table_start0+0x254>
     7f4: 63 04 0a 14  	beqz	s4, 0x93c <.Lline_table_start0+0x2c4>
     7f8: 93 0a 0a 00  	mv	s5, s4
     7fc: 13 0b 0c 00  	mv	s6, s8
     800: 13 05 00 0c  	li	a0, 192
     804: 93 0b 0a 00  	mv	s7, s4
     808: 63 64 aa 00  	bltu	s4, a0, 0x810 <.Lline_table_start0+0x198>
     80c: 93 0b 00 0c  	li	s7, 192
     810: 13 06 00 00  	li	a2, 0
     814: 13 d5 2b 00  	srli	a0, s7, 2
     818: e3 02 05 fa  	beqz	a0, 0x7bc <.Lline_table_start0+0x144>
     81c: 13 15 45 00  	slli	a0, a0, 4
     820: 33 05 ab 00  	add	a0, s6, a0
     824: 93 05 0b 00  	mv	a1, s6
     828: 83 a6 05 00  	lw	a3, 0(a1)
     82c: 13 c7 f6 ff  	not	a4, a3
     830: 13 57 77 00  	srli	a4, a4, 7
     834: 93 d6 66 00  	srli	a3, a3, 6
     838: 83 a7 45 00  	lw	a5, 4(a1)
     83c: b3 66 d7 00  	or	a3, a4, a3
     840: b3 f6 26 01  	and	a3, a3, s2
     844: 33 86 c6 00  	add	a2, a3, a2
     848: 93 c6 f7 ff  	not	a3, a5
     84c: 93 d6 76 00  	srli	a3, a3, 7
     850: 03 a7 85 00  	lw	a4, 8(a1)
     854: 93 d7 67 00  	srli	a5, a5, 6
     858: b3 e6 f6 00  	or	a3, a3, a5
     85c: b3 f6 26 01  	and	a3, a3, s2
     860: 93 47 f7 ff  	not	a5, a4
     864: 93 d7 77 00  	srli	a5, a5, 7
     868: 13 57 67 00  	srli	a4, a4, 6
     86c: 33 e7 e7 00  	or	a4, a5, a4
     870: 83 a7 c5 00  	lw	a5, 12(a1)
     874: 33 77 27 01  	and	a4, a4, s2
     878: b3 06 d7 00  	add	a3, a4, a3
     87c: 33 86 c6 00  	add	a2, a3, a2
     880: 93 c6 f7 ff  	not	a3, a5
     884: 93 d6 76 00  	srli	a3, a3, 7
     888: 93 d7 67 00  	srli	a5, a5, 6
     88c: b3 e6 f6 00  	or	a3, a3, a5
     890: b3 f6 26 01  	and	a3, a3, s2
     894: 93 85 05 01  	addi	a1, a1, 16
     898: 33 86 c6 00  	add	a2, a3, a2
     89c: e3 96 a5 f8  	bne	a1, a0, 0x828 <.Lline_table_start0+0x1b0>
     8a0: 6f f0 df f1  	j	0x7bc <.Lline_table_start0+0x144>
     8a4: 13 04 00 00  	li	s0, 0
     8a8: 63 8a 05 08  	beqz	a1, 0x93c <.Lline_table_start0+0x2c4>
     8ac: 03 06 05 00  	lb	a2, 0(a0)
     8b0: 13 26 06 fc  	slti	a2, a2, -64
     8b4: 13 46 16 00  	xori	a2, a2, 1
     8b8: 33 04 c4 00  	add	s0, s0, a2
     8bc: 93 85 f5 ff  	addi	a1, a1, -1
     8c0: 13 05 15 00  	addi	a0, a0, 1
     8c4: e3 94 05 fe  	bnez	a1, 0x8ac <.Lline_table_start0+0x234>
     8c8: 6f 00 40 07  	j	0x93c <.Lline_table_start0+0x2c4>
     8cc: 13 05 00 00  	li	a0, 0
     8d0: 93 f5 cb 0f  	andi	a1, s7, 252
     8d4: 93 95 25 00  	slli	a1, a1, 2
     8d8: 33 0b bb 00  	add	s6, s6, a1
     8dc: 93 b5 0a 0c  	sltiu	a1, s5, 192
     8e0: b3 05 b0 40  	neg	a1, a1
     8e4: b3 f5 ba 00  	and	a1, s5, a1
     8e8: 93 f5 35 00  	andi	a1, a1, 3
     8ec: 93 95 25 00  	slli	a1, a1, 2
     8f0: 03 26 0b 00  	lw	a2, 0(s6)
     8f4: 13 0b 4b 00  	addi	s6, s6, 4
     8f8: 93 46 f6 ff  	not	a3, a2
     8fc: 93 d6 76 00  	srli	a3, a3, 7
     900: 13 56 66 00  	srli	a2, a2, 6
     904: 33 e6 c6 00  	or	a2, a3, a2
     908: 33 76 26 01  	and	a2, a2, s2
     90c: 93 85 c5 ff  	addi	a1, a1, -4
     910: 33 05 a6 00  	add	a0, a2, a0
     914: e3 9e 05 fc  	bnez	a1, 0x8f0 <.Lline_table_start0+0x278>
     918: b3 75 35 01  	and	a1, a0, s3
     91c: 13 55 85 00  	srli	a0, a0, 8
     920: 33 75 35 01  	and	a0, a0, s3
     924: 33 05 b5 00  	add	a0, a0, a1
     928: 93 85 04 00  	mv	a1, s1
     92c: 97 00 00 00  	auipc	ra, 0
     930: e7 80 00 29  	jalr	656(ra)
     934: 13 55 05 01  	srli	a0, a0, 16
     938: 33 04 85 00  	add	s0, a0, s0
     93c: 13 05 04 00  	mv	a0, s0
     940: 83 20 c1 02  	lw	ra, 44(sp)
     944: 03 24 81 02  	lw	s0, 40(sp)
     948: 83 24 41 02  	lw	s1, 36(sp)
     94c: 03 29 01 02  	lw	s2, 32(sp)
     950: 83 29 c1 01  	lw	s3, 28(sp)
     954: 03 2a 81 01  	lw	s4, 24(sp)
     958: 83 2a 41 01  	lw	s5, 20(sp)
     95c: 03 2b 01 01  	lw	s6, 16(sp)
     960: 83 2b c1 00  	lw	s7, 12(sp)
     964: 03 2c 81 00  	lw	s8, 8(sp)
     968: 83 2c 41 00  	lw	s9, 4(sp)
     96c: 13 01 01 03  	addi	sp, sp, 48
     970: 67 80 00 00  	ret

00000974 <core::fmt::num::imp::fmt_u32::hc69911958cd28b6c>:
     974: 13 01 01 fa  	addi	sp, sp, -96
     978: 23 2e 11 04  	sw	ra, 92(sp)
     97c: 23 2c 81 04  	sw	s0, 88(sp)
     980: 23 2a 91 04  	sw	s1, 84(sp)
     984: 23 28 21 05  	sw	s2, 80(sp)
     988: 23 26 31 05  	sw	s3, 76(sp)
     98c: 23 24 41 05  	sw	s4, 72(sp)
     990: 23 22 51 05  	sw	s5, 68(sp)
     994: 23 20 61 05  	sw	s6, 64(sp)
     998: 23 2e 71 03  	sw	s7, 60(sp)
     99c: 23 2c 81 03  	sw	s8, 56(sp)
     9a0: 23 2a 91 03  	sw	s9, 52(sp)
     9a4: 23 28 a1 03  	sw	s10, 48(sp)
     9a8: 23 26 b1 03  	sw	s11, 44(sp)
     9ac: 13 04 06 00  	mv	s0, a2
     9b0: 93 84 05 00  	mv	s1, a1
     9b4: 13 09 05 00  	mv	s2, a0
     9b8: 13 55 45 00  	srli	a0, a0, 4
     9bc: 93 05 10 27  	li	a1, 625
     9c0: 13 0a 70 02  	li	s4, 39
     9c4: 63 76 b5 02  	bgeu	a0, a1, 0x9f0 <.Lline_table_start0+0x378>
     9c8: 13 05 30 06  	li	a0, 99
     9cc: 63 62 25 0f  	bltu	a0, s2, 0xab0 <.Lline_table_start0+0x438>
     9d0: 13 05 a0 00  	li	a0, 10
     9d4: 63 70 a9 14  	bgeu	s2, a0, 0xb14 <.Lline_table_start0+0x49c>
     9d8: 13 0a fa ff  	addi	s4, s4, -1
     9dc: 13 05 51 00  	addi	a0, sp, 5
     9e0: 33 05 45 01  	add	a0, a0, s4
     9e4: 93 05 09 03  	addi	a1, s2, 48
     9e8: 23 00 b5 00  	sb	a1, 0(a0)
     9ec: 6f 00 40 15  	j	0xb40 <.Lline_table_start0+0x4c8>
     9f0: 93 0a 00 00  	li	s5, 0
     9f4: 13 0b 81 02  	addi	s6, sp, 40
     9f8: 93 0b a1 02  	addi	s7, sp, 42
     9fc: 37 25 00 00  	lui	a0, 2
     a00: 93 09 05 71  	addi	s3, a0, 1808
     a04: 37 05 00 50  	lui	a0, 327680
     a08: 13 0c 45 0a  	addi	s8, a0, 164
     a0c: 37 e5 f5 05  	lui	a0, 24414
     a10: 93 0c f5 0f  	addi	s9, a0, 255
     a14: 13 0a 09 00  	mv	s4, s2
     a18: 13 05 09 00  	mv	a0, s2
     a1c: 93 85 09 00  	mv	a1, s3
     a20: 97 00 00 00  	auipc	ra, 0
     a24: e7 80 40 2f  	jalr	756(ra)
     a28: 13 09 05 00  	mv	s2, a0
     a2c: 93 85 09 00  	mv	a1, s3
     a30: 97 00 00 00  	auipc	ra, 0
     a34: e7 80 c0 18  	jalr	396(ra)
     a38: 33 0d aa 40  	sub	s10, s4, a0
     a3c: 13 15 0d 01  	slli	a0, s10, 16
     a40: 13 55 05 01  	srli	a0, a0, 16
     a44: 93 05 40 06  	li	a1, 100
     a48: 97 00 00 00  	auipc	ra, 0
     a4c: e7 80 c0 2c  	jalr	716(ra)
     a50: 93 1d 15 00  	slli	s11, a0, 1
     a54: 93 05 40 06  	li	a1, 100
     a58: 97 00 00 00  	auipc	ra, 0
     a5c: e7 80 40 16  	jalr	356(ra)
     a60: 33 05 ad 40  	sub	a0, s10, a0
     a64: 13 15 15 01  	slli	a0, a0, 17
     a68: b3 0d bc 01  	add	s11, s8, s11
     a6c: 83 c5 1d 00  	lbu	a1, 1(s11)
     a70: 13 55 05 01  	srli	a0, a0, 16
     a74: 33 06 5b 01  	add	a2, s6, s5
     a78: 83 c6 0d 00  	lbu	a3, 0(s11)
     a7c: a3 00 b6 00  	sb	a1, 1(a2)
     a80: 33 05 ac 00  	add	a0, s8, a0
     a84: 83 45 15 00  	lbu	a1, 1(a0)
     a88: 03 45 05 00  	lbu	a0, 0(a0)
     a8c: 23 00 d6 00  	sb	a3, 0(a2)
     a90: 33 86 5b 01  	add	a2, s7, s5
     a94: a3 00 b6 00  	sb	a1, 1(a2)
     a98: 23 00 a6 00  	sb	a0, 0(a2)
     a9c: 93 8a ca ff  	addi	s5, s5, -4
     aa0: e3 ea 4c f7  	bltu	s9, s4, 0xa14 <.Lline_table_start0+0x39c>
     aa4: 13 8a 7a 02  	addi	s4, s5, 39
     aa8: 13 05 30 06  	li	a0, 99
     aac: e3 72 25 f3  	bgeu	a0, s2, 0x9d0 <.Lline_table_start0+0x358>
     ab0: 13 15 09 01  	slli	a0, s2, 16
     ab4: 13 55 05 01  	srli	a0, a0, 16
     ab8: 93 05 40 06  	li	a1, 100
     abc: 97 00 00 00  	auipc	ra, 0
     ac0: e7 80 80 25  	jalr	600(ra)
     ac4: 93 09 05 00  	mv	s3, a0
     ac8: 93 05 40 06  	li	a1, 100
     acc: 97 00 00 00  	auipc	ra, 0
     ad0: e7 80 00 0f  	jalr	240(ra)
     ad4: 33 05 a9 40  	sub	a0, s2, a0
     ad8: 13 15 15 01  	slli	a0, a0, 17
     adc: 13 55 05 01  	srli	a0, a0, 16
     ae0: 13 0a ea ff  	addi	s4, s4, -2
     ae4: b7 05 00 50  	lui	a1, 327680
     ae8: 93 85 45 0a  	addi	a1, a1, 164
     aec: 33 85 a5 00  	add	a0, a1, a0
     af0: 83 45 15 00  	lbu	a1, 1(a0)
     af4: 03 45 05 00  	lbu	a0, 0(a0)
     af8: 13 06 51 00  	addi	a2, sp, 5
     afc: 33 06 46 01  	add	a2, a2, s4
     b00: a3 00 b6 00  	sb	a1, 1(a2)
     b04: 23 00 a6 00  	sb	a0, 0(a2)
     b08: 13 89 09 00  	mv	s2, s3
     b0c: 13 05 a0 00  	li	a0, 10
     b10: e3 e4 a9 ec  	bltu	s3, a0, 0x9d8 <.Lline_table_start0+0x360>
     b14: 13 19 19 00  	slli	s2, s2, 1
     b18: 13 0a ea ff  	addi	s4, s4, -2
     b1c: 37 05 00 50  	lui	a0, 327680
     b20: 13 05 45 0a  	addi	a0, a0, 164
     b24: 33 05 25 01  	add	a0, a0, s2
     b28: 83 45 15 00  	lbu	a1, 1(a0)
     b2c: 03 45 05 00  	lbu	a0, 0(a0)
     b30: 13 06 51 00  	addi	a2, sp, 5
     b34: 33 06 46 01  	add	a2, a2, s4
     b38: a3 00 b6 00  	sb	a1, 1(a2)
     b3c: 23 00 a6 00  	sb	a0, 0(a2)
     b40: 13 07 51 00  	addi	a4, sp, 5
     b44: 33 07 47 01  	add	a4, a4, s4
     b48: 13 05 70 02  	li	a0, 39
     b4c: b3 07 45 41  	sub	a5, a0, s4
     b50: 37 05 00 50  	lui	a0, 327680
     b54: 13 06 05 07  	addi	a2, a0, 112
     b58: 13 05 04 00  	mv	a0, s0
     b5c: 93 85 04 00  	mv	a1, s1
     b60: 93 06 00 00  	li	a3, 0
     b64: 97 f0 ff ff  	auipc	ra, 1048575
     b68: e7 80 00 7c  	jalr	1984(ra)
     b6c: 83 20 c1 05  	lw	ra, 92(sp)
     b70: 03 24 81 05  	lw	s0, 88(sp)
     b74: 83 24 41 05  	lw	s1, 84(sp)
     b78: 03 29 01 05  	lw	s2, 80(sp)
     b7c: 83 29 c1 04  	lw	s3, 76(sp)
     b80: 03 2a 81 04  	lw	s4, 72(sp)
     b84: 83 2a 41 04  	lw	s5, 68(sp)
     b88: 03 2b 01 04  	lw	s6, 64(sp)
     b8c: 83 2b c1 03  	lw	s7, 60(sp)
     b90: 03 2c 81 03  	lw	s8, 56(sp)
     b94: 83 2c 41 03  	lw	s9, 52(sp)
     b98: 03 2d 01 03  	lw	s10, 48(sp)
     b9c: 83 2d c1 02  	lw	s11, 44(sp)
     ba0: 13 01 01 06  	addi	sp, sp, 96
     ba4: 67 80 00 00  	ret

00000ba8 <core::fmt::num::imp::<impl core::fmt::Display for usize>::fmt::hcb9523be2baa3748>:
     ba8: 03 25 05 00  	lw	a0, 0(a0)
     bac: 13 86 05 00  	mv	a2, a1
     bb0: 93 05 10 00  	li	a1, 1
     bb4: 17 03 00 00  	auipc	t1, 0
     bb8: 67 00 03 dc  	jr	-576(t1)

00000bbc <__mulsi3>:
     bbc: 13 06 00 00  	li	a2, 0
     bc0: 63 00 05 02  	beqz	a0, 0xbe0 <.Lline_table_start0+0x568>
     bc4: 93 16 f5 01  	slli	a3, a0, 31
     bc8: 93 d6 f6 41  	srai	a3, a3, 31
     bcc: b3 f6 b6 00  	and	a3, a3, a1
     bd0: 33 86 c6 00  	add	a2, a3, a2
     bd4: 13 55 15 00  	srli	a0, a0, 1
     bd8: 93 95 15 00  	slli	a1, a1, 1
     bdc: e3 14 05 fe  	bnez	a0, 0xbc4 <.Lline_table_start0+0x54c>
     be0: 13 05 06 00  	mv	a0, a2
     be4: 67 80 00 00  	ret

00000be8 <compiler_builtins::int::specialized_div_rem::u32_div_rem::h07e771e3bc67a4d3>:
     be8: 13 06 05 00  	mv	a2, a0
     bec: 63 78 b5 00  	bgeu	a0, a1, 0xbfc <.Lline_table_start0+0x584>
     bf0: 13 05 00 00  	li	a0, 0
     bf4: 93 05 06 00  	mv	a1, a2
     bf8: 67 80 00 00  	ret
     bfc: 13 57 06 01  	srli	a4, a2, 16
     c00: 33 35 b7 00  	sltu	a0, a4, a1
     c04: 93 46 15 00  	xori	a3, a0, 1
     c08: 13 05 06 00  	mv	a0, a2
     c0c: 63 64 b7 00  	bltu	a4, a1, 0xc14 <.Lline_table_start0+0x59c>
     c10: 13 05 07 00  	mv	a0, a4
     c14: 93 96 46 00  	slli	a3, a3, 4
     c18: 93 57 85 00  	srli	a5, a0, 8
     c1c: 33 b7 b7 00  	sltu	a4, a5, a1
     c20: 13 47 17 00  	xori	a4, a4, 1
     c24: 63 e4 b7 00  	bltu	a5, a1, 0xc2c <.Lline_table_start0+0x5b4>
     c28: 13 85 07 00  	mv	a0, a5
     c2c: 13 17 37 00  	slli	a4, a4, 3
     c30: b3 66 d7 00  	or	a3, a4, a3
     c34: 93 57 45 00  	srli	a5, a0, 4
     c38: 33 b7 b7 00  	sltu	a4, a5, a1
     c3c: 13 47 17 00  	xori	a4, a4, 1
     c40: 63 e4 b7 00  	bltu	a5, a1, 0xc48 <.Lline_table_start0+0x5d0>
     c44: 13 85 07 00  	mv	a0, a5
     c48: 13 17 27 00  	slli	a4, a4, 2
     c4c: b3 e6 e6 00  	or	a3, a3, a4
     c50: 93 57 25 00  	srli	a5, a0, 2
     c54: 33 b7 b7 00  	sltu	a4, a5, a1
     c58: 13 47 17 00  	xori	a4, a4, 1
     c5c: 63 e4 b7 00  	bltu	a5, a1, 0xc64 <.Lline_table_start0+0x5ec>
     c60: 13 85 07 00  	mv	a0, a5
     c64: 13 17 17 00  	slli	a4, a4, 1
     c68: 13 55 15 00  	srli	a0, a0, 1
     c6c: 33 35 b5 00  	sltu	a0, a0, a1
     c70: 13 45 15 00  	xori	a0, a0, 1
     c74: 33 65 a7 00  	or	a0, a4, a0
     c78: b3 e6 a6 00  	or	a3, a3, a0
     c7c: 33 97 d5 00  	sll	a4, a1, a3
     c80: 33 06 e6 40  	sub	a2, a2, a4
     c84: 13 05 10 00  	li	a0, 1
     c88: 33 15 d5 00  	sll	a0, a0, a3
     c8c: 63 60 b6 08  	bltu	a2, a1, 0xd0c <.Lline_table_start0+0x694>
     c90: 63 46 07 00  	bltz	a4, 0xc9c <.Lline_table_start0+0x624>
     c94: 93 07 05 00  	mv	a5, a0
     c98: 6f 00 80 03  	j	0xcd0 <.Lline_table_start0+0x658>
     c9c: 13 57 17 00  	srli	a4, a4, 1
     ca0: 93 86 f6 ff  	addi	a3, a3, -1
     ca4: 93 07 10 00  	li	a5, 1
     ca8: b3 97 d7 00  	sll	a5, a5, a3
     cac: 33 08 e6 40  	sub	a6, a2, a4
     cb0: 93 28 08 00  	slti	a7, a6, 0
     cb4: 93 88 f8 ff  	addi	a7, a7, -1
     cb8: b3 f8 f8 00  	and	a7, a7, a5
     cbc: 63 54 08 00  	bgez	a6, 0xcc4 <.Lline_table_start0+0x64c>
     cc0: 13 08 06 00  	mv	a6, a2
     cc4: 33 e5 a8 00  	or	a0, a7, a0
     cc8: 13 06 08 00  	mv	a2, a6
     ccc: 63 60 b8 04  	bltu	a6, a1, 0xd0c <.Lline_table_start0+0x694>
     cd0: 93 87 f7 ff  	addi	a5, a5, -1
     cd4: 63 86 06 02  	beqz	a3, 0xd00 <.Lline_table_start0+0x688>
     cd8: 93 85 06 00  	mv	a1, a3
     cdc: 6f 00 c0 00  	j	0xce8 <.Lline_table_start0+0x670>
     ce0: 93 85 f5 ff  	addi	a1, a1, -1
     ce4: 63 8e 05 00  	beqz	a1, 0xd00 <.Lline_table_start0+0x688>
     ce8: 13 16 16 00  	slli	a2, a2, 1
     cec: 33 08 e6 40  	sub	a6, a2, a4
     cf0: 13 08 18 00  	addi	a6, a6, 1
     cf4: e3 46 08 fe  	bltz	a6, 0xce0 <.Lline_table_start0+0x668>
     cf8: 13 06 08 00  	mv	a2, a6
     cfc: 6f f0 5f fe  	j	0xce0 <.Lline_table_start0+0x668>
     d00: b3 77 f6 00  	and	a5, a2, a5
     d04: 33 e5 a7 00  	or	a0, a5, a0
     d08: 33 56 d6 00  	srl	a2, a2, a3
     d0c: 93 05 06 00  	mv	a1, a2
     d10: 67 80 00 00  	ret

00000d14 <__udivsi3>:
     d14: 17 03 00 00  	auipc	t1, 0
     d18: 67 00 43 ed  	jr	-300(t1)
