// Data memory

module tb_dmem;
  import config_pkg::*;

    bit [DMemAddrWidth-1:0] address;

    dmem dut (
        .address(address)
    );

  initial begin
    $dumpfile("dmem.fst");
    $dumpvars;

    address = 0;

    #10 $finish;
  end
endmodule
