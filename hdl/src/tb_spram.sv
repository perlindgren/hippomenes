// tb_mem
`timescale 1ns / 1ps

module tb_spram;
  import config_pkg::*;


  logic clk;
  IMemAddrT address;
  IMemDataT data_out;
  
  spram dut (
      .clk(clk),
      .address(address),
      .data_out(data_out)
  );


  always #10 clk = ~clk;
  
  initial begin
    $dumpfile("spram.fst");
    $dumpvars;
    
    clk = 0;
    
    address = 0;
    $display(data_out);
    
    #10;
    
    $display(data_out);
    
    #10;

    $display(data_out);

    address = 4;
    
    #20;
    
    $display(data_out);
        
    $finish;
  end
endmodule
