
./riscv_asm/target/riscv32i-unknown-none-elf/release/riscv_asm:     file format elf32-littleriscv


Disassembly of section .text:

00000000 <init>:
   0:	50000117          	auipc	sp,0x50000
   4:	50010113          	addi	sp,sp,1280 # 50000500 <_stack_start>

00000008 <main>:
   8:	30045073          	.4byte	0x30045073
   c:	00000317          	auipc	t1,0x0
  10:	02430313          	addi	t1,t1,36 # 30 <isr_0>
  14:	00035313          	srli	t1,t1,0x0
  18:	b0031073          	.4byte	0xb0031073
  1c:	0f000393          	li	t2,240
  20:	40039073          	.4byte	0x40039073
  24:	00e00313          	li	t1,14
  28:	b2031073          	.4byte	0xb2031073

0000002c <stop>:
  2c:	0000006f          	j	2c <stop>

00000030 <isr_0>:
  30:	50000297          	auipc	t0,0x50000
  34:	fd028293          	addi	t0,t0,-48 # 50000000 <.toggled>
  38:	0002a303          	lw	t1,0(t0)
  3c:	00134313          	xori	t1,t1,1
  40:	00031073          	.4byte	0x31073
  44:	0062a023          	sw	t1,0(t0)
  48:	b4002e73          	.4byte	0xb4002e73
  4c:	01c2a223          	sw	t3,4(t0)
  50:	00008067          	ret
