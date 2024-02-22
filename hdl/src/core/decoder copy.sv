// Instruction decoder

module decoder (
    input logic [31:0] instruction,
    output pc_mux_pkg::pc_mux_t pc_mux_select
);
  // R-type
  logic [6:0] funct7;
  logic [4:0] rs2;
  logic [4:0] rs1;
  logic [2:0] funct3;
  logic [4:0] rd;
  logic [6:0] opcode;

  // I type
  logic [11:0] imm_11_0;

  // S type
  logic [6:0] imm_11_5;
  logic [4:0] imm_4_0;

  // B type
  logic imm_12;
  logic [5:0] imm_10_5;
  logic [3:0] imm_4_1;
  logic imm_11b;

  // U type
  logic [19:0] imm_31_12;

  // J type
  logic imm_20;
  logic [9:0] imm_10_1;
  logic imm_11j;
  logic [7:0] imm_19_12;

  logic [31:0] imm;
  logic [31:0] imm_s;
  logic [31:0] imm_i;
  logic [31:0] imm_s;
  logic [31:0] imm_i;
  logic [31:0] imm_s;

  always begin
    // R type
    {funct7, rs2, rs1, funct3, rd, opcode} = instruction;

    // I type
    imm_11_0 = instruction[31:20];

    // S type
    imm_11_5 = instruction[31:25];
    imm_4_0 = instruction[11:7];

    // B type
    {imm_12, imm_10_5} = instruction[31:25];
    {imm_4_1, imm_11b} = instruction[11:7];

    // U type
    imm_31_12 = instruction[31:12];

    // J type
    {imm_20, imm_10_1, imm_11j, imm_19_12} = instruction[31:12];


  end

  // assign pc_mux = pc_mux_pkg::NEXT;
endmodule
