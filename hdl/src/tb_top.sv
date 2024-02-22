// top module

module tb_top;
  import config_pkg::*;
  import decoder_pkg::*;

  logic clk;
  logic reset;

  logic [31:0] pc_reg_out;

  pc_mux_t pc_sel;
  logic [31:0] pc_plus_4;
  logic [31:0] pc_branch;
  logic [31:0] pc_next;
  logic [31:0] pc;
  logic [IMemAddrWidth -1:0] pc_imem;
  logic i_alignment_error;
  logic [31:0] instr;


  // instances
  pc_mux pc_mux (
      .sel(pc_sel),
      .pc_next(pc_plus_4),
      .pc_branch(pc_branch),
      .out(pc_next)
  );

  pc_adder pc_adder (
      .in (pc),
      .out(pc_plus_4)
  );

  reg32 pc_reg (
      .clk(clk),
      .reset(reset),
      .in(pc_next),
      .out(pc)
  );

  mem imem (
      .clk(clk),
      .write_enable(0),  // we never write to instruction memory
      .width(mem_pkg::WORD),  // always read words
      .sign_extend(0),  // not used
      .address(pc_imem),
      .data_in(0),
      .data_out(instr),
      .alignment_error(i_alignment_error)
  );



  // clock and reset
  initial begin
    $display($time, " << Starting the Simulation >>");
    reset = 1;
    clk   = 0;
    #5 reset = 0;
  end

  always #10 clk = ~clk;
  always pc_imem = pc[IMemAddrWidth-1:0];

  initial begin
    $dumpfile("top.fst");
    $dumpvars;

    // #10;

    $display("0 %h", imem.mem[0]);
    $display("4 %h", imem.mem[4]);

    pc_sel = PC_NEXT;
    pc_branch = 'hdead_beef;

    #100 $finish;
  end

endmodule
