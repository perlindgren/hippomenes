// tb_top_n_clic
`timescale 1ns / 1ps

module tb_top_n_clic;
  import config_pkg::*;
  import decoder_pkg::*;

  logic clk;
  logic reset;
  logic led;
  (* DONT_TOUCH = "TRUE" *)
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
    $readmemh("binary.mem", top.imem.mem, 0, 8);
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
    #20 $display("pc: %h", top.imem.address);
    $display("sp: %h", top.rf.regs[0][2]);
    $display("t0: %h", top.rf.regs[top.rf.level][5]);
    #20 $display("pc: %h", top.imem.address);
    $display("sp: %h", top.rf.regs[0][2]);
    $display("t0: %h", top.rf.regs[top.rf.level][5]);
    #20 $display("pc: %h", top.imem.address);
    $display("sp: %h", top.rf.regs[0][2]);
    $display("t0: %h", top.rf.regs[top.rf.level][5]);
    #20 $display("pc: %h", top.imem.address);
    $display("sp: %h", top.rf.regs[0][2]);
    $display("t0: %h", top.rf.regs[top.rf.level][5]);
    #20 $display("pc: %h", top.imem.address);
    $display("sp: %h", top.rf.regs[0][2]);
    $display("t0: %h", top.rf.regs[top.rf.level][5]);
    #20 $display("pc: %h", top.imem.address);
    $display("sp: %h", top.rf.regs[0][2]);
    $display("t0: %h", top.rf.regs[top.rf.level][5]);
    #20 $display("pc: %h", top.imem.address);
    $display("sp: %h", top.rf.regs[0][2]);
    $display("t0: %h", top.rf.regs[top.rf.level][5]);
    #20 $display("pc: %h", top.imem.address);
    $display("sp: %h", top.rf.regs[0][2]);
    $display("t0: %h", top.rf.regs[top.rf.level][5]);
    #20 $display("pc: %h", top.imem.address);
    $display("sp: %h", top.rf.regs[0][2]);
    $display("t0: %h", top.rf.regs[top.rf.level][5]);
    #20 $display("pc: %h", top.imem.address);
    $display("sp: %h", top.rf.regs[0][2]);
    $display("t0: %h", top.rf.regs[top.rf.level][5]);
    #20 $display("pc: %h", top.imem.address);
    $display("sp: %h", top.rf.regs[0][2]);
    $display("t0: %h", top.rf.regs[top.rf.level][5]);
    #20 $display("pc: %h", top.imem.address);
    $display("sp: %h", top.rf.regs[0][2]);
    $display("t0: %h", top.rf.regs[top.rf.level][5]);
    #20 $display("pc: %h", top.imem.address);
    $display("sp: %h", top.rf.regs[0][2]);
    $display("t0: %h", top.rf.regs[top.rf.level][5]);
    #20 $display("pc: %h", top.imem.address);
    $display("sp: %h", top.rf.regs[0][2]);
    $display("t0: %h", top.rf.regs[top.rf.level][5]);
    #20 $display("pc: %h", top.imem.address);
    $display("sp: %h", top.rf.regs[0][2]);
    $display("t0: %h", top.rf.regs[top.rf.level][5]);
    #20 $display("pc: %h", top.imem.address);
    $display("sp: %h", top.rf.regs[0][2]);
    $display("t0: %h", top.rf.regs[top.rf.level][5]);
    #20 $display("pc: %h", top.imem.address);
    $display("sp: %h", top.rf.regs[0][2]);
    $display("t0: %h", top.rf.regs[top.rf.level][5]);
    #20 $display("pc: %h", top.imem.address);
    $display("sp: %h", top.rf.regs[0][2]);
    $display("t0: %h", top.rf.regs[top.rf.level][5]);
    #20 $display("pc: %h", top.imem.address);
    $display("sp: %h", top.rf.regs[0][2]);
    $display("t0: %h", top.rf.regs[top.rf.level][5]);
    $finish;
  end

endmodule
