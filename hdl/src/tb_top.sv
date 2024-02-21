// top module

module tb_top;

  logic clk;
  logic reset;

  logic [31:0] pc_reg_out;

  pc_mux_pkg::state_t pc_select;
  logic [31:0] pc_plus_4;
  logic [31:0] pc_branch;
  logic [31:0] pc_next;
  logic [31:0] pc;


  // instances
  pc_mux pc_mux (
      .select(pc_select),
      .next(pc_plus_4),
      .branch(pc_branch),
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

  // clock and reset
  initial begin
    $display($time, " << Starting the Simulation >>");
    reset = 1;
    clk   = 0;
    #5 reset = 0;
  end

  always #10 clk = ~clk;

  initial begin
    $dumpfile("top.fst");
    $dumpvars;

    pc_select = pc_mux_pkg::NEXT;
    pc_branch = 'hdead_beef;





    #100 $finish;
  end

endmodule
