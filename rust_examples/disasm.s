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


asm_timer_task:	file format elf32-littleriscv

Disassembly of section .text:

00000000 <init>:
       0: 17 01 01 00  	auipc	sp, 0x10
       4: 13 01 01 50  	addi	sp, sp, 0x500

00000008 <.Lpcrel_hi1>:
       8: 97 02 00 50  	auipc	t0, 0x50000
       c: 93 82 82 ff  	addi	t0, t0, -0x8
      10: 23 a0 02 00  	sw	zero, 0x0(t0)

00000014 <main>:
      14: 73 50 04 30  	csrwi	mstatus, 0x8
      18: 17 03 00 00  	auipc	t1, 0x0
      1c: 13 03 43 02  	addi	t1, t1, 0x24
      20: 13 53 23 00  	srli	t1, t1, 0x2
      24: 73 10 03 b0  	csrw	mcycle, t1
      28: 93 03 00 0f  	li	t2, 0xf0
      2c: 73 90 03 40  	csrw	0x400, t2
      30: 13 03 e0 00  	li	t1, 0xe
      34: 73 10 03 b2  	csrw	0xb20, t1

00000038 <stop>:
      38: 6f 00 00 00  	j	0x38 <stop>

0000003c <isr_0>:
      3c: 97 02 00 50  	auipc	t0, 0x50000
      40: 93 82 42 fc  	addi	t0, t0, -0x3c
      44: 03 a3 02 00  	lw	t1, 0x0(t0)
      48: 13 43 13 00  	xori	t1, t1, 0x1
      4c: 73 10 03 00  	csrw	0x0, t1
      50: 23 a0 62 00  	sw	t1, 0x0(t0)
      54: 73 2e 00 b4  	csrr	t3, 0xb40
      58: 23 a2 c2 01  	sw	t3, 0x4(t0)
      5c: 67 80 00 00  	ret
