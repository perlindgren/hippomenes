// rom
`timescale 1ns / 1ps

module rom
  import config_pkg::*;
  import mem_pkg::*;
#(
    parameter integer MemSize = 'h0000_1000,
    localparam integer MemAddrWidth = $clog2(MemSize)  // derived
) (
    input logic clk,
    input logic [MemAddrWidth-1:0] address,

    output logic [31:0] data_out
);

  logic [31:0] mem[MemSize >> 2];

  always_comb begin
    data_out = mem[address[MemAddrWidth-1:2]];
  end

  always_comb begin

    // test csr
    //  0: 73 23 00 35   csrr    t1, miselect
    //  4: f3 53 02 b0   csrrwi  t2, mcycle, 4
    //  8: 73 2e 00 b0   csrr    t3, mcycle
    //  c: 6f 00 00 00   j       0xc <.Lline_table_start0+0xc>

    mem[0] = 'h35002373;  // csrr    t1, miselect
    mem[1] = 'hb00253f3;  // csrrwi  t2, mcycle, 4
    mem[2] = 'hb0002e73;  // csrr    t3, mcycle
    mem[3] = 'h0000006f;  // j       0xc <.Lline_table_start0+0xc>

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

  end

endmodule
