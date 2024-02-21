// tb_register_file
import decoder_pkg::*;
module tb_decoder;

  logic [31:0] instr;
  pc_mux_t pc_mux_sel;
  wb_data_mux_t wb_data_mux_sel;
  wb_reg_mux_t wb_reg_mux_sel;
  logic wb_enable;
  alu_a_mux_t alu_a_mux_sel;
  alu_b_mux_t alu_b_mux_sel;

  decoder dut (
      .instr(instr),
      .pc_mux_sel(pc_mux_sel),
      .wb_data_mux_sel(wb_data_mux_sel),
      .wb_reg_mux_sel(wb_reg_mux_sel),
      .wb_enable(wb_enable),
      .alu_a_mux_sel(alu_a_mux_sel),
      .alu_b_mux_sel(alu_b_mux_sel)
  );

  initial begin
    $dumpfile("decoder.fst");
    $dumpvars;

    instr = 0;
    #10 $finish;
    // highest entry (leftmost), represent the threshold
    // all at prio zero
    // entries = {{3'b000}, {3'b000}, {3'b000}, {3'b000}};
    // #10 $display("(0), is_interrupt %d, index %d", is_interrupt, index);
    // assert (is_interrupt == 0 && index == 3) $display("filtered by threshold");
    // else $error("should be filtered by threshold");

  end
endmodule
