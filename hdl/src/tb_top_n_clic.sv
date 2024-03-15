// tb_top_n_clic
`timescale 1ns / 1ps

module tb_top_n_clic;
  import config_pkg::*;
  import decoder_pkg::*;

  logic clk;
  logic reset;
  logic led;
  (* DONT_TOU CH = "TRUE" *)
  top_n_clic top (
      .clk  (clk),
      .reset(reset),
      .led  (led)
  );
  logic [31:0] mem[IMemSize >> 2];
  logic [PrioWidth-1:0] level;

  // clock and reset
  initial begin
    $display($time, " << Starting the Simulation >>");
    $display("memsize %h", IMemSize >> 2);
    // Rom for instruction mem content
    $display("Loading memory file binary.mem");
    $readmemh("binary.mem", top.imem.mem);
    //top.imem.mem = mem;

    reset = 1;
    clk   = 0;
    #15 reset = 0;
  end

  always #10 begin
    clk = ~clk;
    if (clk) $display(">>>>>>>>>>>>> clk posedge", $time);
  end

  initial begin
    $dumpfile("top_n_clic.fst");
    $dumpvars;
    $display("mem : %h, %h, %h, %h", top.imem.mem[0], top.imem.mem[1], top.imem.mem[2],
             top.imem.mem['hB00>>2]);
    #20 assert (top.imem.address == 'h0);
    #20 assert (top.imem.address == 'h4);
    #20 assert (top.imem.address == 'h8);
    #20 assert (top.imem.address == 'hc);
    #20 assert (top.imem.address == 'h10);
    #20 assert (top.imem.address == 'h14);
    #20 assert (top.imem.address == 'h18);
    #20 assert (top.imem.address == 'h1c);
    #20 assert (top.imem.address == 'h20);
    #20 assert (top.imem.address == 'h24);
    #20 assert (top.imem.address == 'h28);
    #20 assert (top.imem.address == 'h2c);
    #20 assert (top.imem.address == 'h30);  // interrupt triggered
    #20 assert (top.imem.address == 'h34);
    #20 assert (top.imem.address == 'h38);
    #20 assert (top.imem.address == 'h3c);
    #20 assert (top.imem.address == 'h40);
    #20 assert (top.imem.address == 'h44);
    #20 assert (top.imem.address == 'h48);
    #20 assert (top.imem.address == 'h4c);
    #20 assert (top.imem.address == 'h50);
    #20 assert (top.imem.address == 'h2c);
    #20 assert (top.imem.address == 'h2c);
    #20 assert (top.imem.address == 'h2c);
    #20 assert (top.imem.address == 'h2c);
    #20 assert (top.imem.address == 'h2c);
    #20 assert (top.imem.address == 'h2c);
    #20 assert (top.imem.address == 'h30);  // 2nd timer interrupt here
    $finish;
  end

endmodule
