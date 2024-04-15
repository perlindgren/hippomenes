warning: unknown and unstable feature specified for `-Ctarget-feature`: `zmmul`
  |
  = note: it is still passed through to the codegen backend, but use of this feature might be unsound and the behavior of this feature can change in the future
  = help: consider filing a feature request

warning: 1 warning emitted

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

warning: unknown and unstable feature specified for `-Ctarget-feature`: `zmmul`
  |
  = note: it is still passed through to the codegen backend, but use of this feature might be unsound and the behavior of this feature can change in the future
  = help: consider filing a feature request

warning: 2 warnings emitted

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

warning: unknown and unstable feature specified for `-Ctarget-feature`: `zmmul`
  |
  = note: it is still passed through to the codegen backend, but use of this feature might be unsound and the behavior of this feature can change in the future
  = help: consider filing a feature request

warning: 5 warnings emitted

warning: unknown and unstable feature specified for `-Ctarget-feature`: `zmmul`
  |
  = note: it is still passed through to the codegen backend, but use of this feature might be unsound and the behavior of this feature can change in the future
  = help: consider filing a feature request

warning: 1 warning emitted

warning: unknown and unstable feature specified for `-Ctarget-feature`: `zmmul`
  |
  = note: it is still passed through to the codegen backend, but use of this feature might be unsound and the behavior of this feature can change in the future
  = help: consider filing a feature request

warning: 1 warning emitted


rtic_blinky:	file format elf32-littleriscv

Disassembly of section .text:

00000000 <_start>:
       0: 97 11 00 50  	auipc	gp, 0x50001
       4: 93 81 01 81  	addi	gp, gp, -0x7f0

00000008 <.Lpcrel_hi1>:
       8: 17 13 00 50  	auipc	t1, 0x50001
       c: 13 03 83 ff  	addi	t1, t1, -0x8
      10: 13 71 03 ff  	andi	sp, t1, -0x10

00000014 <.Lpcrel_hi2>:
      14: 97 02 00 50  	auipc	t0, 0x50000
      18: 93 82 c2 ff  	addi	t0, t0, -0x4

0000001c <.Lpcrel_hi3>:
      1c: 97 03 00 50  	auipc	t2, 0x50000
      20: 93 83 43 ff  	addi	t2, t2, -0xc

00000024 <.Lpcrel_hi4>:
      24: 17 03 00 50  	auipc	t1, 0x50000
      28: 13 03 c3 fe  	addi	t1, t1, -0x14
      2c: 63 fc 72 00  	bgeu	t0, t2, 0x44 <.Lpcrel_hi5>
      30: 03 2e 03 00  	lw	t3, 0x0(t1)
      34: 13 03 43 00  	addi	t1, t1, 0x4
      38: 23 a0 c2 01  	sw	t3, 0x0(t0)
      3c: 93 82 42 00  	addi	t0, t0, 0x4
      40: e3 e8 72 fe  	bltu	t0, t2, 0x30 <.Lpcrel_hi4+0xc>

00000044 <.Lpcrel_hi5>:
      44: 97 02 00 50  	auipc	t0, 0x50000
      48: 93 82 c2 fc  	addi	t0, t0, -0x34

0000004c <.Lpcrel_hi6>:
      4c: 97 03 00 50  	auipc	t2, 0x50000
      50: 93 83 43 fc  	addi	t2, t2, -0x3c
      54: 63 f8 72 00  	bgeu	t0, t2, 0x64 <.Lpcrel_hi6+0x18>
      58: 23 a0 02 00  	sw	zero, 0x0(t0)
      5c: 93 82 42 00  	addi	t0, t0, 0x4
      60: e3 ec 72 fe  	bltu	t0, t2, 0x58 <.Lpcrel_hi6+0xc>
      64: 97 00 00 00  	auipc	ra, 0x0
      68: e7 80 80 0f  	jalr	0xf8(ra) <_setup_interrupts>
      6c: 6f 00 80 07  	j	0xe4 <main>

00000070 <DefaultHandler>:
      70: 6f 00 00 00  	j	0x70 <DefaultHandler>

00000074 <Interrupt0>:
      74: 13 01 01 ff  	addi	sp, sp, -0x10
      78: 23 26 11 00  	sw	ra, 0xc(sp)
      7c: 37 05 00 50  	lui	a0, 0x50000
      80: 13 05 15 00  	addi	a0, a0, 0x1
      84: b7 05 00 50  	lui	a1, 0x50000
      88: 93 85 45 00  	addi	a1, a1, 0x4
      8c: 13 06 80 00  	li	a2, 0x8
      90: 97 00 00 00  	auipc	ra, 0x0
      94: e7 80 40 10  	jalr	0x104(ra) <<hippomenes_core::UART as core::fmt::Write>::write_str::h0390e85231b2930c>
      98: 37 05 00 50  	lui	a0, 0x50000
      9c: 03 45 05 00  	lbu	a0, 0x0(a0)
      a0: 63 0e 05 00  	beqz	a0, 0xbc <Interrupt0+0x48>
      a4: 73 f0 00 00  	csrci	0x0, 0x1
      a8: 73 70 01 00  	csrci	0x0, 0x2
      ac: 73 70 02 00  	csrci	0x0, 0x4
      b0: 73 70 04 00  	csrci	0x0, 0x8
      b4: 13 05 00 00  	li	a0, 0x0
      b8: 6f 00 80 01  	j	0xd0 <Interrupt0+0x5c>
      bc: 73 e0 00 00  	csrsi	0x0, 0x1
      c0: 73 60 01 00  	csrsi	0x0, 0x2
      c4: 73 60 02 00  	csrsi	0x0, 0x4
      c8: 73 60 04 00  	csrsi	0x0, 0x8
      cc: 13 05 10 00  	li	a0, 0x1
      d0: b7 05 00 50  	lui	a1, 0x50000
      d4: 23 80 a5 00  	sb	a0, 0x0(a1)
      d8: 83 20 c1 00  	lw	ra, 0xc(sp)
      dc: 13 01 01 01  	addi	sp, sp, 0x10
      e0: 67 80 00 00  	ret

000000e4 <main>:
      e4: 13 01 01 ff  	addi	sp, sp, -0x10
      e8: 23 26 11 00  	sw	ra, 0xc(sp)
      ec: 13 05 80 00  	li	a0, 0x8
      f0: 73 30 05 30  	csrc	mstatus, a0
      f4: 13 05 c0 00  	li	a0, 0xc
      f8: 73 20 05 b2  	csrs	0xb20, a0
      fc: 73 60 01 b2  	csrsi	0xb20, 0x2
     100: 97 00 00 00  	auipc	ra, 0x0
     104: e7 80 c0 00  	jalr	0xc(ra) <rtic_blinky::app::main::__rtic_init_resources::h7c2def6c0d732b8a>
     108: 6f 00 00 00  	j	0x108 <main+0x24>

0000010c <rtic_blinky::app::main::__rtic_init_resources::h7c2def6c0d732b8a>:
     10c: 13 01 01 ff  	addi	sp, sp, -0x10
     110: 23 26 11 00  	sw	ra, 0xc(sp)
     114: 73 e0 00 00  	csrsi	0x0, 0x1
     118: 37 05 00 50  	lui	a0, 0x50000
     11c: 93 05 c5 00  	addi	a1, a0, 0xc
     120: 13 05 b1 00  	addi	a0, sp, 0xb
     124: 13 06 40 00  	li	a2, 0x4
     128: 97 00 00 00  	auipc	ra, 0x0
     12c: e7 80 c0 06  	jalr	0x6c(ra) <<hippomenes_core::UART as core::fmt::Write>::write_str::h0390e85231b2930c>
     130: 73 60 01 00  	csrsi	0x0, 0x2
     134: 37 45 00 00  	lui	a0, 0x4
     138: 13 05 e5 00  	addi	a0, a0, 0xe
     13c: f3 15 05 40  	csrrw	a1, 0x400, a0
     140: 37 05 00 50  	lui	a0, 0x50000
     144: 23 00 05 00  	sb	zero, 0x0(a0)
     148: 13 05 80 00  	li	a0, 0x8
     14c: 73 20 05 30  	csrs	mstatus, a0
     150: 83 20 c1 00  	lw	ra, 0xc(sp)
     154: 13 01 01 01  	addi	sp, sp, 0x10
     158: 67 80 00 00  	ret

0000015c <_setup_interrupts>:
     15c: 37 05 00 00  	lui	a0, 0x0
     160: 13 05 45 07  	addi	a0, a0, 0x74
     164: 13 55 25 00  	srli	a0, a0, 0x2
     168: f3 15 05 b0  	csrrw	a1, mcycle, a0
     16c: 37 05 00 00  	lui	a0, 0x0
     170: 13 05 05 19  	addi	a0, a0, 0x190
     174: 13 55 25 00  	srli	a0, a0, 0x2
     178: f3 15 15 b0  	csrrw	a1, 0xb01, a0
     17c: 37 05 00 00  	lui	a0, 0x0
     180: 13 05 05 19  	addi	a0, a0, 0x190
     184: 13 55 25 00  	srli	a0, a0, 0x2
     188: f3 15 25 b0  	csrrw	a1, minstret, a0
     18c: 67 80 00 00  	ret

00000190 <Interrupt2>:
     190: 6f 00 00 00  	j	0x190 <Interrupt2>

00000194 <<hippomenes_core::UART as core::fmt::Write>::write_str::h0390e85231b2930c>:
     194: 63 0a 06 06  	beqz	a2, 0x208 <<hippomenes_core::UART as core::fmt::Write>::write_str::h0390e85231b2930c+0x74>
     198: 13 01 01 fe  	addi	sp, sp, -0x20
     19c: 23 2e 11 00  	sw	ra, 0x1c(sp)
     1a0: 23 2c 81 00  	sw	s0, 0x18(sp)
     1a4: 23 2a 91 00  	sw	s1, 0x14(sp)
     1a8: 23 28 21 01  	sw	s2, 0x10(sp)
     1ac: 13 04 06 00  	mv	s0, a2
     1b0: 6f 00 00 03  	j	0x1e0 <<hippomenes_core::UART as core::fmt::Write>::write_str::h0390e85231b2930c+0x4c>
     1b4: 33 89 95 00  	add	s2, a1, s1
     1b8: 23 26 01 00  	sw	zero, 0xc(sp)
     1bc: 13 05 c1 00  	addi	a0, sp, 0xc
     1c0: 13 86 04 00  	mv	a2, s1
     1c4: 97 00 00 00  	auipc	ra, 0x0
     1c8: e7 80 c0 04  	jalr	0x4c(ra) <memcpy>
     1cc: 03 25 c1 00  	lw	a0, 0xc(sp)
     1d0: 73 10 05 05  	csrw	0x50, a0
     1d4: 33 04 94 40  	sub	s0, s0, s1
     1d8: 93 05 09 00  	mv	a1, s2
     1dc: 63 0c 04 00  	beqz	s0, 0x1f4 <<hippomenes_core::UART as core::fmt::Write>::write_str::h0390e85231b2930c+0x60>
     1e0: 13 05 40 00  	li	a0, 0x4
     1e4: 93 04 04 00  	mv	s1, s0
     1e8: e3 66 a4 fc  	bltu	s0, a0, 0x1b4 <<hippomenes_core::UART as core::fmt::Write>::write_str::h0390e85231b2930c+0x20>
     1ec: 93 04 40 00  	li	s1, 0x4
     1f0: 6f f0 5f fc  	j	0x1b4 <<hippomenes_core::UART as core::fmt::Write>::write_str::h0390e85231b2930c+0x20>
     1f4: 83 20 c1 01  	lw	ra, 0x1c(sp)
     1f8: 03 24 81 01  	lw	s0, 0x18(sp)
     1fc: 83 24 41 01  	lw	s1, 0x14(sp)
     200: 03 29 01 01  	lw	s2, 0x10(sp)
     204: 13 01 01 02  	addi	sp, sp, 0x20
     208: 13 05 00 00  	li	a0, 0x0
     20c: 67 80 00 00  	ret

00000210 <memcpy>:
     210: 13 01 01 ff  	addi	sp, sp, -0x10
     214: 23 26 11 00  	sw	ra, 0xc(sp)
     218: 23 24 81 00  	sw	s0, 0x8(sp)
     21c: 13 04 01 01  	addi	s0, sp, 0x10
     220: 83 20 c1 00  	lw	ra, 0xc(sp)
     224: 03 24 81 00  	lw	s0, 0x8(sp)
     228: 13 01 01 01  	addi	sp, sp, 0x10
     22c: 17 03 00 00  	auipc	t1, 0x0
     230: 67 00 83 00  	jr	0x8(t1) <compiler_builtins::mem::memcpy::h17df5e2a3935259f>

00000234 <compiler_builtins::mem::memcpy::h17df5e2a3935259f>:
     234: 13 01 01 ff  	addi	sp, sp, -0x10
     238: 23 26 11 00  	sw	ra, 0xc(sp)
     23c: 23 24 81 00  	sw	s0, 0x8(sp)
     240: 13 04 01 01  	addi	s0, sp, 0x10
     244: 93 06 00 01  	li	a3, 0x10
     248: 63 68 d6 08  	bltu	a2, a3, 0x2d8 <compiler_builtins::mem::memcpy::h17df5e2a3935259f+0xa4>
     24c: b3 06 a0 40  	neg	a3, a0
     250: 93 f6 36 00  	andi	a3, a3, 0x3
     254: 33 07 d5 00  	add	a4, a0, a3
     258: 63 80 06 02  	beqz	a3, 0x278 <compiler_builtins::mem::memcpy::h17df5e2a3935259f+0x44>
     25c: 93 07 05 00  	mv	a5, a0
     260: 13 88 05 00  	mv	a6, a1
     264: 83 48 08 00  	lbu	a7, 0x0(a6)
     268: 23 80 17 01  	sb	a7, 0x0(a5)
     26c: 93 87 17 00  	addi	a5, a5, 0x1
     270: 13 08 18 00  	addi	a6, a6, 0x1
     274: e3 e8 e7 fe  	bltu	a5, a4, 0x264 <compiler_builtins::mem::memcpy::h17df5e2a3935259f+0x30>
     278: b3 85 d5 00  	add	a1, a1, a3
     27c: 33 06 d6 40  	sub	a2, a2, a3
     280: 93 77 c6 ff  	andi	a5, a2, -0x4
     284: 13 f8 35 00  	andi	a6, a1, 0x3
     288: b3 06 f7 00  	add	a3, a4, a5
     28c: 63 0c 08 04  	beqz	a6, 0x2e4 <compiler_builtins::mem::memcpy::h17df5e2a3935259f+0xb0>
     290: 63 58 f0 06  	blez	a5, 0x300 <compiler_builtins::mem::memcpy::h17df5e2a3935259f+0xcc>
     294: 93 98 35 00  	slli	a7, a1, 0x3
     298: 13 f8 88 01  	andi	a6, a7, 0x18
     29c: 93 f2 c5 ff  	andi	t0, a1, -0x4
     2a0: 03 a3 02 00  	lw	t1, 0x0(t0)
     2a4: b3 08 10 41  	neg	a7, a7
     2a8: 93 f8 88 01  	andi	a7, a7, 0x18
     2ac: 93 82 42 00  	addi	t0, t0, 0x4
     2b0: 83 a3 02 00  	lw	t2, 0x0(t0)
     2b4: 33 53 03 01  	srl	t1, t1, a6
     2b8: 33 9e 13 01  	sll	t3, t2, a7
     2bc: 33 63 6e 00  	or	t1, t3, t1
     2c0: 23 20 67 00  	sw	t1, 0x0(a4)
     2c4: 13 07 47 00  	addi	a4, a4, 0x4
     2c8: 93 82 42 00  	addi	t0, t0, 0x4
     2cc: 13 83 03 00  	mv	t1, t2
     2d0: e3 60 d7 fe  	bltu	a4, a3, 0x2b0 <compiler_builtins::mem::memcpy::h17df5e2a3935259f+0x7c>
     2d4: 6f 00 c0 02  	j	0x300 <compiler_builtins::mem::memcpy::h17df5e2a3935259f+0xcc>
     2d8: 93 06 05 00  	mv	a3, a0
     2dc: 63 18 06 02  	bnez	a2, 0x30c <compiler_builtins::mem::memcpy::h17df5e2a3935259f+0xd8>
     2e0: 6f 00 40 04  	j	0x324 <compiler_builtins::mem::memcpy::h17df5e2a3935259f+0xf0>
     2e4: 63 5e f0 00  	blez	a5, 0x300 <compiler_builtins::mem::memcpy::h17df5e2a3935259f+0xcc>
     2e8: 13 88 05 00  	mv	a6, a1
     2ec: 83 28 08 00  	lw	a7, 0x0(a6)
     2f0: 23 20 17 01  	sw	a7, 0x0(a4)
     2f4: 13 07 47 00  	addi	a4, a4, 0x4
     2f8: 13 08 48 00  	addi	a6, a6, 0x4
     2fc: e3 68 d7 fe  	bltu	a4, a3, 0x2ec <compiler_builtins::mem::memcpy::h17df5e2a3935259f+0xb8>
     300: b3 85 f5 00  	add	a1, a1, a5
     304: 13 76 36 00  	andi	a2, a2, 0x3
     308: 63 0e 06 00  	beqz	a2, 0x324 <compiler_builtins::mem::memcpy::h17df5e2a3935259f+0xf0>
     30c: 33 86 c6 00  	add	a2, a3, a2
     310: 03 c7 05 00  	lbu	a4, 0x0(a1)
     314: 23 80 e6 00  	sb	a4, 0x0(a3)
     318: 93 86 16 00  	addi	a3, a3, 0x1
     31c: 93 85 15 00  	addi	a1, a1, 0x1
     320: e3 e8 c6 fe  	bltu	a3, a2, 0x310 <compiler_builtins::mem::memcpy::h17df5e2a3935259f+0xdc>
     324: 83 20 c1 00  	lw	ra, 0xc(sp)
     328: 03 24 81 00  	lw	s0, 0x8(sp)
     32c: 13 01 01 01  	addi	sp, sp, 0x10
     330: 67 80 00 00  	ret
