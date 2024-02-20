// can be refined based on mem size

module PcAdder (
    input  logic [31:0] in_pc,
    output logic [31:0] out_pc
);
  assign out_pc = in_pc + 4;
endmodule

