warning: unused imports: `Pin0`, `Pin`
 --> examples/uart.rs:8:27
  |
8 |     use hippomenes_core::{Pin, Pin0};
  |                           ^^^  ^^^^
  |
  = note: `#[warn(unused_imports)]` on by default

warning: unused variable: `cx`
  --> examples/uart.rs:35:18
   |
35 |     fn some_task(cx: some_task::Context) {}
   |                  ^^ help: if this is intentional, prefix it with an underscore: `_cx`
   |
   = note: `#[warn(unused_variables)]` on by default

warning: 2 warnings emitted


uart:	file format elf32-littleriscv

Disassembly of section .text:

00000000 <_start>:
       0: 97 11 00 50  	auipc	gp, 327681
       4: 93 81 01 99  	addi	gp, gp, -1648

00000008 <.Lpcrel_hi1>:
       8: 17 43 00 50  	auipc	t1, 327684
       c: 13 03 83 ff  	addi	t1, t1, -8
      10: 13 71 03 ff  	andi	sp, t1, -16

00000014 <.Lpcrel_hi2>:
      14: 97 02 00 50  	auipc	t0, 327680
      18: 93 82 c2 17  	addi	t0, t0, 380

0000001c <.Lpcrel_hi3>:
      1c: 97 03 00 50  	auipc	t2, 327680
      20: 93 83 83 17  	addi	t2, t2, 376

00000024 <.Lpcrel_hi4>:
      24: 17 03 00 50  	auipc	t1, 327680
      28: 13 03 c3 16  	addi	t1, t1, 364
      2c: 63 fc 72 00  	bgeu	t0, t2, 0x44 <.Lline_table_start0+0x44>
      30: 03 2e 03 00  	lw	t3, 0(t1)
      34: 13 03 43 00  	addi	t1, t1, 4
      38: 23 a0 c2 01  	sw	t3, 0(t0)
      3c: 93 82 42 00  	addi	t0, t0, 4
      40: e3 e8 72 fe  	bltu	t0, t2, 0x30 <.Lline_table_start0+0x30>

00000044 <.Lpcrel_hi5>:
      44: 97 02 00 50  	auipc	t0, 327680
      48: 93 82 02 15  	addi	t0, t0, 336

0000004c <.Lpcrel_hi6>:
      4c: 97 03 00 50  	auipc	t2, 327680
      50: 93 83 c3 15  	addi	t2, t2, 348
      54: 63 f8 72 00  	bgeu	t0, t2, 0x64 <.Lline_table_start0+0x64>
      58: 23 a0 02 00  	sw	zero, 0(t0)
      5c: 93 82 42 00  	addi	t0, t0, 4
      60: e3 ec 72 fe  	bltu	t0, t2, 0x58 <.Lline_table_start0+0x58>
      64: 97 00 00 00  	auipc	ra, 0
      68: e7 80 c0 1b  	jalr	444(ra)
      6c: 6f 00 00 01  	j	0x7c <.Lline_table_start0+0x7c>

00000070 <DefaultHandler>:
      70: 6f 00 00 00  	j	0x70 <.Lline_table_start0+0x70>

00000074 <rust_begin_unwind>:
      74: 6f 00 00 00  	j	0x74 <.Lline_table_start0+0x74>

00000078 <Interrupt2>:
      78: 67 80 00 00  	ret

0000007c <main>:
      7c: 13 01 01 ff  	addi	sp, sp, -16
      80: 23 26 11 00  	sw	ra, 12(sp)
      84: 13 05 80 00  	li	a0, 8
      88: 73 30 05 30  	csrc	mstatus, a0
      8c: 73 20 25 b2  	csrs	2850, a0
      90: 73 60 21 b2  	csrsi	2850, 2
      94: 97 00 00 00  	auipc	ra, 0
      98: e7 80 c0 00  	jalr	12(ra)
      9c: 6f 00 00 00  	j	0x9c <.Lline_table_start0+0x9c>

000000a0 <uart::app::main::__rtic_init_resources::ha1af8cdad81d8543>:
      a0: 37 05 00 50  	lui	a0, 327680
      a4: 93 05 40 06  	li	a1, 100
      a8: 23 22 b5 1a  	sw	a1, 420(a0)
      ac: 73 70 01 b2  	csrci	2848, 2
      b0: 93 05 c0 01  	li	a1, 28
      b4: 73 a0 05 b2  	csrs	2848, a1
      b8: 03 25 45 1a  	lw	a0, 420(a0)
      bc: 13 15 45 00  	slli	a0, a0, 4
      c0: f3 15 05 40  	csrrw	a1, 1024, a0
      c4: 37 05 00 50  	lui	a0, 327680
      c8: 93 05 10 00  	li	a1, 1
      cc: 23 08 b5 18  	sb	a1, 400(a0)
      d0: 37 05 00 50  	lui	a0, 327680
      d4: 93 05 45 19  	addi	a1, a0, 404
      d8: 13 06 70 03  	li	a2, 55
      dc: a3 83 c5 00  	sb	a2, 7(a1)
      e0: 13 06 60 03  	li	a2, 54
      e4: 23 83 c5 00  	sb	a2, 6(a1)
      e8: 13 06 50 03  	li	a2, 53
      ec: a3 82 c5 00  	sb	a2, 5(a1)
      f0: 13 06 40 03  	li	a2, 52
      f4: 23 82 c5 00  	sb	a2, 4(a1)
      f8: 13 06 30 03  	li	a2, 51
      fc: a3 81 c5 00  	sb	a2, 3(a1)
     100: 13 06 20 03  	li	a2, 50
     104: 23 81 c5 00  	sb	a2, 2(a1)
     108: 13 06 10 03  	li	a2, 49
     10c: a3 80 c5 00  	sb	a2, 1(a1)
     110: 93 05 00 03  	li	a1, 48
     114: 23 0a b5 18  	sb	a1, 404(a0)
     118: 37 05 00 50  	lui	a0, 327680
     11c: 23 2e 05 18  	sw	zero, 412(a0)
     120: 37 05 00 50  	lui	a0, 327680
     124: 23 20 05 1a  	sw	zero, 416(a0)
     128: 73 60 01 b2  	csrsi	2848, 2
     12c: 13 05 80 00  	li	a0, 8
     130: 73 20 05 30  	csrs	mstatus, a0
     134: 67 80 00 00  	ret

00000138 <Interrupt0>:
     138: 37 05 00 50  	lui	a0, 327680
     13c: 83 45 05 19  	lbu	a1, 400(a0)
     140: 63 80 05 02  	beqz	a1, 0x160 <.Lline_table_start0+0x160>
     144: 73 f0 00 00  	csrci	0, 1
     148: b7 05 00 50  	lui	a1, 327680
     14c: 83 a5 45 1a  	lw	a1, 420(a1)
     150: 23 08 05 18  	sb	zero, 400(a0)
     154: 93 95 45 00  	slli	a1, a1, 4
     158: 73 95 05 40  	csrrw	a0, 1024, a1
     15c: 67 80 00 00  	ret
     160: 37 05 00 50  	lui	a0, 327680
     164: 83 25 05 1a  	lw	a1, 416(a0)
     168: 13 06 80 00  	li	a2, 8
     16c: 63 92 c5 04  	bne	a1, a2, 0x1b0 <.Lline_table_start0+0x1b0>
     170: 73 e0 00 00  	csrsi	0, 1
     174: 37 05 00 50  	lui	a0, 327680
     178: 83 25 c5 19  	lw	a1, 412(a0)
     17c: 37 06 00 50  	lui	a2, 327680
     180: 93 06 10 00  	li	a3, 1
     184: 13 07 70 00  	li	a4, 7
     188: 23 08 d6 18  	sb	a3, 400(a2)
     18c: 63 f2 e5 06  	bgeu	a1, a4, 0x1f0 <.Lline_table_start0+0x1f0>
     190: 93 85 15 00  	addi	a1, a1, 1
     194: 23 2e b5 18  	sw	a1, 412(a0)
     198: 37 05 00 50  	lui	a0, 327680
     19c: 23 20 05 1a  	sw	zero, 416(a0)
     1a0: 37 75 02 00  	lui	a0, 39
     1a4: 13 05 05 10  	addi	a0, a0, 256
     1a8: f3 15 05 40  	csrrw	a1, 1024, a0
     1ac: 67 80 00 00  	ret
     1b0: 37 05 00 50  	lui	a0, 327680
     1b4: 03 25 c5 19  	lw	a0, 412(a0)
     1b8: 63 7a c5 04  	bgeu	a0, a2, 0x20c <.Lline_table_start0+0x20c>
     1bc: 37 06 00 50  	lui	a2, 327680
     1c0: 13 06 46 19  	addi	a2, a2, 404
     1c4: 33 05 a6 00  	add	a0, a2, a0
     1c8: 03 45 05 00  	lbu	a0, 0(a0)
     1cc: 13 f6 75 00  	andi	a2, a1, 7
     1d0: 33 55 c5 00  	srl	a0, a0, a2
     1d4: 13 75 15 00  	andi	a0, a0, 1
     1d8: 93 85 15 00  	addi	a1, a1, 1
     1dc: 37 06 00 50  	lui	a2, 327680
     1e0: 23 20 b6 1a  	sw	a1, 416(a2)
     1e4: 63 00 05 02  	beqz	a0, 0x204 <.Lline_table_start0+0x204>
     1e8: 73 e0 00 00  	csrsi	0, 1
     1ec: 67 80 00 00  	ret
     1f0: 23 2e 05 18  	sw	zero, 412(a0)
     1f4: 37 05 00 50  	lui	a0, 327680
     1f8: 23 20 05 1a  	sw	zero, 416(a0)
     1fc: 73 70 01 b2  	csrci	2848, 2
     200: 67 80 00 00  	ret
     204: 73 f0 00 00  	csrci	0, 1
     208: 67 80 00 00  	ret
     20c: b7 05 00 50  	lui	a1, 327680
     210: 13 86 45 06  	addi	a2, a1, 100
     214: 93 05 80 00  	li	a1, 8
     218: 97 00 00 00  	auipc	ra, 0
     21c: e7 80 40 0b  	jalr	180(ra)

00000220 <_setup_interrupts>:
     220: 37 05 00 00  	lui	a0, 0
     224: 13 05 85 13  	addi	a0, a0, 312
     228: 13 55 25 00  	srli	a0, a0, 2
     22c: f3 15 05 b0  	csrrw	a1, mcycle, a0
     230: 37 05 00 00  	lui	a0, 0
     234: 13 05 45 25  	addi	a0, a0, 596
     238: 13 55 25 00  	srli	a0, a0, 2
     23c: f3 15 15 b0  	csrrw	a1, 2817, a0
     240: 37 05 00 00  	lui	a0, 0
     244: 13 05 85 07  	addi	a0, a0, 120
     248: 13 55 25 00  	srli	a0, a0, 2
     24c: f3 15 25 b0  	csrrw	a1, minstret, a0
     250: 67 80 00 00  	ret

00000254 <Interrupt1>:
     254: 6f 00 00 00  	j	0x254 <.Lline_table_start0+0x254>

00000258 <core::ptr::drop_in_place<core::fmt::Error>::heeee8b9450240777>:
     258: 67 80 00 00  	ret

0000025c <<T as core::any::Any>::type_id::h2f0dbd42483f0e1c>:
     25c: b7 d5 77 58  	lui	a1, 362365
     260: 93 85 f5 4b  	addi	a1, a1, 1215
     264: 23 26 b5 00  	sw	a1, 12(a0)
     268: b7 f5 6b 91  	lui	a1, 595647
     26c: 93 85 b5 34  	addi	a1, a1, 843
     270: 23 24 b5 00  	sw	a1, 8(a0)
     274: b7 d5 88 85  	lui	a1, 546957
     278: 93 85 85 6a  	addi	a1, a1, 1704
     27c: 23 22 b5 00  	sw	a1, 4(a0)
     280: b7 35 ec 8d  	lui	a1, 581315
     284: 93 85 15 1b  	addi	a1, a1, 433
     288: 23 20 b5 00  	sw	a1, 0(a0)
     28c: 67 80 00 00  	ret

00000290 <core::panicking::panic_fmt::h2fd2ec5d5d8b7281>:
     290: 13 01 01 fe  	addi	sp, sp, -32
     294: 23 2e 11 00  	sw	ra, 28(sp)
     298: 37 06 00 50  	lui	a2, 327680
     29c: 13 06 46 09  	addi	a2, a2, 148
     2a0: 23 24 c1 00  	sw	a2, 8(sp)
     2a4: 37 06 00 50  	lui	a2, 327680
     2a8: 13 06 46 09  	addi	a2, a2, 148
     2ac: 23 26 c1 00  	sw	a2, 12(sp)
     2b0: 23 28 a1 00  	sw	a0, 16(sp)
     2b4: 23 2a b1 00  	sw	a1, 20(sp)
     2b8: 13 05 10 00  	li	a0, 1
     2bc: 23 1c a1 00  	sh	a0, 24(sp)
     2c0: 13 05 81 00  	addi	a0, sp, 8
     2c4: 97 00 00 00  	auipc	ra, 0
     2c8: e7 80 00 db  	jalr	-592(ra)

000002cc <core::panicking::panic_bounds_check::h21f1f332d5788ef2>:
     2cc: 13 01 01 fc  	addi	sp, sp, -64
     2d0: 23 2e 11 02  	sw	ra, 60(sp)
     2d4: 23 26 a1 00  	sw	a0, 12(sp)
     2d8: 23 28 b1 00  	sw	a1, 16(sp)
     2dc: 13 05 01 01  	addi	a0, sp, 16
     2e0: 23 26 a1 02  	sw	a0, 44(sp)
     2e4: 37 15 00 00  	lui	a0, 1
     2e8: 13 05 45 bb  	addi	a0, a0, -1100
     2ec: 23 28 a1 02  	sw	a0, 48(sp)
     2f0: 93 05 c1 00  	addi	a1, sp, 12
     2f4: 23 2a b1 02  	sw	a1, 52(sp)
     2f8: 23 2c a1 02  	sw	a0, 56(sp)
     2fc: 37 05 00 50  	lui	a0, 327680
     300: 13 05 85 0b  	addi	a0, a0, 184
     304: 23 2a a1 00  	sw	a0, 20(sp)
     308: 13 05 20 00  	li	a0, 2
     30c: 23 2c a1 00  	sw	a0, 24(sp)
     310: 23 22 01 02  	sw	zero, 36(sp)
     314: 93 05 c1 02  	addi	a1, sp, 44
     318: 23 2e b1 00  	sw	a1, 28(sp)
     31c: 23 20 a1 02  	sw	a0, 32(sp)
     320: 13 05 41 01  	addi	a0, sp, 20
     324: 93 05 06 00  	mv	a1, a2
     328: 97 00 00 00  	auipc	ra, 0
     32c: e7 80 80 f6  	jalr	-152(ra)

00000330 <core::fmt::Formatter::pad_integral::h54f440eb1409ba0b>:
     330: 13 01 01 fc  	addi	sp, sp, -64
     334: 23 2e 11 02  	sw	ra, 60(sp)
     338: 23 2c 81 02  	sw	s0, 56(sp)
     33c: 23 2a 91 02  	sw	s1, 52(sp)
     340: 23 28 21 03  	sw	s2, 48(sp)
     344: 23 26 31 03  	sw	s3, 44(sp)
     348: 23 24 41 03  	sw	s4, 40(sp)
     34c: 23 22 51 03  	sw	s5, 36(sp)
     350: 23 20 61 03  	sw	s6, 32(sp)
     354: 23 2e 71 01  	sw	s7, 28(sp)
     358: 23 2c 81 01  	sw	s8, 24(sp)
     35c: 23 2a 91 01  	sw	s9, 20(sp)
     360: 23 28 a1 01  	sw	s10, 16(sp)
     364: 23 26 b1 01  	sw	s11, 12(sp)
     368: 13 84 07 00  	mv	s0, a5
     36c: 93 04 07 00  	mv	s1, a4
     370: 93 89 06 00  	mv	s3, a3
     374: 13 0a 06 00  	mv	s4, a2
     378: 13 09 05 00  	mv	s2, a0
     37c: 63 8e 05 04  	beqz	a1, 0x3d8 <.Lline_table_start0+0x92>
     380: 03 2b c9 01  	lw	s6, 28(s2)
     384: 93 7c 1b 00  	andi	s9, s6, 1
     388: b7 0a 11 00  	lui	s5, 272
     38c: 63 84 0c 00  	beqz	s9, 0x394 <.Lline_table_start0+0x4e>
     390: 93 0a b0 02  	li	s5, 43
     394: b3 8c 8c 00  	add	s9, s9, s0
     398: 13 75 4b 00  	andi	a0, s6, 4
     39c: 63 08 05 04  	beqz	a0, 0x3ec <.Lline_table_start0+0xa6>
     3a0: 13 05 00 01  	li	a0, 16
     3a4: 63 fc a9 04  	bgeu	s3, a0, 0x3fc <.Lline_table_start0+0xb6>
     3a8: 13 05 00 00  	li	a0, 0
     3ac: 63 80 09 06  	beqz	s3, 0x40c <.Lline_table_start0+0xc6>
     3b0: 93 05 0a 00  	mv	a1, s4
     3b4: 13 86 09 00  	mv	a2, s3
     3b8: 83 86 05 00  	lb	a3, 0(a1)
     3bc: 93 a6 06 fc  	slti	a3, a3, -64
     3c0: 93 c6 16 00  	xori	a3, a3, 1
     3c4: 33 05 d5 00  	add	a0, a0, a3
     3c8: 13 06 f6 ff  	addi	a2, a2, -1
     3cc: 93 85 15 00  	addi	a1, a1, 1
     3d0: e3 14 06 fe  	bnez	a2, 0x3b8 <.Lline_table_start0+0x72>
     3d4: 6f 00 80 03  	j	0x40c <.Lline_table_start0+0xc6>
     3d8: 03 2b c9 01  	lw	s6, 28(s2)
     3dc: 93 0c 14 00  	addi	s9, s0, 1
     3e0: 93 0a d0 02  	li	s5, 45
     3e4: 13 75 4b 00  	andi	a0, s6, 4
     3e8: e3 1c 05 fa  	bnez	a0, 0x3a0 <.Lline_table_start0+0x5a>
     3ec: 13 0a 00 00  	li	s4, 0
     3f0: 03 25 09 00  	lw	a0, 0(s2)
     3f4: 63 12 05 02  	bnez	a0, 0x418 <.Lline_table_start0+0xd2>
     3f8: 6f 00 80 04  	j	0x440 <.Lline_table_start0+0xfa>
     3fc: 13 05 0a 00  	mv	a0, s4
     400: 93 85 09 00  	mv	a1, s3
     404: 97 00 00 00  	auipc	ra, 0
     408: e7 80 80 2f  	jalr	760(ra)
     40c: b3 0c 95 01  	add	s9, a0, s9
     410: 03 25 09 00  	lw	a0, 0(s2)
     414: 63 06 05 02  	beqz	a0, 0x440 <.Lline_table_start0+0xfa>
     418: 03 2d 49 00  	lw	s10, 4(s2)
     41c: 63 f2 ac 03  	bgeu	s9, s10, 0x440 <.Lline_table_start0+0xfa>
     420: 13 75 8b 00  	andi	a0, s6, 8
     424: 63 1a 05 0c  	bnez	a0, 0x4f8 <.Lline_table_start0+0x1b2>
     428: 03 45 09 02  	lbu	a0, 32(s2)
     42c: 93 05 10 00  	li	a1, 1
     430: b3 0c 9d 41  	sub	s9, s10, s9
     434: 63 c8 a5 12  	blt	a1, a0, 0x564 <.Lline_table_start0+0x4c>
     438: 63 12 05 14  	bnez	a0, 0x57c <.Lline_table_start0+0x64>
     43c: 6f 00 80 14  	j	0x584 <.Lline_table_start0+0x6c>
     440: 83 2b 49 01  	lw	s7, 20(s2)
     444: 03 29 89 01  	lw	s2, 24(s2)
     448: 13 85 0b 00  	mv	a0, s7
     44c: 93 05 09 00  	mv	a1, s2
     450: 13 86 0a 00  	mv	a2, s5
     454: 93 06 0a 00  	mv	a3, s4
     458: 13 87 09 00  	mv	a4, s3
     45c: 97 00 00 00  	auipc	ra, 0
     460: e7 80 40 20  	jalr	516(ra)
     464: 13 0b 10 00  	li	s6, 1
     468: 63 02 05 04  	beqz	a0, 0x4ac <.Lline_table_start0+0x166>
     46c: 13 05 0b 00  	mv	a0, s6
     470: 83 20 c1 03  	lw	ra, 60(sp)
     474: 03 24 81 03  	lw	s0, 56(sp)
     478: 83 24 41 03  	lw	s1, 52(sp)
     47c: 03 29 01 03  	lw	s2, 48(sp)
     480: 83 29 c1 02  	lw	s3, 44(sp)
     484: 03 2a 81 02  	lw	s4, 40(sp)
     488: 83 2a 41 02  	lw	s5, 36(sp)
     48c: 03 2b 01 02  	lw	s6, 32(sp)
     490: 83 2b c1 01  	lw	s7, 28(sp)
     494: 03 2c 81 01  	lw	s8, 24(sp)
     498: 83 2c 41 01  	lw	s9, 20(sp)
     49c: 03 2d 01 01  	lw	s10, 16(sp)
     4a0: 83 2d c1 00  	lw	s11, 12(sp)
     4a4: 13 01 01 04  	addi	sp, sp, 64
     4a8: 67 80 00 00  	ret
     4ac: 03 23 c9 00  	lw	t1, 12(s2)
     4b0: 13 85 0b 00  	mv	a0, s7
     4b4: 93 85 04 00  	mv	a1, s1
     4b8: 13 06 04 00  	mv	a2, s0
     4bc: 83 20 c1 03  	lw	ra, 60(sp)
     4c0: 03 24 81 03  	lw	s0, 56(sp)
     4c4: 83 24 41 03  	lw	s1, 52(sp)
     4c8: 03 29 01 03  	lw	s2, 48(sp)
     4cc: 83 29 c1 02  	lw	s3, 44(sp)
     4d0: 03 2a 81 02  	lw	s4, 40(sp)
     4d4: 83 2a 41 02  	lw	s5, 36(sp)
     4d8: 03 2b 01 02  	lw	s6, 32(sp)
     4dc: 83 2b c1 01  	lw	s7, 28(sp)
     4e0: 03 2c 81 01  	lw	s8, 24(sp)
     4e4: 83 2c 41 01  	lw	s9, 20(sp)
     4e8: 03 2d 01 01  	lw	s10, 16(sp)
     4ec: 83 2d c1 00  	lw	s11, 12(sp)
     4f0: 13 01 01 04  	addi	sp, sp, 64
     4f4: 67 00 03 00  	jr	t1
     4f8: 03 25 09 01  	lw	a0, 16(s2)
     4fc: 23 24 a1 00  	sw	a0, 8(sp)
     500: 13 05 00 03  	li	a0, 48
     504: 83 4d 09 02  	lbu	s11, 32(s2)
     508: 83 2b 49 01  	lw	s7, 20(s2)
     50c: 03 2c 89 01  	lw	s8, 24(s2)
     510: 23 28 a9 00  	sw	a0, 16(s2)
     514: 13 0b 10 00  	li	s6, 1
     518: 23 00 69 03  	sb	s6, 32(s2)
     51c: 13 85 0b 00  	mv	a0, s7
     520: 93 05 0c 00  	mv	a1, s8
     524: 13 86 0a 00  	mv	a2, s5
     528: 93 06 0a 00  	mv	a3, s4
     52c: 13 87 09 00  	mv	a4, s3
     530: 97 00 00 00  	auipc	ra, 0
     534: e7 80 00 13  	jalr	304(ra)
     538: e3 1a 05 f2  	bnez	a0, 0x46c <.Lline_table_start0+0x126>
     53c: b3 09 9d 41  	sub	s3, s10, s9
     540: 93 89 19 00  	addi	s3, s3, 1
     544: 93 89 f9 ff  	addi	s3, s3, -1
     548: 63 80 09 0e  	beqz	s3, 0x628 <.Lline_table_start0+0x110>
     54c: 03 26 0c 01  	lw	a2, 16(s8)
     550: 93 05 00 03  	li	a1, 48
     554: 13 85 0b 00  	mv	a0, s7
     558: e7 00 06 00  	jalr	a2
     55c: e3 04 05 fe  	beqz	a0, 0x544 <.Lline_table_start0+0x2c>
     560: 6f f0 df f0  	j	0x46c <.Lline_table_start0+0x126>
     564: 93 05 20 00  	li	a1, 2
     568: 63 1a b5 00  	bne	a0, a1, 0x57c <.Lline_table_start0+0x64>
     56c: 13 d5 1c 00  	srli	a0, s9, 1
     570: 93 8c 1c 00  	addi	s9, s9, 1
     574: 93 dc 1c 00  	srli	s9, s9, 1
     578: 6f 00 c0 00  	j	0x584 <.Lline_table_start0+0x6c>
     57c: 13 85 0c 00  	mv	a0, s9
     580: 93 0c 00 00  	li	s9, 0
     584: 83 2b 49 01  	lw	s7, 20(s2)
     588: 03 2c 89 01  	lw	s8, 24(s2)
     58c: 03 29 09 01  	lw	s2, 16(s2)
     590: 13 0b 15 00  	addi	s6, a0, 1
     594: 13 0b fb ff  	addi	s6, s6, -1
     598: 63 00 0b 02  	beqz	s6, 0x5b8 <.Lline_table_start0+0xa0>
     59c: 03 26 0c 01  	lw	a2, 16(s8)
     5a0: 13 85 0b 00  	mv	a0, s7
     5a4: 93 05 09 00  	mv	a1, s2
     5a8: e7 00 06 00  	jalr	a2
     5ac: e3 04 05 fe  	beqz	a0, 0x594 <.Lline_table_start0+0x7c>
     5b0: 13 0b 10 00  	li	s6, 1
     5b4: 6f f0 9f eb  	j	0x46c <.Lline_table_start0+0x126>
     5b8: 13 85 0b 00  	mv	a0, s7
     5bc: 93 05 0c 00  	mv	a1, s8
     5c0: 13 86 0a 00  	mv	a2, s5
     5c4: 93 06 0a 00  	mv	a3, s4
     5c8: 13 87 09 00  	mv	a4, s3
     5cc: 97 00 00 00  	auipc	ra, 0
     5d0: e7 80 40 09  	jalr	148(ra)
     5d4: 13 0b 10 00  	li	s6, 1
     5d8: e3 1a 05 e8  	bnez	a0, 0x46c <.Lline_table_start0+0x126>
     5dc: 83 26 cc 00  	lw	a3, 12(s8)
     5e0: 13 85 0b 00  	mv	a0, s7
     5e4: 93 85 04 00  	mv	a1, s1
     5e8: 13 06 04 00  	mv	a2, s0
     5ec: e7 80 06 00  	jalr	a3
     5f0: e3 1e 05 e6  	bnez	a0, 0x46c <.Lline_table_start0+0x126>
     5f4: b3 04 90 41  	neg	s1, s9
     5f8: 93 09 f0 ff  	li	s3, -1
     5fc: 13 04 f0 ff  	li	s0, -1
     600: 33 85 84 00  	add	a0, s1, s0
     604: 63 08 35 05  	beq	a0, s3, 0x654 <.Lline_table_start0+0x13c>
     608: 03 26 0c 01  	lw	a2, 16(s8)
     60c: 13 85 0b 00  	mv	a0, s7
     610: 93 05 09 00  	mv	a1, s2
     614: e7 00 06 00  	jalr	a2
     618: 13 04 14 00  	addi	s0, s0, 1
     61c: e3 02 05 fe  	beqz	a0, 0x600 <.Lline_table_start0+0xe8>
     620: 33 3b 94 01  	sltu	s6, s0, s9
     624: 6f f0 9f e4  	j	0x46c <.Lline_table_start0+0x126>
     628: 83 26 cc 00  	lw	a3, 12(s8)
     62c: 13 85 0b 00  	mv	a0, s7
     630: 93 85 04 00  	mv	a1, s1
     634: 13 06 04 00  	mv	a2, s0
     638: e7 80 06 00  	jalr	a3
     63c: e3 18 05 e2  	bnez	a0, 0x46c <.Lline_table_start0+0x126>
     640: 13 0b 00 00  	li	s6, 0
     644: 03 25 81 00  	lw	a0, 8(sp)
     648: 23 28 a9 00  	sw	a0, 16(s2)
     64c: 23 00 b9 03  	sb	s11, 32(s2)
     650: 6f f0 df e1  	j	0x46c <.Lline_table_start0+0x126>
     654: 13 84 0c 00  	mv	s0, s9
     658: 33 bb 9c 01  	sltu	s6, s9, s9
     65c: 6f f0 1f e1  	j	0x46c <.Lline_table_start0+0x126>

00000660 <core::fmt::Formatter::pad_integral::write_prefix::hd869759600707ead>:
     660: 13 01 01 fe  	addi	sp, sp, -32
     664: 23 2e 11 00  	sw	ra, 28(sp)
     668: 23 2c 81 00  	sw	s0, 24(sp)
     66c: 23 2a 91 00  	sw	s1, 20(sp)
     670: 23 28 21 01  	sw	s2, 16(sp)
     674: 23 26 31 01  	sw	s3, 12(sp)
     678: b7 07 11 00  	lui	a5, 272
     67c: 13 04 07 00  	mv	s0, a4
     680: 93 84 06 00  	mv	s1, a3
     684: 93 89 05 00  	mv	s3, a1
     688: 13 09 05 00  	mv	s2, a0
     68c: 63 00 f6 02  	beq	a2, a5, 0x6ac <.Lline_table_start0+0x4>
     690: 83 a6 09 01  	lw	a3, 16(s3)
     694: 13 05 09 00  	mv	a0, s2
     698: 93 05 06 00  	mv	a1, a2
     69c: e7 80 06 00  	jalr	a3
     6a0: 93 05 05 00  	mv	a1, a0
     6a4: 13 05 10 00  	li	a0, 1
     6a8: 63 9c 05 02  	bnez	a1, 0x6e0 <.Lline_table_start0+0x38>
     6ac: 63 88 04 02  	beqz	s1, 0x6dc <.Lline_table_start0+0x34>
     6b0: 03 a3 c9 00  	lw	t1, 12(s3)
     6b4: 13 05 09 00  	mv	a0, s2
     6b8: 93 85 04 00  	mv	a1, s1
     6bc: 13 06 04 00  	mv	a2, s0
     6c0: 83 20 c1 01  	lw	ra, 28(sp)
     6c4: 03 24 81 01  	lw	s0, 24(sp)
     6c8: 83 24 41 01  	lw	s1, 20(sp)
     6cc: 03 29 01 01  	lw	s2, 16(sp)
     6d0: 83 29 c1 00  	lw	s3, 12(sp)
     6d4: 13 01 01 02  	addi	sp, sp, 32
     6d8: 67 00 03 00  	jr	t1
     6dc: 13 05 00 00  	li	a0, 0
     6e0: 83 20 c1 01  	lw	ra, 28(sp)
     6e4: 03 24 81 01  	lw	s0, 24(sp)
     6e8: 83 24 41 01  	lw	s1, 20(sp)
     6ec: 03 29 01 01  	lw	s2, 16(sp)
     6f0: 83 29 c1 00  	lw	s3, 12(sp)
     6f4: 13 01 01 02  	addi	sp, sp, 32
     6f8: 67 80 00 00  	ret

000006fc <core::str::count::do_count_chars::h8ee695d6c36300eb>:
     6fc: 13 01 01 fd  	addi	sp, sp, -48
     700: 23 26 11 02  	sw	ra, 44(sp)
     704: 23 24 81 02  	sw	s0, 40(sp)
     708: 23 22 91 02  	sw	s1, 36(sp)
     70c: 23 20 21 03  	sw	s2, 32(sp)
     710: 23 2e 31 01  	sw	s3, 28(sp)
     714: 23 2c 41 01  	sw	s4, 24(sp)
     718: 23 2a 51 01  	sw	s5, 20(sp)
     71c: 23 28 61 01  	sw	s6, 16(sp)
     720: 23 26 71 01  	sw	s7, 12(sp)
     724: 23 24 81 01  	sw	s8, 8(sp)
     728: 23 22 91 01  	sw	s9, 4(sp)
     72c: 93 06 35 00  	addi	a3, a0, 3
     730: 93 f6 c6 ff  	andi	a3, a3, -4
     734: 33 8c a6 40  	sub	s8, a3, a0
     738: 63 ec 85 17  	bltu	a1, s8, 0x8b0 <.Lline_table_start0+0x118>
     73c: 33 86 85 41  	sub	a2, a1, s8
     740: 13 5a 26 00  	srli	s4, a2, 2
     744: 63 06 0a 16  	beqz	s4, 0x8b0 <.Lline_table_start0+0x118>
     748: 93 75 36 00  	andi	a1, a2, 3
     74c: 13 04 00 00  	li	s0, 0
     750: 63 84 a6 02  	beq	a3, a0, 0x778 <.Lline_table_start0+0xd0>
     754: b3 06 d5 40  	sub	a3, a0, a3
     758: 13 07 05 00  	mv	a4, a0
     75c: 83 07 07 00  	lb	a5, 0(a4)
     760: 93 a7 07 fc  	slti	a5, a5, -64
     764: 93 c7 17 00  	xori	a5, a5, 1
     768: 33 04 f4 00  	add	s0, s0, a5
     76c: 93 86 16 00  	addi	a3, a3, 1
     770: 13 07 17 00  	addi	a4, a4, 1
     774: e3 94 06 fe  	bnez	a3, 0x75c <.Lline_table_start0+0xb4>
     778: 33 0c 85 01  	add	s8, a0, s8
     77c: 13 05 00 00  	li	a0, 0
     780: 63 84 05 02  	beqz	a1, 0x7a8 <.Lline_table_start0+0x10>
     784: 13 76 c6 ff  	andi	a2, a2, -4
     788: 33 06 cc 00  	add	a2, s8, a2
     78c: 83 06 06 00  	lb	a3, 0(a2)
     790: 93 a6 06 fc  	slti	a3, a3, -64
     794: 93 c6 16 00  	xori	a3, a3, 1
     798: 33 05 d5 00  	add	a0, a0, a3
     79c: 93 85 f5 ff  	addi	a1, a1, -1
     7a0: 13 06 16 00  	addi	a2, a2, 1
     7a4: e3 94 05 fe  	bnez	a1, 0x78c <.Lline_table_start0+0xe4>
     7a8: b7 05 01 01  	lui	a1, 4112
     7ac: 13 89 15 10  	addi	s2, a1, 257
     7b0: b7 05 ff 00  	lui	a1, 4080
     7b4: 93 89 f5 0f  	addi	s3, a1, 255
     7b8: b7 04 01 00  	lui	s1, 16
     7bc: 93 84 14 00  	addi	s1, s1, 1
     7c0: 33 04 85 00  	add	s0, a0, s0
     7c4: 6f 00 c0 03  	j	0x800 <.Lline_table_start0+0x68>
     7c8: 13 9c 2b 00  	slli	s8, s7, 2
     7cc: 33 0c 8b 01  	add	s8, s6, s8
     7d0: 33 8a 7a 41  	sub	s4, s5, s7
     7d4: 93 fc 3b 00  	andi	s9, s7, 3
     7d8: 33 75 36 01  	and	a0, a2, s3
     7dc: 13 56 86 00  	srli	a2, a2, 8
     7e0: b3 75 36 01  	and	a1, a2, s3
     7e4: 33 85 a5 00  	add	a0, a1, a0
     7e8: 93 85 04 00  	mv	a1, s1
     7ec: 97 00 00 00  	auipc	ra, 0
     7f0: e7 80 c0 3d  	jalr	988(ra)
     7f4: 13 55 05 01  	srli	a0, a0, 16
     7f8: 33 04 85 00  	add	s0, a0, s0
     7fc: 63 9e 0c 0c  	bnez	s9, 0x8d8 <.Lline_table_start0+0x140>
     800: 63 04 0a 14  	beqz	s4, 0x948 <.Lline_table_start0+0x1b0>
     804: 93 0a 0a 00  	mv	s5, s4
     808: 13 0b 0c 00  	mv	s6, s8
     80c: 13 05 00 0c  	li	a0, 192
     810: 93 0b 0a 00  	mv	s7, s4
     814: 63 64 aa 00  	bltu	s4, a0, 0x81c <.Lline_table_start0+0x84>
     818: 93 0b 00 0c  	li	s7, 192
     81c: 13 06 00 00  	li	a2, 0
     820: 13 d5 2b 00  	srli	a0, s7, 2
     824: e3 02 05 fa  	beqz	a0, 0x7c8 <.Lline_table_start0+0x30>
     828: 13 15 45 00  	slli	a0, a0, 4
     82c: 33 05 ab 00  	add	a0, s6, a0
     830: 93 05 0b 00  	mv	a1, s6
     834: 83 a6 05 00  	lw	a3, 0(a1)
     838: 13 c7 f6 ff  	not	a4, a3
     83c: 13 57 77 00  	srli	a4, a4, 7
     840: 93 d6 66 00  	srli	a3, a3, 6
     844: 83 a7 45 00  	lw	a5, 4(a1)
     848: b3 66 d7 00  	or	a3, a4, a3
     84c: b3 f6 26 01  	and	a3, a3, s2
     850: 33 86 c6 00  	add	a2, a3, a2
     854: 93 c6 f7 ff  	not	a3, a5
     858: 93 d6 76 00  	srli	a3, a3, 7
     85c: 03 a7 85 00  	lw	a4, 8(a1)
     860: 93 d7 67 00  	srli	a5, a5, 6
     864: b3 e6 f6 00  	or	a3, a3, a5
     868: b3 f6 26 01  	and	a3, a3, s2
     86c: 93 47 f7 ff  	not	a5, a4
     870: 93 d7 77 00  	srli	a5, a5, 7
     874: 13 57 67 00  	srli	a4, a4, 6
     878: 33 e7 e7 00  	or	a4, a5, a4
     87c: 83 a7 c5 00  	lw	a5, 12(a1)
     880: 33 77 27 01  	and	a4, a4, s2
     884: b3 06 d7 00  	add	a3, a4, a3
     888: 33 86 c6 00  	add	a2, a3, a2
     88c: 93 c6 f7 ff  	not	a3, a5
     890: 93 d6 76 00  	srli	a3, a3, 7
     894: 93 d7 67 00  	srli	a5, a5, 6
     898: b3 e6 f6 00  	or	a3, a3, a5
     89c: b3 f6 26 01  	and	a3, a3, s2
     8a0: 93 85 05 01  	addi	a1, a1, 16
     8a4: 33 86 c6 00  	add	a2, a3, a2
     8a8: e3 96 a5 f8  	bne	a1, a0, 0x834 <.Lline_table_start0+0x9c>
     8ac: 6f f0 df f1  	j	0x7c8 <.Lline_table_start0+0x30>
     8b0: 13 04 00 00  	li	s0, 0
     8b4: 63 8a 05 08  	beqz	a1, 0x948 <.Lline_table_start0+0x1b0>
     8b8: 03 06 05 00  	lb	a2, 0(a0)
     8bc: 13 26 06 fc  	slti	a2, a2, -64
     8c0: 13 46 16 00  	xori	a2, a2, 1
     8c4: 33 04 c4 00  	add	s0, s0, a2
     8c8: 93 85 f5 ff  	addi	a1, a1, -1
     8cc: 13 05 15 00  	addi	a0, a0, 1
     8d0: e3 94 05 fe  	bnez	a1, 0x8b8 <.Lline_table_start0+0x120>
     8d4: 6f 00 40 07  	j	0x948 <.Lline_table_start0+0x1b0>
     8d8: 13 05 00 00  	li	a0, 0
     8dc: 93 f5 cb 0f  	andi	a1, s7, 252
     8e0: 93 95 25 00  	slli	a1, a1, 2
     8e4: 33 0b bb 00  	add	s6, s6, a1
     8e8: 93 b5 0a 0c  	sltiu	a1, s5, 192
     8ec: b3 05 b0 40  	neg	a1, a1
     8f0: b3 f5 ba 00  	and	a1, s5, a1
     8f4: 93 f5 35 00  	andi	a1, a1, 3
     8f8: 93 95 25 00  	slli	a1, a1, 2
     8fc: 03 26 0b 00  	lw	a2, 0(s6)
     900: 13 0b 4b 00  	addi	s6, s6, 4
     904: 93 46 f6 ff  	not	a3, a2
     908: 93 d6 76 00  	srli	a3, a3, 7
     90c: 13 56 66 00  	srli	a2, a2, 6
     910: 33 e6 c6 00  	or	a2, a3, a2
     914: 33 76 26 01  	and	a2, a2, s2
     918: 93 85 c5 ff  	addi	a1, a1, -4
     91c: 33 05 a6 00  	add	a0, a2, a0
     920: e3 9e 05 fc  	bnez	a1, 0x8fc <.Lline_table_start0+0x164>
     924: b3 75 35 01  	and	a1, a0, s3
     928: 13 55 85 00  	srli	a0, a0, 8
     92c: 33 75 35 01  	and	a0, a0, s3
     930: 33 05 b5 00  	add	a0, a0, a1
     934: 93 85 04 00  	mv	a1, s1
     938: 97 00 00 00  	auipc	ra, 0
     93c: e7 80 00 29  	jalr	656(ra)
     940: 13 55 05 01  	srli	a0, a0, 16
     944: 33 04 85 00  	add	s0, a0, s0
     948: 13 05 04 00  	mv	a0, s0
     94c: 83 20 c1 02  	lw	ra, 44(sp)
     950: 03 24 81 02  	lw	s0, 40(sp)
     954: 83 24 41 02  	lw	s1, 36(sp)
     958: 03 29 01 02  	lw	s2, 32(sp)
     95c: 83 29 c1 01  	lw	s3, 28(sp)
     960: 03 2a 81 01  	lw	s4, 24(sp)
     964: 83 2a 41 01  	lw	s5, 20(sp)
     968: 03 2b 01 01  	lw	s6, 16(sp)
     96c: 83 2b c1 00  	lw	s7, 12(sp)
     970: 03 2c 81 00  	lw	s8, 8(sp)
     974: 83 2c 41 00  	lw	s9, 4(sp)
     978: 13 01 01 03  	addi	sp, sp, 48
     97c: 67 80 00 00  	ret

00000980 <core::fmt::num::imp::fmt_u32::hc69911958cd28b6c>:
     980: 13 01 01 fa  	addi	sp, sp, -96
     984: 23 2e 11 04  	sw	ra, 92(sp)
     988: 23 2c 81 04  	sw	s0, 88(sp)
     98c: 23 2a 91 04  	sw	s1, 84(sp)
     990: 23 28 21 05  	sw	s2, 80(sp)
     994: 23 26 31 05  	sw	s3, 76(sp)
     998: 23 24 41 05  	sw	s4, 72(sp)
     99c: 23 22 51 05  	sw	s5, 68(sp)
     9a0: 23 20 61 05  	sw	s6, 64(sp)
     9a4: 23 2e 71 03  	sw	s7, 60(sp)
     9a8: 23 2c 81 03  	sw	s8, 56(sp)
     9ac: 23 2a 91 03  	sw	s9, 52(sp)
     9b0: 23 28 a1 03  	sw	s10, 48(sp)
     9b4: 23 26 b1 03  	sw	s11, 44(sp)
     9b8: 13 04 06 00  	mv	s0, a2
     9bc: 93 84 05 00  	mv	s1, a1
     9c0: 13 09 05 00  	mv	s2, a0
     9c4: 13 55 45 00  	srli	a0, a0, 4
     9c8: 93 05 10 27  	li	a1, 625
     9cc: 13 0a 70 02  	li	s4, 39
     9d0: 63 76 b5 02  	bgeu	a0, a1, 0x9fc <.Lline_table_start0+0x264>
     9d4: 13 05 30 06  	li	a0, 99
     9d8: 63 62 25 0f  	bltu	a0, s2, 0xabc <.Lline_table_start0+0x324>
     9dc: 13 05 a0 00  	li	a0, 10
     9e0: 63 70 a9 14  	bgeu	s2, a0, 0xb20 <.Lline_table_start0+0x388>
     9e4: 13 0a fa ff  	addi	s4, s4, -1
     9e8: 13 05 51 00  	addi	a0, sp, 5
     9ec: 33 05 45 01  	add	a0, a0, s4
     9f0: 93 05 09 03  	addi	a1, s2, 48
     9f4: 23 00 b5 00  	sb	a1, 0(a0)
     9f8: 6f 00 40 15  	j	0xb4c <.Lline_table_start0+0x3b4>
     9fc: 93 0a 00 00  	li	s5, 0
     a00: 13 0b 81 02  	addi	s6, sp, 40
     a04: 93 0b a1 02  	addi	s7, sp, 42
     a08: 37 25 00 00  	lui	a0, 2
     a0c: 93 09 05 71  	addi	s3, a0, 1808
     a10: 37 05 00 50  	lui	a0, 327680
     a14: 13 0c 85 0c  	addi	s8, a0, 200
     a18: 37 e5 f5 05  	lui	a0, 24414
     a1c: 93 0c f5 0f  	addi	s9, a0, 255
     a20: 13 0a 09 00  	mv	s4, s2
     a24: 13 05 09 00  	mv	a0, s2
     a28: 93 85 09 00  	mv	a1, s3
     a2c: 97 00 00 00  	auipc	ra, 0
     a30: e7 80 40 2f  	jalr	756(ra)
     a34: 13 09 05 00  	mv	s2, a0
     a38: 93 85 09 00  	mv	a1, s3
     a3c: 97 00 00 00  	auipc	ra, 0
     a40: e7 80 c0 18  	jalr	396(ra)
     a44: 33 0d aa 40  	sub	s10, s4, a0
     a48: 13 15 0d 01  	slli	a0, s10, 16
     a4c: 13 55 05 01  	srli	a0, a0, 16
     a50: 93 05 40 06  	li	a1, 100
     a54: 97 00 00 00  	auipc	ra, 0
     a58: e7 80 c0 2c  	jalr	716(ra)
     a5c: 93 1d 15 00  	slli	s11, a0, 1
     a60: 93 05 40 06  	li	a1, 100
     a64: 97 00 00 00  	auipc	ra, 0
     a68: e7 80 40 16  	jalr	356(ra)
     a6c: 33 05 ad 40  	sub	a0, s10, a0
     a70: 13 15 15 01  	slli	a0, a0, 17
     a74: b3 0d bc 01  	add	s11, s8, s11
     a78: 83 c5 1d 00  	lbu	a1, 1(s11)
     a7c: 13 55 05 01  	srli	a0, a0, 16
     a80: 33 06 5b 01  	add	a2, s6, s5
     a84: 83 c6 0d 00  	lbu	a3, 0(s11)
     a88: a3 00 b6 00  	sb	a1, 1(a2)
     a8c: 33 05 ac 00  	add	a0, s8, a0
     a90: 83 45 15 00  	lbu	a1, 1(a0)
     a94: 03 45 05 00  	lbu	a0, 0(a0)
     a98: 23 00 d6 00  	sb	a3, 0(a2)
     a9c: 33 86 5b 01  	add	a2, s7, s5
     aa0: a3 00 b6 00  	sb	a1, 1(a2)
     aa4: 23 00 a6 00  	sb	a0, 0(a2)
     aa8: 93 8a ca ff  	addi	s5, s5, -4
     aac: e3 ea 4c f7  	bltu	s9, s4, 0xa20 <.Lline_table_start0+0x288>
     ab0: 13 8a 7a 02  	addi	s4, s5, 39
     ab4: 13 05 30 06  	li	a0, 99
     ab8: e3 72 25 f3  	bgeu	a0, s2, 0x9dc <.Lline_table_start0+0x244>
     abc: 13 15 09 01  	slli	a0, s2, 16
     ac0: 13 55 05 01  	srli	a0, a0, 16
     ac4: 93 05 40 06  	li	a1, 100
     ac8: 97 00 00 00  	auipc	ra, 0
     acc: e7 80 80 25  	jalr	600(ra)
     ad0: 93 09 05 00  	mv	s3, a0
     ad4: 93 05 40 06  	li	a1, 100
     ad8: 97 00 00 00  	auipc	ra, 0
     adc: e7 80 00 0f  	jalr	240(ra)
     ae0: 33 05 a9 40  	sub	a0, s2, a0
     ae4: 13 15 15 01  	slli	a0, a0, 17
     ae8: 13 55 05 01  	srli	a0, a0, 16
     aec: 13 0a ea ff  	addi	s4, s4, -2
     af0: b7 05 00 50  	lui	a1, 327680
     af4: 93 85 85 0c  	addi	a1, a1, 200
     af8: 33 85 a5 00  	add	a0, a1, a0
     afc: 83 45 15 00  	lbu	a1, 1(a0)
     b00: 03 45 05 00  	lbu	a0, 0(a0)
     b04: 13 06 51 00  	addi	a2, sp, 5
     b08: 33 06 46 01  	add	a2, a2, s4
     b0c: a3 00 b6 00  	sb	a1, 1(a2)
     b10: 23 00 a6 00  	sb	a0, 0(a2)
     b14: 13 89 09 00  	mv	s2, s3
     b18: 13 05 a0 00  	li	a0, 10
     b1c: e3 e4 a9 ec  	bltu	s3, a0, 0x9e4 <.Lline_table_start0+0x24c>
     b20: 13 19 19 00  	slli	s2, s2, 1
     b24: 13 0a ea ff  	addi	s4, s4, -2
     b28: 37 05 00 50  	lui	a0, 327680
     b2c: 13 05 85 0c  	addi	a0, a0, 200
     b30: 33 05 25 01  	add	a0, a0, s2
     b34: 83 45 15 00  	lbu	a1, 1(a0)
     b38: 03 45 05 00  	lbu	a0, 0(a0)
     b3c: 13 06 51 00  	addi	a2, sp, 5
     b40: 33 06 46 01  	add	a2, a2, s4
     b44: a3 00 b6 00  	sb	a1, 1(a2)
     b48: 23 00 a6 00  	sb	a0, 0(a2)
     b4c: 13 07 51 00  	addi	a4, sp, 5
     b50: 33 07 47 01  	add	a4, a4, s4
     b54: 13 05 70 02  	li	a0, 39
     b58: b3 07 45 41  	sub	a5, a0, s4
     b5c: 37 05 00 50  	lui	a0, 327680
     b60: 13 06 45 09  	addi	a2, a0, 148
     b64: 13 05 04 00  	mv	a0, s0
     b68: 93 85 04 00  	mv	a1, s1
     b6c: 93 06 00 00  	li	a3, 0
     b70: 97 f0 ff ff  	auipc	ra, 1048575
     b74: e7 80 00 7c  	jalr	1984(ra)
     b78: 83 20 c1 05  	lw	ra, 92(sp)
     b7c: 03 24 81 05  	lw	s0, 88(sp)
     b80: 83 24 41 05  	lw	s1, 84(sp)
     b84: 03 29 01 05  	lw	s2, 80(sp)
     b88: 83 29 c1 04  	lw	s3, 76(sp)
     b8c: 03 2a 81 04  	lw	s4, 72(sp)
     b90: 83 2a 41 04  	lw	s5, 68(sp)
     b94: 03 2b 01 04  	lw	s6, 64(sp)
     b98: 83 2b c1 03  	lw	s7, 60(sp)
     b9c: 03 2c 81 03  	lw	s8, 56(sp)
     ba0: 83 2c 41 03  	lw	s9, 52(sp)
     ba4: 03 2d 01 03  	lw	s10, 48(sp)
     ba8: 83 2d c1 02  	lw	s11, 44(sp)
     bac: 13 01 01 06  	addi	sp, sp, 96
     bb0: 67 80 00 00  	ret

00000bb4 <core::fmt::num::imp::<impl core::fmt::Display for usize>::fmt::hcb9523be2baa3748>:
     bb4: 03 25 05 00  	lw	a0, 0(a0)
     bb8: 13 86 05 00  	mv	a2, a1
     bbc: 93 05 10 00  	li	a1, 1
     bc0: 17 03 00 00  	auipc	t1, 0
     bc4: 67 00 03 dc  	jr	-576(t1)

00000bc8 <__mulsi3>:
     bc8: 13 06 00 00  	li	a2, 0
     bcc: 63 00 05 02  	beqz	a0, 0xbec <.Lline_table_start0+0x454>
     bd0: 93 16 f5 01  	slli	a3, a0, 31
     bd4: 93 d6 f6 41  	srai	a3, a3, 31
     bd8: b3 f6 b6 00  	and	a3, a3, a1
     bdc: 33 86 c6 00  	add	a2, a3, a2
     be0: 13 55 15 00  	srli	a0, a0, 1
     be4: 93 95 15 00  	slli	a1, a1, 1
     be8: e3 14 05 fe  	bnez	a0, 0xbd0 <.Lline_table_start0+0x438>
     bec: 13 05 06 00  	mv	a0, a2
     bf0: 67 80 00 00  	ret

00000bf4 <compiler_builtins::int::specialized_div_rem::u32_div_rem::h07e771e3bc67a4d3>:
     bf4: 13 06 05 00  	mv	a2, a0
     bf8: 63 78 b5 00  	bgeu	a0, a1, 0xc08 <.Lline_table_start0+0x470>
     bfc: 13 05 00 00  	li	a0, 0
     c00: 93 05 06 00  	mv	a1, a2
     c04: 67 80 00 00  	ret
     c08: 13 57 06 01  	srli	a4, a2, 16
     c0c: 33 35 b7 00  	sltu	a0, a4, a1
     c10: 93 46 15 00  	xori	a3, a0, 1
     c14: 13 05 06 00  	mv	a0, a2
     c18: 63 64 b7 00  	bltu	a4, a1, 0xc20 <.Lline_table_start0+0x488>
     c1c: 13 05 07 00  	mv	a0, a4
     c20: 93 96 46 00  	slli	a3, a3, 4
     c24: 93 57 85 00  	srli	a5, a0, 8
     c28: 33 b7 b7 00  	sltu	a4, a5, a1
     c2c: 13 47 17 00  	xori	a4, a4, 1
     c30: 63 e4 b7 00  	bltu	a5, a1, 0xc38 <.Lline_table_start0+0x4a0>
     c34: 13 85 07 00  	mv	a0, a5
     c38: 13 17 37 00  	slli	a4, a4, 3
     c3c: b3 66 d7 00  	or	a3, a4, a3
     c40: 93 57 45 00  	srli	a5, a0, 4
     c44: 33 b7 b7 00  	sltu	a4, a5, a1
     c48: 13 47 17 00  	xori	a4, a4, 1
     c4c: 63 e4 b7 00  	bltu	a5, a1, 0xc54 <.Lline_table_start0+0x4bc>
     c50: 13 85 07 00  	mv	a0, a5
     c54: 13 17 27 00  	slli	a4, a4, 2
     c58: b3 e6 e6 00  	or	a3, a3, a4
     c5c: 93 57 25 00  	srli	a5, a0, 2
     c60: 33 b7 b7 00  	sltu	a4, a5, a1
     c64: 13 47 17 00  	xori	a4, a4, 1
     c68: 63 e4 b7 00  	bltu	a5, a1, 0xc70 <.Lline_table_start0+0x4d8>
     c6c: 13 85 07 00  	mv	a0, a5
     c70: 13 17 17 00  	slli	a4, a4, 1
     c74: 13 55 15 00  	srli	a0, a0, 1
     c78: 33 35 b5 00  	sltu	a0, a0, a1
     c7c: 13 45 15 00  	xori	a0, a0, 1
     c80: 33 65 a7 00  	or	a0, a4, a0
     c84: b3 e6 a6 00  	or	a3, a3, a0
     c88: 33 97 d5 00  	sll	a4, a1, a3
     c8c: 33 06 e6 40  	sub	a2, a2, a4
     c90: 13 05 10 00  	li	a0, 1
     c94: 33 15 d5 00  	sll	a0, a0, a3
     c98: 63 60 b6 08  	bltu	a2, a1, 0xd18 <.Lline_table_start0+0x580>
     c9c: 63 46 07 00  	bltz	a4, 0xca8 <.Lline_table_start0+0x510>
     ca0: 93 07 05 00  	mv	a5, a0
     ca4: 6f 00 80 03  	j	0xcdc <.Lline_table_start0+0x544>
     ca8: 13 57 17 00  	srli	a4, a4, 1
     cac: 93 86 f6 ff  	addi	a3, a3, -1
     cb0: 93 07 10 00  	li	a5, 1
     cb4: b3 97 d7 00  	sll	a5, a5, a3
     cb8: 33 08 e6 40  	sub	a6, a2, a4
     cbc: 93 28 08 00  	slti	a7, a6, 0
     cc0: 93 88 f8 ff  	addi	a7, a7, -1
     cc4: b3 f8 f8 00  	and	a7, a7, a5
     cc8: 63 54 08 00  	bgez	a6, 0xcd0 <.Lline_table_start0+0x538>
     ccc: 13 08 06 00  	mv	a6, a2
     cd0: 33 e5 a8 00  	or	a0, a7, a0
     cd4: 13 06 08 00  	mv	a2, a6
     cd8: 63 60 b8 04  	bltu	a6, a1, 0xd18 <.Lline_table_start0+0x580>
     cdc: 93 87 f7 ff  	addi	a5, a5, -1
     ce0: 63 86 06 02  	beqz	a3, 0xd0c <.Lline_table_start0+0x574>
     ce4: 93 85 06 00  	mv	a1, a3
     ce8: 6f 00 c0 00  	j	0xcf4 <.Lline_table_start0+0x55c>
     cec: 93 85 f5 ff  	addi	a1, a1, -1
     cf0: 63 8e 05 00  	beqz	a1, 0xd0c <.Lline_table_start0+0x574>
     cf4: 13 16 16 00  	slli	a2, a2, 1
     cf8: 33 08 e6 40  	sub	a6, a2, a4
     cfc: 13 08 18 00  	addi	a6, a6, 1
     d00: e3 46 08 fe  	bltz	a6, 0xcec <.Lline_table_start0+0x554>
     d04: 13 06 08 00  	mv	a2, a6
     d08: 6f f0 5f fe  	j	0xcec <.Lline_table_start0+0x554>
     d0c: b3 77 f6 00  	and	a5, a2, a5
     d10: 33 e5 a7 00  	or	a0, a5, a0
     d14: 33 56 d6 00  	srl	a2, a2, a3
     d18: 93 05 06 00  	mv	a1, a2
     d1c: 67 80 00 00  	ret

00000d20 <__udivsi3>:
     d20: 17 03 00 00  	auipc	t1, 0
     d24: 67 00 43 ed  	jr	-300(t1)
