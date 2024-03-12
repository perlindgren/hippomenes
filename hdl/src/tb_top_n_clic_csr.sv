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

  logic [PrioWidth-1:0] level;

  // clock and reset
  initial begin
    $display($time, " << Starting the Simulation >>");

    // Rom for instruction mem content

    // mem[0] = 'h35002373;  // csrr    t1, miselect
    // mem[1] = 'hb00253f3;  // csrrwi  t2, mcycle, 4
    // mem[2] = 'hb0002e73;  // csrr    t3, mcycle
    // mem[3] = 'h0000006f;  // j       0xc <.Lline_table_start0+0xc>

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

    $display("imem.mem[0] %h", top.imem.mem[0]);
    $display("imem.mem[1] %h", top.imem.mem[1]);
    $display("imem.mem[2] %h", top.imem.mem[2]);
    $display("imem.mem[3] %h", top.imem.mem[3]);
    #16;  // wait until reset passed
    $display("csrr    t1, stack_level");
    $display("top.n_clic.level_out %d", top.n_clic.level_out);
    $display("top.n_clic.csr_out %d", top.n_clic.csr_out);

    #24;  // debug at falling edge
    $display("csrrwi  t2, b00, 4");
    $display("rf[7][t1] %h", top.rf.regs[7][6]);
    $display("top.n_clic.m_int_thresh.data %d", top.n_clic.m_int_thresh.data);

    #20;
    $display("csrr    t3, b00");
    $display("rf[7][t1] %h", top.rf.regs[7][6]);
    $display("top.n_clic.m_int_thresh.data %d", top.n_clic.m_int_thresh.data);

    #20;
    $display("j l");

    #20;
    $display("j l");
    $display("rf[7][t1] %h", top.rf.regs[7][6]);
    $display("rf[7][t2] %h", top.rf.regs[7][7]);
    $display("rf[7][t3] %h", top.rf.regs[7][28]);

    $finish;
  end

endmodule
