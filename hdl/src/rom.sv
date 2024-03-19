// rom
`timescale 1ns / 1ps

module rom
  import config_pkg::*;
  import mem_pkg::*;
#(
    parameter integer unsigned MemSize = 'h0000_1000,
    localparam integer MemAddrWidth = $clog2(MemSize)  // derived
) (
    input logic clk,
    input logic [MemAddrWidth-1:0] address,

    output logic [31:0] data_out
);

  word mem[MemSize >> 2];
  integer errno;
  integer fd;
  string error_msg;
  assign data_out = mem[address[MemAddrWidth-1:2]];

  initial begin
    for (integer k = 0; k < MemSize >> 2; k++) begin
      mem[k] = 0;
    end
    $display("Loading memory file binary.mem");
    // use binary.mem from rust_examples dir (works with verilator)
    $readmemh("../../rust_examples/binary.mem", mem);
    errno = $ferror(fd, error_msg);
    // vivado does not support IO errors for whatever reason, always returning an error code.
    // we can use this to detect we are running vivado at least...
    if (errno == -1 | errno == 2) begin
        // if reading ../../rust_examples/binary.mem returns error, we are (probably) running vivado
        // try reading the imported binary.mem source and pray to God that doesn't fail
        $readmemh("binary.mem", mem);
        // ideally we would detect an error here and throw a fatal, but we can't :)
      /*if (errno == -1 | errno == 2) begin
            $display("ERRNO = %d", vivado_errno);
            $fatal("Could not find binary.mem");
        end*/
    end


    // test csr
    //  0: 73 23 00 35   csrr    t1, miselect
    //  4: f3 53 02 b0   csrrwi  t2, mcycle, 4
    //  8: 73 2e 00 b0   csrr    t3, mcycle
    //  c: 6f 00 00 00   j       0xc <.Lline_table_start0+0xc>

    // mem[0] = 'h35002373;  // csrr    t1, miselect
    // mem[1] = 'hb00253f3;  // csrrwi  t2, mcycle, 4
    // mem[2] = 'hb0002e73;  // csrr    t3, mcycle
    // mem[3] = 'h0000006f;  // j       0xc <.Lline_table_start0+0xc>

    // 00000000 <l>:
    //    0:  b000d073            .insn 4, 0xb000d073
    //    4:  b0005073            .insn 4, 0xb0005073
    //    8:  ff9ff06f            j 0 <l>
    // simple blink loop
    // mem[0] = 'h0000d073;
    // mem[1] = 'h00005073;
    // mem[2] = 'hff9ff06f;

    // test interrupt return
    // // notice raw access to memory is in words
    // mem[0]  = 'h50000117;  // auipc   sp,0x50000
    // mem[1]  = 'h50010113;  // addi    sp,sp,1280 # 50000500
    // mem[2]  = 'h35015073;  // CSR this does nothing
    // mem[3]  = 'h02300393;  // addi t2, zero, 140>>2 # ISR address
    // mem[4]  = 'h00f00313;  // addi t1, zero, 0b1111 # prio 3, enabled, pended
    // mem[5]  = 'hb0139073;  // csrrw zero, 0xB01, t2 # write ISR address to vector 1
    // mem[6]  = 'hb2131073;  // csrrw zero, 0xB21, t1 # write to config to entry 1, pend
    // mem[7]  = 'hffdff06f;  // jal zero, zero, i.e. loop forever here

    // //ISR
    // mem[35] = 'h0000d073;  // on
    // mem[36] = 'h0000d073;  // on
    // mem[37] = 'h0000d073;  // on
    // mem[38] = 'h0000d073;  // on
    // mem[39] = 'h00005073;  // off

    // mem[40] = 'h00008067;  // jalr zero ra, i.e. ret

    // test timer
    //     00000000 <init>:
    //    0:	50000117          	auipc	sp,0x50000
    //    4:	50010113          	addi	sp,sp,1280 # 50000500 <_stack_start>
    //    8:	35015073          	.4byte	0x35015073

    // 0000000c <main>:
    //    c:	30045073          	.4byte	0x30045073
    //   10:	00000317          	auipc	t1,0x0
    //   14:	02430313          	addi	t1,t1,36 # 34 <isr_0>
    //   18:	00235313          	srli	t1,t1,0x2
    //   1c:	b0031073          	.4byte	0xb0031073
    //   20:	0f000393          	li	t2,240
    //   24:	40039073          	.4byte	0x40039073
    //   28:	01e00313          	li	t1,30
    //   2c:	b2031073          	.4byte	0xb2031073

    // 00000030 <stop>:
    //   30:	0000006f          	j	30 <stop>

    // 00000034 <isr_0>:
    //   34:	50000297          	auipc	t0,0x50000
    //   38:	fcc28293          	addi	t0,t0,-52 # 50000000 <.toggled>
    //   3c:	0002a303          	lw	t1,0(t0)
    //   40:	00134313          	xori	t1,t1,1
    //   44:	00031073          	.4byte	0x31073
    //   48:	0062a023          	sw	t1,0(t0)
    //   4c:	b4002e73          	.4byte	0xb4002e73
    //   50:  01c2a223            sw      t3, 4(t0)
    //   54:	00008067          	ret


    /*
    mem[0]  = 'h50000117;  //          	auipc	sp,0x50000
    mem[1]  = 'h50010113;  //          	addi	sp,sp,1280 # 50000500 <_stack_start>
    mem[2]  = 'h35015073;  //          	.4byte	0x35015073
    //000c <main>:
    mem[3]  = 'h30045073;  //
    mem[4]  = 'h00000317;  //
    mem[5]  = 'h02430313;  //
    mem[6]  = 'h00235313;  //
    mem[7]  = 'hb0031073;  //
    mem[8]  = 'h0f000393;  //
    mem[9]  = 'h40039073;  //
    mem[10] = 'h01e00313;  //
    mem[11] = 'hb2031073;  //
    mem[12] = 'h0000006f;  //
    mem[13] = 'h50000297;  //
    mem[14] = 'hfcc28293;  //
    mem[15] = 'h0002a303;  //
    mem[16] = 'h00134313;  //
    mem[17] = 'h00031073;  //
    // mem[17] = 'hb4002e73;  // read csr
    mem[18] = 'h0062a023;  //
    mem[19] = 'hb4002e73;  //
    mem[20] = 'h01c2a223;
    mem[21] = 'h00008067;  //*/
  end

endmodule
