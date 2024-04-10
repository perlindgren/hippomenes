// removed package "config_pkg"
// Trace: ../../../hdl/src/core/decoder_pkg.sv:4:1
// removed ["import config_pkg::*;"]
// removed package "decoder_pkg"
// removed package "mem_pkg"
// Trace: ../../../hdl/src/core/alu.sv:4:1
// removed ["import decoder_pkg::*;"]
module alu (
	a,
	b,
	sub_arith,
	op,
	res
);
	// Trace: ../../../hdl/src/core/alu.sv:6:5
	// removed localparam type decoder_pkg_word
	input wire [31:0] a;
	// Trace: ../../../hdl/src/core/alu.sv:7:5
	input wire [31:0] b;
	// Trace: ../../../hdl/src/core/alu.sv:8:5
	input wire sub_arith;
	// Trace: ../../../hdl/src/core/alu.sv:9:5
	// removed localparam type decoder_pkg_alu_op_t
	input wire [2:0] op;
	// Trace: ../../../hdl/src/core/alu.sv:11:5
	output reg [31:0] res;
	// Trace: ../../../hdl/src/core/alu.sv:14:3
	always @(*)
		// Trace: ../../../hdl/src/core/alu.sv:15:5
		case (op)
			3'b000:
				// Trace: ../../../hdl/src/core/alu.sv:16:17
				res = a + b;
			3'b001:
				// Trace: ../../../hdl/src/core/alu.sv:17:17
				res = a << b[4:0];
			3'b010:
				// Trace: ../../../hdl/src/core/alu.sv:18:17
				res = {31'sd0, $signed(a) < $signed(b)};
			3'b011:
				// Trace: ../../../hdl/src/core/alu.sv:19:17
				res = {31'sd0, $unsigned(a) < $unsigned(b)};
			3'b100:
				// Trace: ../../../hdl/src/core/alu.sv:20:17
				res = a ^ b;
			3'b101:
				if (sub_arith)
					// Trace: ../../../hdl/src/core/alu.sv:21:32
					res = $signed(a) >>> b[4:0];
				else
					// Trace: ../../../hdl/src/core/alu.sv:22:7
					res = a >> b[4:0];
			3'b110:
				// Trace: ../../../hdl/src/core/alu.sv:23:17
				res = a | b;
			3'b111:
				// Trace: ../../../hdl/src/core/alu.sv:24:17
				res = a & b;
			default:
				// Trace: ../../../hdl/src/core/alu.sv:25:17
				res = 0;
		endcase
endmodule
// Trace: ../../../hdl/src/core/alu_a_mux.sv:4:1
// removed ["import decoder_pkg::*;"]
module alu_a_mux (
	sel,
	imm,
	rs1,
	zero,
	out
);
	// Trace: ../../../hdl/src/core/alu_a_mux.sv:6:5
	// removed localparam type decoder_pkg_alu_a_mux_t
	input wire [1:0] sel;
	// Trace: ../../../hdl/src/core/alu_a_mux.sv:7:5
	// removed localparam type decoder_pkg_word
	input wire [31:0] imm;
	// Trace: ../../../hdl/src/core/alu_a_mux.sv:8:5
	input wire [31:0] rs1;
	// Trace: ../../../hdl/src/core/alu_a_mux.sv:9:5
	input wire [31:0] zero;
	// Trace: ../../../hdl/src/core/alu_a_mux.sv:10:5
	output reg [31:0] out;
	// Trace: ../../../hdl/src/core/alu_a_mux.sv:13:3
	always @(*)
		// Trace: ../../../hdl/src/core/alu_a_mux.sv:14:5
		case (sel)
			2'b00:
				// Trace: ../../../hdl/src/core/alu_a_mux.sv:15:16
				out = imm;
			2'b01:
				// Trace: ../../../hdl/src/core/alu_a_mux.sv:16:16
				out = rs1;
			2'b10:
				// Trace: ../../../hdl/src/core/alu_a_mux.sv:17:16
				out = zero;
			default:
				// Trace: ../../../hdl/src/core/alu_a_mux.sv:18:16
				out = imm;
		endcase
endmodule
// Trace: ../../../hdl/src/core/alu_b_mux.sv:4:1
// removed ["import decoder_pkg::*;"]
module alu_b_mux (
	sel,
	rs2,
	imm,
	pc_plus_4,
	pc,
	out
);
	// Trace: ../../../hdl/src/core/alu_b_mux.sv:6:5
	// removed localparam type decoder_pkg_alu_b_mux_t
	input wire [31:0] sel;
	// Trace: ../../../hdl/src/core/alu_b_mux.sv:7:5
	// removed localparam type decoder_pkg_word
	input wire [31:0] rs2;
	// Trace: ../../../hdl/src/core/alu_b_mux.sv:8:5
	input wire [31:0] imm;
	// Trace: ../../../hdl/src/core/alu_b_mux.sv:9:5
	input wire [31:0] pc_plus_4;
	// Trace: ../../../hdl/src/core/alu_b_mux.sv:10:5
	input wire [31:0] pc;
	// Trace: ../../../hdl/src/core/alu_b_mux.sv:12:5
	output reg [31:0] out;
	// Trace: ../../../hdl/src/core/alu_b_mux.sv:15:3
	always @(*)
		// Trace: ../../../hdl/src/core/alu_b_mux.sv:16:5
		case (sel)
			32'd0:
				// Trace: ../../../hdl/src/core/alu_b_mux.sv:17:14
				out = rs2;
			32'd1:
				// Trace: ../../../hdl/src/core/alu_b_mux.sv:18:18
				out = imm;
			32'd2:
				// Trace: ../../../hdl/src/core/alu_b_mux.sv:19:20
				out = pc_plus_4;
			32'd3:
				// Trace: ../../../hdl/src/core/alu_b_mux.sv:20:13
				out = pc;
			default:
				// Trace: ../../../hdl/src/core/alu_b_mux.sv:21:16
				out = rs2;
		endcase
endmodule
// Trace: ../../../hdl/src/core/branch_logic.sv:4:1
// removed ["import decoder_pkg::*;"]
module branch_logic (
	a,
	b,
	branch_always,
	branch_instr,
	op,
	out
);
	// Trace: ../../../hdl/src/core/branch_logic.sv:6:5
	// removed localparam type decoder_pkg_word
	input wire [31:0] a;
	// Trace: ../../../hdl/src/core/branch_logic.sv:7:5
	input wire [31:0] b;
	// Trace: ../../../hdl/src/core/branch_logic.sv:8:5
	input wire branch_always;
	// Trace: ../../../hdl/src/core/branch_logic.sv:9:5
	input wire branch_instr;
	// Trace: ../../../hdl/src/core/branch_logic.sv:10:5
	// removed localparam type decoder_pkg_branch_op_t
	input wire [2:0] op;
	// Trace: ../../../hdl/src/core/branch_logic.sv:12:5
	// removed localparam type decoder_pkg_pc_branch_mux_t
	output reg out;
	// Trace: ../../../hdl/src/core/branch_logic.sv:14:3
	reg take;
	// Trace: ../../../hdl/src/core/branch_logic.sv:16:3
	always @(*) begin
		// Trace: ../../../hdl/src/core/branch_logic.sv:17:5
		case (op)
			3'b000:
				// Trace: ../../../hdl/src/core/branch_logic.sv:18:16
				take = a == b;
			3'b001:
				// Trace: ../../../hdl/src/core/branch_logic.sv:19:16
				take = a != b;
			3'b100:
				// Trace: ../../../hdl/src/core/branch_logic.sv:20:16
				take = $signed(a) < $signed(b);
			3'b101:
				// Trace: ../../../hdl/src/core/branch_logic.sv:21:16
				take = !($signed(a) < $signed(b));
			3'b110:
				// Trace: ../../../hdl/src/core/branch_logic.sv:22:16
				take = $unsigned(a) < $unsigned(b);
			3'b111:
				// Trace: ../../../hdl/src/core/branch_logic.sv:23:16
				take = !($unsigned(a) < $unsigned(b));
			default:
				// Trace: ../../../hdl/src/core/branch_logic.sv:24:16
				take = 0;
		endcase
		// Trace: ../../../hdl/src/core/branch_logic.sv:27:5
		out = branch_always || (branch_instr && take);
	end
endmodule
// Trace: ../../../hdl/src/core/csr.sv:5:1
// removed ["import config_pkg::*;"]
// Trace: ../../../hdl/src/core/csr.sv:6:1
// removed ["import decoder_pkg::*;"]
module csr (
	clk,
	reset,
	csr_enable,
	csr_addr,
	csr_op,
	rs1_zimm,
	rs1_data,
	ext_data,
	ext_write_enable,
	direct_out,
	out
);
	// Trace: ../../../hdl/src/core/csr.sv:9:15
	parameter [31:0] CsrWidth = 32;
	// Trace: ../../../hdl/src/core/csr.sv:10:21
	// removed localparam type CsrDataT
	// Trace: ../../../hdl/src/core/csr.sv:11:15
	function automatic [CsrWidth - 1:0] sv2v_cast_6F739;
		input reg [CsrWidth - 1:0] inp;
		sv2v_cast_6F739 = inp;
	endfunction
	parameter [CsrWidth - 1:0] ResetValue = sv2v_cast_6F739(0);
	// Trace: ../../../hdl/src/core/csr.sv:12:15
	// removed localparam type config_pkg_CsrAddrT
	parameter [11:0] Addr = 12'd0;
	// Trace: ../../../hdl/src/core/csr.sv:13:15
	parameter [0:0] Read = 1;
	// Trace: ../../../hdl/src/core/csr.sv:14:15
	parameter [0:0] Write = 1;
	// Trace: ../../../hdl/src/core/csr.sv:16:5
	input wire clk;
	// Trace: ../../../hdl/src/core/csr.sv:17:5
	input wire reset;
	// Trace: ../../../hdl/src/core/csr.sv:18:5
	input wire csr_enable;
	// Trace: ../../../hdl/src/core/csr.sv:19:5
	input wire [11:0] csr_addr;
	// Trace: ../../../hdl/src/core/csr.sv:20:5
	// removed localparam type decoder_pkg_csr_op_t
	input wire [2:0] csr_op;
	// Trace: ../../../hdl/src/core/csr.sv:21:5
	// removed localparam type decoder_pkg_r
	input wire [4:0] rs1_zimm;
	// Trace: ../../../hdl/src/core/csr.sv:22:5
	// removed localparam type decoder_pkg_word
	input wire [31:0] rs1_data;
	// Trace: ../../../hdl/src/core/csr.sv:25:5
	input wire [CsrWidth - 1:0] ext_data;
	// Trace: ../../../hdl/src/core/csr.sv:26:5
	input wire ext_write_enable;
	// Trace: ../../../hdl/src/core/csr.sv:27:5
	output wire [31:0] direct_out;
	// Trace: ../../../hdl/src/core/csr.sv:28:5
	output wire [31:0] out;
	// Trace: ../../../hdl/src/core/csr.sv:30:3
	reg [CsrWidth - 1:0] data;
	// Trace: ../../../hdl/src/core/csr.sv:31:3
	reg [CsrWidth - 1:0] tmp;
	// Trace: ../../../hdl/src/core/csr.sv:33:3
	always @(*) begin
		// Trace: ../../../hdl/src/core/csr.sv:34:5
		tmp = data;
		// Trace: ../../../hdl/src/core/csr.sv:35:5
		if ((csr_enable && (csr_addr == Addr)) && Write) begin
			// Trace: ../../../hdl/src/core/csr.sv:36:7
			$display("@ %h", csr_addr);
			// Trace: ../../../hdl/src/core/csr.sv:37:7
			case (csr_op)
				3'b001: begin
					// Trace: ../../../hdl/src/core/csr.sv:40:11
					$display("CSR CSRRW %h", rs1_data);
					// Trace: ../../../hdl/src/core/csr.sv:41:11
					tmp = sv2v_cast_6F739(rs1_data);
				end
				3'b010:
					// Trace: ../../../hdl/src/core/csr.sv:44:11
					if (rs1_zimm != 0) begin
						// Trace: ../../../hdl/src/core/csr.sv:46:13
						$display("CSR CSRRS %h", rs1_data);
						// Trace: ../../../hdl/src/core/csr.sv:47:13
						tmp = data | sv2v_cast_6F739(rs1_data);
					end
				3'b011:
					// Trace: ../../../hdl/src/core/csr.sv:51:11
					if (rs1_zimm != 0) begin
						// Trace: ../../../hdl/src/core/csr.sv:53:13
						$display("CSR CSRRC %h", rs1_data);
						// Trace: ../../../hdl/src/core/csr.sv:54:13
						tmp = data & ~sv2v_cast_6F739(rs1_data);
					end
				3'b101: begin
					// Trace: ../../../hdl/src/core/csr.sv:60:11
					$display("CSR CSRRWI %h", rs1_zimm);
					// Trace: ../../../hdl/src/core/csr.sv:61:11
					tmp = sv2v_cast_6F739($unsigned(rs1_zimm));
				end
				3'b110:
					// Trace: ../../../hdl/src/core/csr.sv:65:11
					if (rs1_zimm != 0) begin
						// Trace: ../../../hdl/src/core/csr.sv:67:13
						$display("CSR CSRRSI %h", rs1_zimm);
						// Trace: ../../../hdl/src/core/csr.sv:68:13
						tmp = data | sv2v_cast_6F739($unsigned(rs1_zimm));
					end
				3'b111:
					// Trace: ../../../hdl/src/core/csr.sv:73:11
					if (rs1_zimm != 0) begin
						// Trace: ../../../hdl/src/core/csr.sv:75:13
						$display("CSR CSRRCI %h", rs1_zimm);
						// Trace: ../../../hdl/src/core/csr.sv:76:13
						tmp = data & ~sv2v_cast_6F739($unsigned(rs1_zimm));
					end
				default:
					;
			endcase
		end
	end
	// Trace: ../../../hdl/src/core/csr.sv:84:3
	function automatic [31:0] sv2v_cast_32;
		input reg [31:0] inp;
		sv2v_cast_32 = inp;
	endfunction
	assign direct_out = sv2v_cast_32($unsigned(tmp));
	// Trace: ../../../hdl/src/core/csr.sv:85:3
	assign out = sv2v_cast_32($unsigned(data));
	// Trace: ../../../hdl/src/core/csr.sv:87:3
	always @(posedge clk)
		// Trace: ../../../hdl/src/core/csr.sv:89:5
		if (reset)
			// Trace: ../../../hdl/src/core/csr.sv:90:7
			data <= ResetValue;
		else if (ext_write_enable) begin
			// Trace: ../../../hdl/src/core/csr.sv:93:7
			$display("--- ext data ---");
			// Trace: ../../../hdl/src/core/csr.sv:94:7
			data <= ext_data;
		end
		else
			// Trace: ../../../hdl/src/core/csr.sv:95:14
			data <= tmp;
endmodule
// Trace: ../../../hdl/src/core/decoder.sv:4:1
// removed ["import decoder_pkg::*;"]
// Trace: ../../../hdl/src/core/decoder.sv:5:1
// removed ["import mem_pkg::*;"]
module decoder (
	instr,
	imm,
	csr_addr,
	rs1,
	rs2,
	branch_always,
	branch_instr,
	branch_op,
	alu_a_mux_sel,
	alu_b_mux_sel,
	alu_op,
	sub_arith,
	dmem_write_enable,
	dmem_sign_extend,
	dmem_width,
	csr_enable,
	csr_op,
	wb_mux_sel,
	rd,
	wb_write_enable
);
	// Trace: ../../../hdl/src/core/decoder.sv:8:5
	// removed localparam type decoder_pkg_word
	input wire [31:0] instr;
	// Trace: ../../../hdl/src/core/decoder.sv:10:5
	output reg [31:0] imm;
	// Trace: ../../../hdl/src/core/decoder.sv:11:5
	// removed localparam type config_pkg_CsrAddrT
	output reg [11:0] csr_addr;
	// Trace: ../../../hdl/src/core/decoder.sv:13:5
	// removed localparam type decoder_pkg_r
	output reg [4:0] rs1;
	// Trace: ../../../hdl/src/core/decoder.sv:14:5
	output reg [4:0] rs2;
	// Trace: ../../../hdl/src/core/decoder.sv:16:5
	output reg branch_always;
	// Trace: ../../../hdl/src/core/decoder.sv:17:5
	output reg branch_instr;
	// Trace: ../../../hdl/src/core/decoder.sv:18:5
	// removed localparam type decoder_pkg_branch_op_t
	output reg [2:0] branch_op;
	// Trace: ../../../hdl/src/core/decoder.sv:20:5
	// removed localparam type decoder_pkg_alu_a_mux_t
	output reg [1:0] alu_a_mux_sel;
	// Trace: ../../../hdl/src/core/decoder.sv:21:5
	// removed localparam type decoder_pkg_alu_b_mux_t
	output reg [31:0] alu_b_mux_sel;
	// Trace: ../../../hdl/src/core/decoder.sv:22:5
	// removed localparam type decoder_pkg_alu_op_t
	output reg [2:0] alu_op;
	// Trace: ../../../hdl/src/core/decoder.sv:23:5
	output reg sub_arith;
	// Trace: ../../../hdl/src/core/decoder.sv:25:5
	output reg dmem_write_enable;
	// Trace: ../../../hdl/src/core/decoder.sv:26:5
	output reg dmem_sign_extend;
	// Trace: ../../../hdl/src/core/decoder.sv:27:5
	// removed localparam type mem_pkg_mem_width_t
	output reg [1:0] dmem_width;
	// Trace: ../../../hdl/src/core/decoder.sv:29:5
	output reg csr_enable;
	// Trace: ../../../hdl/src/core/decoder.sv:30:5
	// removed localparam type decoder_pkg_csr_op_t
	output reg [2:0] csr_op;
	// Trace: ../../../hdl/src/core/decoder.sv:32:5
	// removed localparam type decoder_pkg_wb_mux_t
	output reg [31:0] wb_mux_sel;
	// Trace: ../../../hdl/src/core/decoder.sv:33:5
	output reg [4:0] rd;
	// Trace: ../../../hdl/src/core/decoder.sv:34:5
	output reg wb_write_enable;
	// Trace: ../../../hdl/src/core/decoder.sv:38:3
	// removed localparam type op_t
	// Trace: ../../../hdl/src/core/decoder.sv:53:3
	reg [6:0] funct7;
	// Trace: ../../../hdl/src/core/decoder.sv:54:3
	reg [2:0] funct3;
	// Trace: ../../../hdl/src/core/decoder.sv:55:3
	reg [6:0] op;
	// Trace: ../../../hdl/src/core/decoder.sv:57:3
	function automatic signed [11:0] sv2v_cast_12_signed;
		input reg signed [11:0] inp;
		sv2v_cast_12_signed = inp;
	endfunction
	function automatic signed [31:0] sv2v_cast_32_signed;
		input reg signed [31:0] inp;
		sv2v_cast_32_signed = inp;
	endfunction
	function automatic signed [19:0] sv2v_cast_20_signed;
		input reg signed [19:0] inp;
		sv2v_cast_20_signed = inp;
	endfunction
	always @(instr) begin
		// Trace: ../../../hdl/src/core/decoder.sv:59:5
		csr_addr = instr[31:20];
		// Trace: ../../../hdl/src/core/decoder.sv:63:5
		{funct7, rs2, rs1, funct3, rd, op} = instr;
		// Trace: ../../../hdl/src/core/decoder.sv:65:5
		$display;
		// Trace: ../../../hdl/src/core/decoder.sv:66:5
		$display("inst %h, rs2 %b, rs1 %b, rd %b, opcode %b", instr, rs2, rs1, rd, op);
		// Trace: ../../../hdl/src/core/decoder.sv:70:5
		imm = 0;
		// Trace: ../../../hdl/src/core/decoder.sv:72:5
		branch_op = 3'b000;
		// Trace: ../../../hdl/src/core/decoder.sv:73:5
		branch_instr = 0;
		// Trace: ../../../hdl/src/core/decoder.sv:74:5
		branch_always = 0;
		// Trace: ../../../hdl/src/core/decoder.sv:76:5
		alu_a_mux_sel = 2'b10;
		// Trace: ../../../hdl/src/core/decoder.sv:77:5
		alu_b_mux_sel = 32'd1;
		// Trace: ../../../hdl/src/core/decoder.sv:78:5
		alu_op = 3'b000;
		// Trace: ../../../hdl/src/core/decoder.sv:79:5
		sub_arith = 0;
		// Trace: ../../../hdl/src/core/decoder.sv:81:5
		dmem_write_enable = 0;
		// Trace: ../../../hdl/src/core/decoder.sv:82:5
		dmem_sign_extend = 0;
		// Trace: ../../../hdl/src/core/decoder.sv:83:5
		dmem_width = 2'b10;
		// Trace: ../../../hdl/src/core/decoder.sv:85:5
		csr_enable = 0;
		// Trace: ../../../hdl/src/core/decoder.sv:86:5
		csr_op = 3'b001;
		// Trace: ../../../hdl/src/core/decoder.sv:88:5
		wb_mux_sel = 32'd0;
		// Trace: ../../../hdl/src/core/decoder.sv:89:5
		wb_write_enable = 0;
		// Trace: ../../../hdl/src/core/decoder.sv:92:5
		case (sv2v_cast_32_signed(op))
			32'sb00000000000000000000000000110111: begin
				// Trace: ../../../hdl/src/core/decoder.sv:94:9
				$display("lui");
				// Trace: ../../../hdl/src/core/decoder.sv:95:9
				imm = {instr[31:12], {12 {1'b0}}};
				// Trace: ../../../hdl/src/core/decoder.sv:96:9
				alu_a_mux_sel = 2'b10;
				// Trace: ../../../hdl/src/core/decoder.sv:97:9
				alu_b_mux_sel = 32'd1;
				// Trace: ../../../hdl/src/core/decoder.sv:98:9
				alu_op = 3'b110;
				// Trace: ../../../hdl/src/core/decoder.sv:99:9
				wb_mux_sel = 32'd0;
				// Trace: ../../../hdl/src/core/decoder.sv:100:9
				wb_write_enable = 1;
			end
			32'sb00000000000000000000000000010111: begin
				// Trace: ../../../hdl/src/core/decoder.sv:104:9
				$display("auipc");
				// Trace: ../../../hdl/src/core/decoder.sv:105:9
				imm = {instr[31:12], {12 {1'b0}}};
				// Trace: ../../../hdl/src/core/decoder.sv:106:9
				alu_a_mux_sel = 2'b00;
				// Trace: ../../../hdl/src/core/decoder.sv:107:9
				alu_b_mux_sel = 32'd3;
				// Trace: ../../../hdl/src/core/decoder.sv:108:9
				alu_op = 3'b000;
				// Trace: ../../../hdl/src/core/decoder.sv:109:9
				wb_mux_sel = 32'd0;
				// Trace: ../../../hdl/src/core/decoder.sv:110:9
				wb_write_enable = 1;
			end
			32'sb00000000000000000000000001101111: begin
				// Trace: ../../../hdl/src/core/decoder.sv:115:9
				$display("jal");
				// Trace: ../../../hdl/src/core/decoder.sv:116:9
				wb_write_enable = 1;
				// Trace: ../../../hdl/src/core/decoder.sv:117:9
				imm = {sv2v_cast_12_signed($signed(instr[31])), instr[19:12], instr[20], instr[30:21], 1'b0};
				// Trace: ../../../hdl/src/core/decoder.sv:118:9
				$display("--------  bl imm %h", imm);
				// Trace: ../../../hdl/src/core/decoder.sv:119:9
				alu_a_mux_sel = 2'b00;
				// Trace: ../../../hdl/src/core/decoder.sv:120:9
				alu_b_mux_sel = 32'd3;
				// Trace: ../../../hdl/src/core/decoder.sv:121:9
				wb_mux_sel = 32'd3;
				// Trace: ../../../hdl/src/core/decoder.sv:122:9
				branch_always = 1;
			end
			32'sb00000000000000000000000001100111: begin
				// Trace: ../../../hdl/src/core/decoder.sv:126:9
				$display("jalr");
				// Trace: ../../../hdl/src/core/decoder.sv:127:9
				wb_write_enable = 1;
				// Trace: ../../../hdl/src/core/decoder.sv:128:9
				imm = sv2v_cast_32_signed($signed(instr[31:20]));
				// Trace: ../../../hdl/src/core/decoder.sv:129:9
				alu_a_mux_sel = 2'b01;
				// Trace: ../../../hdl/src/core/decoder.sv:130:9
				alu_b_mux_sel = 32'd1;
				// Trace: ../../../hdl/src/core/decoder.sv:131:9
				wb_mux_sel = 32'd3;
				// Trace: ../../../hdl/src/core/decoder.sv:132:9
				branch_always = 1;
			end
			32'sb00000000000000000000000001100011: begin
				// Trace: ../../../hdl/src/core/decoder.sv:136:9
				$display("branch");
				// Trace: ../../../hdl/src/core/decoder.sv:137:9
				branch_instr = 1;
				// Trace: ../../../hdl/src/core/decoder.sv:138:9
				wb_write_enable = 0;
				// Trace: ../../../hdl/src/core/decoder.sv:139:9
				imm = {sv2v_cast_20_signed($signed(instr[31])), instr[7], instr[30:25], instr[11:8], 1'b0};
				// Trace: ../../../hdl/src/core/decoder.sv:140:9
				$display("--------  bl imm %h", imm);
				// Trace: ../../../hdl/src/core/decoder.sv:141:9
				branch_op = funct3;
				// Trace: ../../../hdl/src/core/decoder.sv:142:9
				alu_a_mux_sel = 2'b00;
				// Trace: ../../../hdl/src/core/decoder.sv:143:9
				alu_b_mux_sel = 32'd3;
				// Trace: ../../../hdl/src/core/decoder.sv:144:9
				alu_op = 3'b000;
			end
			32'sb00000000000000000000000000000011: begin
				// Trace: ../../../hdl/src/core/decoder.sv:148:9
				$display("load");
				// Trace: ../../../hdl/src/core/decoder.sv:150:9
				imm = {sv2v_cast_20_signed($signed(instr[31])), instr[31:20]};
				// Trace: ../../../hdl/src/core/decoder.sv:151:9
				$display("--------  load imm %h", imm);
				// Trace: ../../../hdl/src/core/decoder.sv:152:9
				branch_op = funct3;
				// Trace: ../../../hdl/src/core/decoder.sv:153:9
				alu_a_mux_sel = 2'b01;
				// Trace: ../../../hdl/src/core/decoder.sv:154:9
				alu_b_mux_sel = 32'd1;
				// Trace: ../../../hdl/src/core/decoder.sv:155:9
				alu_op = 3'b000;
				// Trace: ../../../hdl/src/core/decoder.sv:157:9
				dmem_width = funct3[1:0];
				// Trace: ../../../hdl/src/core/decoder.sv:158:9
				dmem_sign_extend = !funct3[2];
				// Trace: ../../../hdl/src/core/decoder.sv:160:9
				wb_mux_sel = 32'd1;
				// Trace: ../../../hdl/src/core/decoder.sv:161:9
				wb_write_enable = 1;
			end
			32'sb00000000000000000000000000100011: begin
				// Trace: ../../../hdl/src/core/decoder.sv:165:9
				$display("store");
				// Trace: ../../../hdl/src/core/decoder.sv:167:9
				imm = {sv2v_cast_20_signed($signed(instr[31])), instr[31:25], instr[11:7]};
				// Trace: ../../../hdl/src/core/decoder.sv:168:9
				$display("--------  store imm %h", imm);
				// Trace: ../../../hdl/src/core/decoder.sv:169:9
				branch_op = funct3;
				// Trace: ../../../hdl/src/core/decoder.sv:170:9
				alu_a_mux_sel = 2'b01;
				// Trace: ../../../hdl/src/core/decoder.sv:171:9
				alu_b_mux_sel = 32'd1;
				// Trace: ../../../hdl/src/core/decoder.sv:172:9
				alu_op = 3'b000;
				// Trace: ../../../hdl/src/core/decoder.sv:174:9
				dmem_width = funct3[1:0];
				// Trace: ../../../hdl/src/core/decoder.sv:175:9
				dmem_sign_extend = !funct3[2];
				// Trace: ../../../hdl/src/core/decoder.sv:176:9
				dmem_write_enable = 1;
				// Trace: ../../../hdl/src/core/decoder.sv:178:9
				wb_mux_sel = 32'd1;
				// Trace: ../../../hdl/src/core/decoder.sv:179:9
				wb_write_enable = 0;
			end
			32'sb00000000000000000000000000010011: begin
				// Trace: ../../../hdl/src/core/decoder.sv:183:9
				$display("alui");
				// Trace: ../../../hdl/src/core/decoder.sv:184:9
				imm = sv2v_cast_32_signed($signed(instr[31:20]));
				// Trace: ../../../hdl/src/core/decoder.sv:185:9
				sub_arith = instr[30];
				// Trace: ../../../hdl/src/core/decoder.sv:186:9
				alu_a_mux_sel = 2'b01;
				// Trace: ../../../hdl/src/core/decoder.sv:187:9
				alu_b_mux_sel = 32'd1;
				// Trace: ../../../hdl/src/core/decoder.sv:188:9
				alu_op = funct3;
				// Trace: ../../../hdl/src/core/decoder.sv:189:9
				wb_mux_sel = 32'd0;
				// Trace: ../../../hdl/src/core/decoder.sv:190:9
				wb_write_enable = 1;
			end
			32'sb00000000000000000000000000110011: begin
				// Trace: ../../../hdl/src/core/decoder.sv:194:9
				$display("alu");
				// Trace: ../../../hdl/src/core/decoder.sv:196:9
				sub_arith = instr[30];
				// Trace: ../../../hdl/src/core/decoder.sv:197:9
				alu_a_mux_sel = 2'b01;
				// Trace: ../../../hdl/src/core/decoder.sv:198:9
				alu_b_mux_sel = 32'd0;
				// Trace: ../../../hdl/src/core/decoder.sv:199:9
				alu_op = funct3;
				// Trace: ../../../hdl/src/core/decoder.sv:200:9
				wb_mux_sel = 32'd0;
				// Trace: ../../../hdl/src/core/decoder.sv:201:9
				wb_write_enable = 1;
			end
			32'sb00000000000000000000000000001111:
				// Trace: ../../../hdl/src/core/decoder.sv:205:9
				$display("fence");
			32'sb00000000000000000000000001110011: begin
				// Trace: ../../../hdl/src/core/decoder.sv:209:9
				$display("system");
				// Trace: ../../../hdl/src/core/decoder.sv:211:9
				wb_write_enable = 1;
				// Trace: ../../../hdl/src/core/decoder.sv:212:9
				wb_mux_sel = 32'd2;
				// Trace: ../../../hdl/src/core/decoder.sv:213:9
				csr_enable = 1;
				// Trace: ../../../hdl/src/core/decoder.sv:214:9
				csr_op = funct3;
			end
			default:
				// Trace: ../../../hdl/src/core/decoder.sv:219:9
				$display("-- non matched op --");
		endcase
	end
endmodule
module mono_timer (
	clk,
	reset,
	mono_timer
);
	// removed import config_pkg::*;
	// Trace: ../../../hdl/src/core/mono_timer.sv:8:5
	input wire clk;
	// Trace: ../../../hdl/src/core/mono_timer.sv:9:5
	input wire reset;
	// Trace: ../../../hdl/src/core/mono_timer.sv:11:5
	localparam [31:0] config_pkg_MonoTimerWidth = 32;
	// removed localparam type config_pkg_MonoTimerT
	output reg [31:0] mono_timer;
	// Trace: ../../../hdl/src/core/mono_timer.sv:13:3
	always @(posedge clk)
		// Trace: ../../../hdl/src/core/mono_timer.sv:14:5
		if (reset)
			// Trace: ../../../hdl/src/core/mono_timer.sv:14:16
			mono_timer <= 0;
		else
			// Trace: ../../../hdl/src/core/mono_timer.sv:15:10
			mono_timer <= mono_timer + 1;
endmodule
module n_clic (
	clk,
	reset,
	csr_enable,
	csr_addr,
	rs1_zimm,
	rs1_data,
	csr_op,
	pc_in,
	csr_out,
	int_addr,
	pc_interrupt_sel,
	level_out,
	interrupt_out
);
	// removed import decoder_pkg::*;
	// removed import config_pkg::*;
	// Trace: ../../../hdl/src/core/n_clic.sv:8:5
	input wire clk;
	// Trace: ../../../hdl/src/core/n_clic.sv:9:5
	input wire reset;
	// Trace: ../../../hdl/src/core/n_clic.sv:12:5
	input wire csr_enable;
	// Trace: ../../../hdl/src/core/n_clic.sv:13:5
	// removed localparam type config_pkg_CsrAddrT
	input wire [11:0] csr_addr;
	// Trace: ../../../hdl/src/core/n_clic.sv:14:5
	// removed localparam type decoder_pkg_r
	input wire [4:0] rs1_zimm;
	// Trace: ../../../hdl/src/core/n_clic.sv:15:5
	// removed localparam type decoder_pkg_word
	input wire [31:0] rs1_data;
	// Trace: ../../../hdl/src/core/n_clic.sv:16:5
	// removed localparam type decoder_pkg_csr_op_t
	input wire [2:0] csr_op;
	// Trace: ../../../hdl/src/core/n_clic.sv:18:5
	localparam [31:0] config_pkg_IMemSize = 'h1000;
	localparam [31:0] config_pkg_IMemAddrWidth = $clog2(32'h00001000);
	// removed localparam type config_pkg_IMemAddrT
	input wire [config_pkg_IMemAddrWidth - 1:0] pc_in;
	// Trace: ../../../hdl/src/core/n_clic.sv:20:5
	output reg [31:0] csr_out;
	// Trace: ../../../hdl/src/core/n_clic.sv:21:5
	output reg [config_pkg_IMemAddrWidth - 1:0] int_addr;
	// Trace: ../../../hdl/src/core/n_clic.sv:22:5
	// removed localparam type decoder_pkg_pc_interrupt_mux_t
	output reg pc_interrupt_sel;
	// Trace: ../../../hdl/src/core/n_clic.sv:23:5
	localparam [31:0] config_pkg_PrioNum = 4;
	localparam [31:0] config_pkg_PrioWidth = 2;
	// removed localparam type config_pkg_PrioT
	output wire [1:0] level_out;
	// Trace: ../../../hdl/src/core/n_clic.sv:24:5
	output reg interrupt_out;
	// Trace: ../../../hdl/src/core/n_clic.sv:28:3
	wire [31:0] timer_direct_out;
	// Trace: ../../../hdl/src/core/n_clic.sv:29:3
	wire [31:0] timer_out;
	// Trace: ../../../hdl/src/core/n_clic.sv:30:3
	wire timer_interrupt_set;
	// Trace: ../../../hdl/src/core/n_clic.sv:31:3
	reg timer_interrupt_clear;
	// Trace: ../../../hdl/src/core/n_clic.sv:33:3
	timer timer(
		.clk(clk),
		.reset(reset),
		.csr_enable(csr_enable),
		.csr_addr(csr_addr),
		.csr_op(csr_op),
		.rs1_zimm(rs1_zimm),
		.rs1_data(rs1_data),
		.ext_data(0),
		.ext_write_enable(1'b0),
		.interrupt_clear(timer_interrupt_clear),
		.interrupt_set(timer_interrupt_set),
		.csr_direct_out(timer_direct_out),
		.csr_out(timer_out)
	);
	// Trace: ../../../hdl/src/core/n_clic.sv:53:3
	reg m_int_thresh_write_enable;
	// Trace: ../../../hdl/src/core/n_clic.sv:54:3
	wire [31:0] m_int_thresh_direct_out;
	// Trace: ../../../hdl/src/core/n_clic.sv:55:3
	wire [31:0] m_int_thresh_out;
	// Trace: ../../../hdl/src/core/n_clic.sv:56:3
	reg [1:0] m_int_thresh_data;
	// Trace: ../../../hdl/src/core/n_clic.sv:58:3
	localparam [11:0] config_pkg_MIntThreshAddr = 'h347;
	csr #(
		.CsrWidth(config_pkg_PrioWidth),
		.Addr(config_pkg_MIntThreshAddr)
	) m_int_thresh(
		.clk(clk),
		.reset(reset),
		.csr_enable(csr_enable),
		.csr_addr(csr_addr),
		.rs1_zimm(rs1_zimm),
		.rs1_data(rs1_data),
		.csr_op(csr_op),
		.ext_data(m_int_thresh_data),
		.ext_write_enable(m_int_thresh_write_enable),
		.direct_out(m_int_thresh_direct_out),
		.out(m_int_thresh_out)
	);
	// Trace: ../../../hdl/src/core/n_clic.sv:78:3
	wire [31:0] mstatus_direct_out;
	// Trace: ../../../hdl/src/core/n_clic.sv:79:3
	wire [31:0] mstatus_out;
	// Trace: ../../../hdl/src/core/n_clic.sv:80:3
	localparam [11:0] config_pkg_MStatusAddr = 'h300;
	localparam [31:0] config_pkg_MStatusWidth = 4;
	// removed localparam type config_pkg_MStatusT
	function automatic [3:0] sv2v_cast_5FE2B;
		input reg [3:0] inp;
		sv2v_cast_5FE2B = inp;
	endfunction
	csr #(
		.CsrWidth(config_pkg_MStatusWidth),
		.Addr(config_pkg_MStatusAddr)
	) mstatus(
		.clk(clk),
		.reset(reset),
		.csr_enable(csr_enable),
		.csr_addr(csr_addr),
		.rs1_zimm(rs1_zimm),
		.rs1_data(rs1_data),
		.csr_op(csr_op),
		.ext_data(sv2v_cast_5FE2B(0)),
		.ext_write_enable(1'sd0),
		.direct_out(mstatus_direct_out),
		.out(mstatus_out)
	);
	// Trace: ../../../hdl/src/core/n_clic.sv:98:3
	// removed localparam type entry_t
	// Trace: ../../../hdl/src/core/n_clic.sv:105:3
	reg push;
	// Trace: ../../../hdl/src/core/n_clic.sv:106:3
	reg pop;
	// Trace: ../../../hdl/src/core/n_clic.sv:107:3
	// removed localparam type stack_t
	// Trace: ../../../hdl/src/core/n_clic.sv:112:3
	wire [(config_pkg_IMemAddrWidth + config_pkg_PrioWidth) - 1:0] stack_out;
	// Trace: ../../../hdl/src/core/n_clic.sv:114:3
	stack #(
		.StackDepth(config_pkg_PrioNum),
		.DataWidth(config_pkg_IMemAddrWidth + config_pkg_PrioWidth)
	) epc_stack(
		.clk(clk),
		.reset(reset),
		.push(push),
		.pop(pop),
		.data_in({pc_in, m_int_thresh.data}),
		.data_out(stack_out),
		.index_out(level_out)
	);
	// Trace: ../../../hdl/src/core/n_clic.sv:130:3
	// removed localparam type IMemAddrStore
	// Trace: ../../../hdl/src/core/n_clic.sv:132:3
	localparam [31:0] config_pkg_VecSize = 8;
	wire [3:0] entry [0:7];
	// Trace: ../../../hdl/src/core/n_clic.sv:133:3
	wire [1:0] prio [0:7];
	// Trace: ../../../hdl/src/core/n_clic.sv:134:3
	wire [config_pkg_IMemAddrWidth - 3:0] csr_vec_data [0:7];
	// Trace: ../../../hdl/src/core/n_clic.sv:135:3
	reg [0:7] ext_write_enable;
	// Trace: ../../../hdl/src/core/n_clic.sv:136:3
	reg [31:0] ext_entry_data;
	// Trace: ../../../hdl/src/core/n_clic.sv:137:3
	// Trace: ../../../hdl/src/core/n_clic.sv:138:5
	wire [31:0] temp_vec [0:7];
	// Trace: ../../../hdl/src/core/n_clic.sv:139:5
	wire [31:0] temp_entry [0:7];
	// Trace: ../../../hdl/src/core/n_clic.sv:140:5
	wire [31:0] vec_out [0:7];
	// Trace: ../../../hdl/src/core/n_clic.sv:141:5
	wire [31:0] entry_out [0:7];
	genvar k;
	localparam [11:0] config_pkg_EntryCsrBase = 'hb20;
	localparam [11:0] config_pkg_VecCsrBase = 'hb00;
	function automatic [11:0] sv2v_cast_12;
		input reg [11:0] inp;
		sv2v_cast_12 = inp;
	endfunction
	function automatic [3:0] sv2v_cast_2E83E;
		input reg [3:0] inp;
		sv2v_cast_2E83E = inp;
	endfunction
	function automatic [config_pkg_IMemAddrWidth - 3:0] sv2v_cast_EDBD9;
		input reg [config_pkg_IMemAddrWidth - 3:0] inp;
		sv2v_cast_EDBD9 = inp;
	endfunction
	generate
		for (k = 0; k < config_pkg_VecSize; k = k + 1) begin : gen_vec
			// Trace: ../../../hdl/src/core/n_clic.sv:144:7
			csr #(
				.Addr(config_pkg_VecCsrBase + sv2v_cast_12(k)),
				.CsrWidth(config_pkg_IMemAddrWidth - 2)
			) csr_vec(
				.clk(clk),
				.reset(reset),
				.csr_enable(csr_enable),
				.csr_addr(csr_addr),
				.csr_op(csr_op),
				.rs1_zimm(rs1_zimm),
				.rs1_data(rs1_data),
				.ext_write_enable(0),
				.ext_data(0),
				.direct_out(temp_vec[k]),
				.out(vec_out[k])
			);
			// Trace: ../../../hdl/src/core/n_clic.sv:163:7
			csr #(
				.Addr(config_pkg_EntryCsrBase + sv2v_cast_12(k)),
				.CsrWidth(4)
			) csr_entry(
				.clk(clk),
				.reset(reset),
				.csr_enable(csr_enable),
				.csr_addr(csr_addr),
				.csr_op(csr_op),
				.rs1_zimm(rs1_zimm),
				.rs1_data(rs1_data),
				.ext_write_enable(ext_write_enable[k]),
				.ext_data(ext_entry_data[(7 - k) * 4+:4]),
				.direct_out(temp_entry[k]),
				.out(entry_out[k])
			);
			// Trace: ../../../hdl/src/core/n_clic.sv:182:7
			assign entry[k] = sv2v_cast_2E83E(temp_entry[k]);
			// Trace: ../../../hdl/src/core/n_clic.sv:183:7
			assign prio[k] = entry[k][3-:2];
			// Trace: ../../../hdl/src/core/n_clic.sv:184:7
			assign csr_vec_data[k] = sv2v_cast_EDBD9(temp_vec[k]);
		end
	endgenerate
	// Trace: ../../../hdl/src/core/n_clic.sv:189:3
	reg [1:0] max_prio [0:7];
	// Trace: ../../../hdl/src/core/n_clic.sv:190:3
	reg [config_pkg_IMemAddrWidth - 3:0] max_vec [0:7];
	// Trace: ../../../hdl/src/core/n_clic.sv:191:3
	localparam [31:0] config_pkg_VecWidth = 3;
	// removed localparam type config_pkg_VecT
	reg [2:0] max_index [0:7];
	// Trace: ../../../hdl/src/core/n_clic.sv:192:3
	function automatic [2:0] sv2v_cast_92A66;
		input reg [2:0] inp;
		sv2v_cast_92A66 = inp;
	endfunction
	always @(*) begin
		// Trace: ../../../hdl/src/core/n_clic.sv:194:5
		if ((entry[0][1] && entry[0][0]) && (prio[0] >= m_int_thresh.data)) begin
			// Trace: ../../../hdl/src/core/n_clic.sv:195:7
			max_prio[0] = prio[0];
			// Trace: ../../../hdl/src/core/n_clic.sv:196:7
			max_vec[0] = csr_vec_data[0];
			// Trace: ../../../hdl/src/core/n_clic.sv:197:7
			max_index[0] = 0;
		end
		else begin
			// Trace: ../../../hdl/src/core/n_clic.sv:199:7
			max_prio[0] = m_int_thresh.data;
			// Trace: ../../../hdl/src/core/n_clic.sv:200:7
			max_vec[0] = 0;
			// Trace: ../../../hdl/src/core/n_clic.sv:201:7
			max_index[0] = 0;
		end
		begin : sv2v_autoblock_1
			// Trace: ../../../hdl/src/core/n_clic.sv:204:10
			integer k;
			// Trace: ../../../hdl/src/core/n_clic.sv:204:10
			for (k = 1; k < config_pkg_VecSize; k = k + 1)
				begin
					// Trace: ../../../hdl/src/core/n_clic.sv:205:7
					if ((entry[k][1] && entry[k][0]) && (prio[k] >= max_prio[k - 1])) begin
						// Trace: ../../../hdl/src/core/n_clic.sv:206:9
						max_prio[k] = prio[k];
						// Trace: ../../../hdl/src/core/n_clic.sv:207:9
						max_vec[k] = csr_vec_data[k];
						// Trace: ../../../hdl/src/core/n_clic.sv:208:9
						max_index[k] = sv2v_cast_92A66(k);
					end
					else begin
						// Trace: ../../../hdl/src/core/n_clic.sv:210:9
						max_prio[k] = max_prio[k - 1];
						// Trace: ../../../hdl/src/core/n_clic.sv:211:9
						max_vec[k] = max_vec[k - 1];
						// Trace: ../../../hdl/src/core/n_clic.sv:212:9
						max_index[k] = max_index[k - 1];
					end
				end
		end
	end
	// Trace: ../../../hdl/src/core/n_clic.sv:218:3
	function automatic [3:0] sv2v_cast_35E60;
		input reg [3:0] inp;
		sv2v_cast_35E60 = inp;
	endfunction
	function automatic signed [config_pkg_IMemAddrWidth - 1:0] sv2v_cast_02BB2_signed;
		input reg signed [config_pkg_IMemAddrWidth - 1:0] inp;
		sv2v_cast_02BB2_signed = inp;
	endfunction
	always @(*) begin : sv2v_autoblock_2
		// Trace: ../../../hdl/src/core/n_clic.sv:220:5
		reg [2:0] max_i;
		max_i = max_index[7];
		// Trace: ../../../hdl/src/core/n_clic.sv:221:5
		ext_write_enable = {config_pkg_VecSize {1'b0}};
		// Trace: ../../../hdl/src/core/n_clic.sv:222:5
		ext_entry_data = {config_pkg_VecSize {sv2v_cast_35E60(1'sb0)}};
		// Trace: ../../../hdl/src/core/n_clic.sv:224:5
		if (timer_interrupt_set) begin
			// Trace: ../../../hdl/src/core/n_clic.sv:226:7
			ext_write_enable[0] = 1;
			// Trace: ../../../hdl/src/core/n_clic.sv:227:7
			ext_entry_data[28+:4] = entry[0] | 1;
		end
		if (mstatus_direct_out[3] == 0) begin
			// Trace: ../../../hdl/src/core/n_clic.sv:231:7
			push = 0;
			// Trace: ../../../hdl/src/core/n_clic.sv:232:7
			pop = 0;
			// Trace: ../../../hdl/src/core/n_clic.sv:233:7
			m_int_thresh_data = 0;
			// Trace: ../../../hdl/src/core/n_clic.sv:234:7
			m_int_thresh_write_enable = 0;
			// Trace: ../../../hdl/src/core/n_clic.sv:235:7
			int_addr = pc_in;
			// Trace: ../../../hdl/src/core/n_clic.sv:236:7
			interrupt_out = 0;
			// Trace: ../../../hdl/src/core/n_clic.sv:237:7
			pc_interrupt_sel = 1'b0;
			// Trace: ../../../hdl/src/core/n_clic.sv:238:7
			timer_interrupt_clear = 0;
		end
		else if (max_prio[7] > m_int_thresh.data) begin
			// Trace: ../../../hdl/src/core/n_clic.sv:241:7
			push = 1;
			// Trace: ../../../hdl/src/core/n_clic.sv:242:7
			pop = 0;
			// Trace: ../../../hdl/src/core/n_clic.sv:243:7
			int_addr = {max_vec[7], 2'b00};
			// Trace: ../../../hdl/src/core/n_clic.sv:244:7
			m_int_thresh_data = max_prio[7];
			// Trace: ../../../hdl/src/core/n_clic.sv:245:7
			m_int_thresh_write_enable = 1;
			// Trace: ../../../hdl/src/core/n_clic.sv:246:7
			interrupt_out = 1;
			// Trace: ../../../hdl/src/core/n_clic.sv:247:7
			pc_interrupt_sel = 1'b1;
			// Trace: ../../../hdl/src/core/n_clic.sv:248:7
			ext_write_enable[max_i] = 1;
			// Trace: ../../../hdl/src/core/n_clic.sv:249:7
			ext_entry_data[(7 - max_i) * 4+:4] = entry[max_i] & ~1;
			// Trace: ../../../hdl/src/core/n_clic.sv:250:7
			if (max_i == 0) begin
				// Trace: ../../../hdl/src/core/n_clic.sv:251:9
				$display("take timer");
				// Trace: ../../../hdl/src/core/n_clic.sv:252:9
				timer_interrupt_clear = 1;
			end
			else
				// Trace: ../../../hdl/src/core/n_clic.sv:253:16
				timer_interrupt_clear = 0;
			// Trace: ../../../hdl/src/core/n_clic.sv:254:7
			$display("max_i: %d", max_i);
			// Trace: ../../../hdl/src/core/n_clic.sv:255:7
			$display("max_index[VecSize-1] %d", max_index[7]);
			// Trace: ../../../hdl/src/core/n_clic.sv:256:7
			$display("interrupt take int_addr %d", int_addr);
		end
		else if ((((pc_in == ~sv2v_cast_02BB2_signed(0)) && entry[max_i][1]) && entry[max_i][0]) && (max_prio[7] >= m_int_thresh.data)) begin
			// Trace: ../../../hdl/src/core/n_clic.sv:261:7
			push = 0;
			// Trace: ../../../hdl/src/core/n_clic.sv:262:7
			pop = 0;
			// Trace: ../../../hdl/src/core/n_clic.sv:263:7
			int_addr = {max_vec[7], 2'b00};
			// Trace: ../../../hdl/src/core/n_clic.sv:264:7
			m_int_thresh_data = 0;
			// Trace: ../../../hdl/src/core/n_clic.sv:265:7
			m_int_thresh_write_enable = 0;
			// Trace: ../../../hdl/src/core/n_clic.sv:266:7
			interrupt_out = 1;
			// Trace: ../../../hdl/src/core/n_clic.sv:267:7
			pc_interrupt_sel = 1'b1;
			// Trace: ../../../hdl/src/core/n_clic.sv:268:7
			ext_write_enable[max_i] = 1;
			// Trace: ../../../hdl/src/core/n_clic.sv:269:7
			ext_entry_data[(7 - max_i) * 4+:4] = entry[max_i] & ~1;
			// Trace: ../../../hdl/src/core/n_clic.sv:270:7
			if (max_i == 0) begin
				// Trace: ../../../hdl/src/core/n_clic.sv:271:9
				$display("take timer");
				// Trace: ../../../hdl/src/core/n_clic.sv:272:9
				timer_interrupt_clear = 1;
			end
			else
				// Trace: ../../../hdl/src/core/n_clic.sv:273:16
				timer_interrupt_clear = 0;
			// Trace: ../../../hdl/src/core/n_clic.sv:274:7
			$display("tail chaining level_out %d, pop %d", level_out, pop);
		end
		else if (pc_in == ~sv2v_cast_02BB2_signed(0)) begin
			// Trace: ../../../hdl/src/core/n_clic.sv:277:7
			push = 0;
			// Trace: ../../../hdl/src/core/n_clic.sv:278:7
			pop = 1;
			// Trace: ../../../hdl/src/core/n_clic.sv:279:7
			int_addr = stack_out[config_pkg_IMemAddrWidth + 1-:((config_pkg_IMemAddrWidth + 1) >= 2 ? config_pkg_IMemAddrWidth : 3 - (config_pkg_IMemAddrWidth + 1))];
			// Trace: ../../../hdl/src/core/n_clic.sv:280:7
			m_int_thresh_data = stack_out[1-:config_pkg_PrioWidth];
			// Trace: ../../../hdl/src/core/n_clic.sv:281:7
			m_int_thresh_write_enable = 1;
			// Trace: ../../../hdl/src/core/n_clic.sv:282:7
			interrupt_out = 0;
			// Trace: ../../../hdl/src/core/n_clic.sv:283:7
			pc_interrupt_sel = 1'b1;
			// Trace: ../../../hdl/src/core/n_clic.sv:284:7
			timer_interrupt_clear = 0;
			// Trace: ../../../hdl/src/core/n_clic.sv:285:7
			$display("interrupt return");
		end
		else begin
			// Trace: ../../../hdl/src/core/n_clic.sv:288:7
			push = 0;
			// Trace: ../../../hdl/src/core/n_clic.sv:289:7
			pop = 0;
			// Trace: ../../../hdl/src/core/n_clic.sv:290:7
			m_int_thresh_data = 0;
			// Trace: ../../../hdl/src/core/n_clic.sv:291:7
			m_int_thresh_write_enable = 0;
			// Trace: ../../../hdl/src/core/n_clic.sv:292:7
			int_addr = pc_in;
			// Trace: ../../../hdl/src/core/n_clic.sv:293:7
			interrupt_out = 0;
			// Trace: ../../../hdl/src/core/n_clic.sv:294:7
			pc_interrupt_sel = 1'b0;
			// Trace: ../../../hdl/src/core/n_clic.sv:295:7
			timer_interrupt_clear = 0;
		end
	end
	// Trace: ../../../hdl/src/core/n_clic.sv:301:3
	localparam [11:0] config_pkg_StackDepthAddr = 'h350;
	localparam [11:0] config_pkg_TimerAddr = 'h400;
	function automatic [31:0] sv2v_cast_32;
		input reg [31:0] inp;
		sv2v_cast_32 = inp;
	endfunction
	always @(*) begin
		// Trace: ../../../hdl/src/core/n_clic.sv:302:5
		csr_out = 0;
		// Trace: ../../../hdl/src/core/n_clic.sv:303:5
		if (csr_addr == config_pkg_TimerAddr) begin
			// Trace: ../../../hdl/src/core/n_clic.sv:304:7
			csr_out = timer_out;
			// Trace: ../../../hdl/src/core/n_clic.sv:306:7
			$display("!!! CSR timer_out !!!");
		end
		else if (csr_addr == config_pkg_MIntThreshAddr) begin
			// Trace: ../../../hdl/src/core/n_clic.sv:308:7
			csr_out = m_int_thresh_out;
			// Trace: ../../../hdl/src/core/n_clic.sv:310:7
			$display("!!! CSR m_thresh_out !!!");
		end
		else if (csr_addr == config_pkg_StackDepthAddr) begin
			// Trace: ../../../hdl/src/core/n_clic.sv:312:7
			csr_out = sv2v_cast_32($unsigned(level_out));
			// Trace: ../../../hdl/src/core/n_clic.sv:314:7
			$display("!!! CSR StackDepth !!!");
		end
		else
			// Trace: ../../../hdl/src/core/n_clic.sv:316:7
			begin : sv2v_autoblock_3
				// Trace: ../../../hdl/src/core/n_clic.sv:316:12
				reg signed [31:0] k;
				// Trace: ../../../hdl/src/core/n_clic.sv:316:12
				for (k = 0; k < config_pkg_VecSize; k = k + 1)
					begin
						// Trace: ../../../hdl/src/core/n_clic.sv:317:9
						if (csr_addr == (config_pkg_VecCsrBase + sv2v_cast_12(k)))
							// Trace: ../../../hdl/src/core/n_clic.sv:318:11
							csr_out = vec_out[k];
						if (csr_addr == (config_pkg_EntryCsrBase + sv2v_cast_12(k)))
							// Trace: ../../../hdl/src/core/n_clic.sv:321:11
							csr_out = entry_out[k];
					end
			end
	end
endmodule
module pc_adder (
	in,
	out
);
	// Trace: ../../../hdl/src/core/pc_adder.sv:5:15
	parameter [31:0] AddrWidth = 32;
	// Trace: ../../../hdl/src/core/pc_adder.sv:6:21
	// removed localparam type AddrT
	// Trace: ../../../hdl/src/core/pc_adder.sv:8:5
	input wire [AddrWidth - 1:0] in;
	// Trace: ../../../hdl/src/core/pc_adder.sv:9:5
	output wire [AddrWidth - 1:0] out;
	// Trace: ../../../hdl/src/core/pc_adder.sv:11:3
	assign out = in + 4;
endmodule
// Trace: ../../../hdl/src/core/pc_branch_mux.sv:4:1
// removed ["import decoder_pkg::*;"]
module pc_branch_mux (
	sel,
	pc_next,
	pc_branch,
	out
);
	// Trace: ../../../hdl/src/core/pc_branch_mux.sv:6:15
	parameter [31:0] AddrWidth = 32;
	// Trace: ../../../hdl/src/core/pc_branch_mux.sv:7:21
	// removed localparam type AddrT
	// Trace: ../../../hdl/src/core/pc_branch_mux.sv:9:5
	// removed localparam type decoder_pkg_pc_branch_mux_t
	input wire sel;
	// Trace: ../../../hdl/src/core/pc_branch_mux.sv:10:5
	input wire [AddrWidth - 1:0] pc_next;
	// Trace: ../../../hdl/src/core/pc_branch_mux.sv:11:5
	input wire [AddrWidth - 1:0] pc_branch;
	// Trace: ../../../hdl/src/core/pc_branch_mux.sv:12:5
	output reg [AddrWidth - 1:0] out;
	// Trace: ../../../hdl/src/core/pc_branch_mux.sv:15:3
	always @(*)
		// Trace: ../../../hdl/src/core/pc_branch_mux.sv:16:5
		case (sel)
			1'b0:
				// Trace: ../../../hdl/src/core/pc_branch_mux.sv:17:18
				out = pc_next;
			1'b1:
				// Trace: ../../../hdl/src/core/pc_branch_mux.sv:18:18
				out = pc_branch;
			default:
				// Trace: ../../../hdl/src/core/pc_branch_mux.sv:19:18
				out = pc_next;
		endcase
endmodule
// Trace: ../../../hdl/src/core/pc_interrupt_mux.sv:4:1
// removed ["import decoder_pkg::*;"]
module pc_interrupt_mux (
	sel,
	pc_normal,
	pc_interrupt,
	out
);
	// Trace: ../../../hdl/src/core/pc_interrupt_mux.sv:6:15
	parameter [31:0] AddrWidth = 32;
	// Trace: ../../../hdl/src/core/pc_interrupt_mux.sv:7:21
	// removed localparam type AddrT
	// Trace: ../../../hdl/src/core/pc_interrupt_mux.sv:9:5
	// removed localparam type decoder_pkg_pc_interrupt_mux_t
	input wire sel;
	// Trace: ../../../hdl/src/core/pc_interrupt_mux.sv:10:5
	input wire [AddrWidth - 1:0] pc_normal;
	// Trace: ../../../hdl/src/core/pc_interrupt_mux.sv:11:5
	input wire [AddrWidth - 1:0] pc_interrupt;
	// Trace: ../../../hdl/src/core/pc_interrupt_mux.sv:12:5
	output reg [AddrWidth - 1:0] out;
	// Trace: ../../../hdl/src/core/pc_interrupt_mux.sv:15:3
	always @(*)
		// Trace: ../../../hdl/src/core/pc_interrupt_mux.sv:16:5
		case (sel)
			1'b0:
				// Trace: ../../../hdl/src/core/pc_interrupt_mux.sv:17:21
				out = pc_normal;
			1'b1:
				// Trace: ../../../hdl/src/core/pc_interrupt_mux.sv:18:21
				out = pc_interrupt;
			default:
				// Trace: ../../../hdl/src/core/pc_interrupt_mux.sv:19:21
				out = pc_normal;
		endcase
endmodule
module reg_n (
	clk,
	reset,
	in,
	out
);
	// Trace: ../../../hdl/src/core/reg_n.sv:5:15
	parameter integer DataWidth = 32;
	// Trace: ../../../hdl/src/core/reg_n.sv:7:5
	input wire clk;
	// Trace: ../../../hdl/src/core/reg_n.sv:8:5
	input wire reset;
	// Trace: ../../../hdl/src/core/reg_n.sv:9:5
	input wire [DataWidth - 1:0] in;
	// Trace: ../../../hdl/src/core/reg_n.sv:10:5
	output wire [DataWidth - 1:0] out;
	// Trace: ../../../hdl/src/core/reg_n.sv:12:3
	reg [DataWidth - 1:0] data;
	// Trace: ../../../hdl/src/core/reg_n.sv:14:3
	always @(posedge clk)
		// Trace: ../../../hdl/src/core/reg_n.sv:15:5
		if (reset)
			// Trace: ../../../hdl/src/core/reg_n.sv:15:16
			data <= 0;
		else
			// Trace: ../../../hdl/src/core/reg_n.sv:16:10
			data <= in;
	// Trace: ../../../hdl/src/core/reg_n.sv:20:3
	assign out = data;
endmodule
module register_file (
	clk_i,
	rst_ni,
	raddr_a_i,
	rdata_a_o,
	raddr_b_i,
	rdata_b_o,
	waddr_a_i,
	wdata_a_i,
	we_a_i,
	ra_set
);
	// removed import config_pkg::*;
	// Trace: ../../../hdl/src/core/register_file.sv:7:5
	input wire clk_i;
	// Trace: ../../../hdl/src/core/register_file.sv:8:5
	input wire rst_ni;
	// Trace: ../../../hdl/src/core/register_file.sv:11:5
	localparam [31:0] config_pkg_RegNum = 32;
	localparam [31:0] config_pkg_RegAddrWidth = 5;
	// removed localparam type config_pkg_RegAddrT
	input wire [4:0] raddr_a_i;
	// Trace: ../../../hdl/src/core/register_file.sv:12:5
	localparam [31:0] config_pkg_RegWidth = 32;
	// removed localparam type config_pkg_RegT
	output reg [31:0] rdata_a_o;
	// Trace: ../../../hdl/src/core/register_file.sv:14:5
	input wire [4:0] raddr_b_i;
	// Trace: ../../../hdl/src/core/register_file.sv:15:5
	output reg [31:0] rdata_b_o;
	// Trace: ../../../hdl/src/core/register_file.sv:17:5
	input wire [4:0] waddr_a_i;
	// Trace: ../../../hdl/src/core/register_file.sv:18:5
	input wire [31:0] wdata_a_i;
	// Trace: ../../../hdl/src/core/register_file.sv:19:5
	input wire we_a_i;
	// Trace: ../../../hdl/src/core/register_file.sv:21:5
	input wire ra_set;
	// Trace: ../../../hdl/src/core/register_file.sv:24:3
	wire [31:0] x3_31_a_o;
	// Trace: ../../../hdl/src/core/register_file.sv:25:3
	wire [31:0] x3_31_b_o;
	// Trace: ../../../hdl/src/core/register_file.sv:26:3
	reg x3_31_we;
	// Trace: ../../../hdl/src/core/register_file.sv:28:3
	rf #(.RegNum(29)) x3_x31(
		.clk_i(clk_i),
		.rst_ni(rst_ni),
		.raddr_a_i(raddr_a_i - 3),
		.rdata_a_o(x3_31_a_o),
		.raddr_b_i(raddr_b_i - 3),
		.rdata_b_o(x3_31_b_o),
		.waddr_a_i(waddr_a_i - 3),
		.wdata_a_i(wdata_a_i),
		.we_a_i(x3_31_we)
	);
	// Trace: ../../../hdl/src/core/register_file.sv:46:3
	wire [31:0] ra_a_o;
	// Trace: ../../../hdl/src/core/register_file.sv:47:3
	wire [31:0] ra_b_o;
	// Trace: ../../../hdl/src/core/register_file.sv:48:3
	reg ra_we;
	// Trace: ../../../hdl/src/core/register_file.sv:49:3
	reg [31:0] ra_wdata;
	// Trace: ../../../hdl/src/core/register_file.sv:51:3
	rf #(.RegNum(1)) ra(
		.clk_i(clk_i),
		.rst_ni(rst_ni),
		.raddr_a_i(0),
		.rdata_a_o(ra_a_o),
		.raddr_b_i(0),
		.rdata_b_o(ra_b_o),
		.waddr_a_i(0),
		.wdata_a_i(ra_wdata),
		.we_a_i(ra_we)
	);
	// Trace: ../../../hdl/src/core/register_file.sv:69:3
	localparam [4:0] config_pkg_Ra = 1;
	localparam [4:0] config_pkg_Sp = 2;
	always @(*) begin
		// Trace: ../../../hdl/src/core/register_file.sv:70:5
		if (raddr_a_i == config_pkg_Ra) begin
			// Trace: ../../../hdl/src/core/register_file.sv:71:7
			$display("raddr_a_i == Ra");
			// Trace: ../../../hdl/src/core/register_file.sv:72:7
			rdata_a_o = ra_a_o;
		end
		else
			// Trace: ../../../hdl/src/core/register_file.sv:73:14
			rdata_a_o = x3_31_a_o;
		if (raddr_b_i == config_pkg_Ra) begin
			// Trace: ../../../hdl/src/core/register_file.sv:76:7
			$display("raddr_b_i == Ra");
			// Trace: ../../../hdl/src/core/register_file.sv:77:7
			rdata_b_o = ra_b_o;
		end
		else
			// Trace: ../../../hdl/src/core/register_file.sv:78:14
			rdata_b_o = x3_31_b_o;
		// Trace: ../../../hdl/src/core/register_file.sv:80:5
		x3_31_we = we_a_i && (waddr_a_i > config_pkg_Sp);
		// Trace: ../../../hdl/src/core/register_file.sv:81:5
		ra_we = (we_a_i && (waddr_a_i == config_pkg_Ra)) || ra_set;
		if (ra_set)
			// Trace: ../../../hdl/src/core/register_file.sv:85:7
			ra_wdata = ~0;
		else
			// Trace: ../../../hdl/src/core/register_file.sv:87:7
			ra_wdata = wdata_a_i;
		// Trace: ../../../hdl/src/core/register_file.sv:90:5
		$display("x3_31_we %b, ra_we %b", x3_31_we, ra_we);
	end
endmodule
module rf (
	clk_i,
	rst_ni,
	raddr_a_i,
	rdata_a_o,
	raddr_b_i,
	rdata_b_o,
	waddr_a_i,
	wdata_a_i,
	we_a_i
);
	// removed import config_pkg::*;
	// Trace: ../../../hdl/src/core/register_file.sv:99:15
	parameter [31:0] RegNum = 32;
	// Trace: ../../../hdl/src/core/register_file.sv:100:16
	localparam [31:0] RegAddrWidth = ($clog2(RegNum) > 0 ? $clog2(RegNum) : 1);
	// Trace: ../../../hdl/src/core/register_file.sv:101:21
	// removed localparam type RegAddrT
	// Trace: ../../../hdl/src/core/register_file.sv:104:5
	input wire clk_i;
	// Trace: ../../../hdl/src/core/register_file.sv:105:5
	input wire rst_ni;
	// Trace: ../../../hdl/src/core/register_file.sv:108:5
	input wire [RegAddrWidth - 1:0] raddr_a_i;
	// Trace: ../../../hdl/src/core/register_file.sv:109:5
	localparam [31:0] config_pkg_RegWidth = 32;
	// removed localparam type config_pkg_RegT
	output wire [31:0] rdata_a_o;
	// Trace: ../../../hdl/src/core/register_file.sv:111:5
	input wire [RegAddrWidth - 1:0] raddr_b_i;
	// Trace: ../../../hdl/src/core/register_file.sv:112:5
	output wire [31:0] rdata_b_o;
	// Trace: ../../../hdl/src/core/register_file.sv:114:5
	input wire [RegAddrWidth - 1:0] waddr_a_i;
	// Trace: ../../../hdl/src/core/register_file.sv:115:5
	input wire [31:0] wdata_a_i;
	// Trace: ../../../hdl/src/core/register_file.sv:116:5
	input wire we_a_i;
	// Trace: ../../../hdl/src/core/register_file.sv:119:3
	reg [31:0] mem [0:RegNum - 1];
	// Trace: ../../../hdl/src/core/register_file.sv:120:3
	wire we;
	// Trace: ../../../hdl/src/core/register_file.sv:122:3
	assign we = we_a_i;
	// Trace: ../../../hdl/src/core/register_file.sv:123:3
	assign rdata_a_o = mem[raddr_a_i];
	// Trace: ../../../hdl/src/core/register_file.sv:124:3
	assign rdata_b_o = mem[raddr_b_i];
	// Trace: ../../../hdl/src/core/register_file.sv:126:3
	always @(posedge clk_i) begin : sync_write
		// Trace: ../../../hdl/src/core/register_file.sv:127:5
		if (we == 1'b1) begin
			// Trace: ../../../hdl/src/core/register_file.sv:128:7
			$display("<< -- write -- >>");
			// Trace: ../../../hdl/src/core/register_file.sv:129:7
			mem[waddr_a_i] <= wdata_a_i;
		end
	end
	// Trace: ../../../hdl/src/core/register_file.sv:134:3
	initial begin
		// Trace: ../../../hdl/src/core/register_file.sv:135:5
		begin : sv2v_autoblock_1
			// Trace: ../../../hdl/src/core/register_file.sv:135:10
			reg signed [31:0] k;
			// Trace: ../../../hdl/src/core/register_file.sv:135:10
			for (k = 0; k < RegNum; k = k + 1)
				begin
					// Trace: ../../../hdl/src/core/register_file.sv:136:7
					mem[k] = 0;
				end
		end
	end
	// Trace: ../../../hdl/src/core/register_file.sv:141:3
	wire unused_reset;
	// Trace: ../../../hdl/src/core/register_file.sv:142:3
	assign unused_reset = rst_ni;
endmodule
module rf_stack (
	clk,
	reset,
	writeEn,
	writeRaEn,
	level,
	writeAddr,
	writeData,
	readAddr1,
	readAddr2,
	readData1,
	readData2
);
	// removed import config_pkg::*;
	// Trace: ../../../hdl/src/core/rf_stack.sv:8:5
	input wire clk;
	// Trace: ../../../hdl/src/core/rf_stack.sv:9:5
	input wire reset;
	// Trace: ../../../hdl/src/core/rf_stack.sv:10:5
	input wire writeEn;
	// Trace: ../../../hdl/src/core/rf_stack.sv:11:5
	input wire writeRaEn;
	// Trace: ../../../hdl/src/core/rf_stack.sv:12:5
	localparam [31:0] config_pkg_PrioNum = 4;
	localparam [31:0] config_pkg_PrioWidth = 2;
	// removed localparam type config_pkg_PrioT
	input wire [1:0] level;
	// Trace: ../../../hdl/src/core/rf_stack.sv:13:5
	localparam [31:0] config_pkg_RegNum = 32;
	localparam [31:0] config_pkg_RegAddrWidth = 5;
	// removed localparam type config_pkg_RegAddrT
	input wire [4:0] writeAddr;
	// Trace: ../../../hdl/src/core/rf_stack.sv:14:5
	localparam [31:0] config_pkg_RegWidth = 32;
	// removed localparam type config_pkg_RegT
	input wire [31:0] writeData;
	// Trace: ../../../hdl/src/core/rf_stack.sv:15:5
	input wire [4:0] readAddr1;
	// Trace: ../../../hdl/src/core/rf_stack.sv:16:5
	input wire [4:0] readAddr2;
	// Trace: ../../../hdl/src/core/rf_stack.sv:17:5
	output reg [31:0] readData1;
	// Trace: ../../../hdl/src/core/rf_stack.sv:18:5
	output reg [31:0] readData2;
	// Trace: ../../../hdl/src/core/rf_stack.sv:20:3
	wire [31:0] a_o [0:3];
	// Trace: ../../../hdl/src/core/rf_stack.sv:21:3
	wire [31:0] b_o [0:3];
	// Trace: ../../../hdl/src/core/rf_stack.sv:22:3
	reg we [0:3];
	// Trace: ../../../hdl/src/core/rf_stack.sv:24:3
	reg ra_set [0:3];
	// Trace: ../../../hdl/src/core/rf_stack.sv:26:3
	genvar k;
	generate
		for (k = 0; k < config_pkg_PrioNum; k = k + 1) begin : gen_rf
			// Trace: ../../../hdl/src/core/rf_stack.sv:28:7
			register_file rf(
				.clk_i(clk),
				.rst_ni(reset),
				.raddr_a_i(readAddr1),
				.rdata_a_o(a_o[k]),
				.raddr_b_i(readAddr2),
				.rdata_b_o(b_o[k]),
				.waddr_a_i(writeAddr),
				.wdata_a_i(writeData),
				.we_a_i(we[k]),
				.ra_set(ra_set[k])
			);
		end
	endgenerate
	// Trace: ../../../hdl/src/core/rf_stack.sv:47:3
	wire [31:0] sp_a_o;
	// Trace: ../../../hdl/src/core/rf_stack.sv:48:3
	wire [31:0] sp_b_o;
	// Trace: ../../../hdl/src/core/rf_stack.sv:49:3
	reg sp_we;
	// Trace: ../../../hdl/src/core/rf_stack.sv:51:3
	rf #(.RegNum(1)) sp(
		.clk_i(clk),
		.rst_ni(reset),
		.raddr_a_i(1'sd0),
		.rdata_a_o(sp_a_o),
		.raddr_b_i(0),
		.rdata_b_o(sp_b_o),
		.waddr_a_i(1'sd0),
		.wdata_a_i(writeData),
		.we_a_i(sp_we)
	);
	// Trace: ../../../hdl/src/core/rf_stack.sv:69:3
	wire [1:0] level_reg_out;
	// Trace: ../../../hdl/src/core/rf_stack.sv:70:3
	reg_n #(.DataWidth(config_pkg_PrioWidth)) level_reg(
		.clk(clk),
		.reset(reset),
		.in(level),
		.out(level_reg_out)
	);
	// Trace: ../../../hdl/src/core/rf_stack.sv:79:3
	localparam [4:0] config_pkg_Ra = 1;
	localparam [4:0] config_pkg_Sp = 2;
	localparam [4:0] config_pkg_Zero = 0;
	function automatic [1:0] sv2v_cast_F4B85;
		input reg [1:0] inp;
		sv2v_cast_F4B85 = inp;
	endfunction
	always @(*) begin
		// Trace: ../../../hdl/src/core/rf_stack.sv:82:5
		sp_we = writeEn && (writeAddr == config_pkg_Sp);
		// Trace: ../../../hdl/src/core/rf_stack.sv:85:5
		begin : sv2v_autoblock_1
			// Trace: ../../../hdl/src/core/rf_stack.sv:85:10
			integer k;
			// Trace: ../../../hdl/src/core/rf_stack.sv:85:10
			for (k = 0; k < config_pkg_PrioNum; k = k + 1)
				begin
					// Trace: ../../../hdl/src/core/rf_stack.sv:86:7
					we[k] = ((level == sv2v_cast_F4B85(k)) && writeEn) && ((writeAddr == config_pkg_Ra) || (writeAddr > config_pkg_Sp));
					// Trace: ../../../hdl/src/core/rf_stack.sv:87:7
					ra_set[k] = 0;
				end
		end
		if (writeRaEn)
			// Trace: ../../../hdl/src/core/rf_stack.sv:91:20
			ra_set[level - 1] = 1;
		if (readAddr1 == config_pkg_Zero)
			// Trace: ../../../hdl/src/core/rf_stack.sv:94:28
			readData1 = 0;
		else if (readAddr1 == config_pkg_Sp)
			// Trace: ../../../hdl/src/core/rf_stack.sv:95:31
			readData1 = sp_a_o;
		else
			// Trace: ../../../hdl/src/core/rf_stack.sv:96:10
			readData1 = a_o[level];
		if (readAddr2 == config_pkg_Zero)
			// Trace: ../../../hdl/src/core/rf_stack.sv:98:28
			readData2 = 0;
		else if (readAddr2 == config_pkg_Sp)
			// Trace: ../../../hdl/src/core/rf_stack.sv:99:31
			readData2 = sp_b_o;
		else
			// Trace: ../../../hdl/src/core/rf_stack.sv:100:10
			readData2 = b_o[level];
	end
endmodule
module stack (
	clk,
	reset,
	push,
	pop,
	data_in,
	data_out,
	index_out
);
	// removed import decoder_pkg::*;
	// Trace: ../../../hdl/src/core/stack.sv:7:15
	parameter [31:0] StackDepth = 8;
	// Trace: ../../../hdl/src/core/stack.sv:8:16
	localparam integer StackDepthWidth = $clog2(StackDepth);
	// Trace: ../../../hdl/src/core/stack.sv:10:15
	parameter [31:0] DataWidth = 8;
	// Trace: ../../../hdl/src/core/stack.sv:12:5
	input wire clk;
	// Trace: ../../../hdl/src/core/stack.sv:13:5
	input wire reset;
	// Trace: ../../../hdl/src/core/stack.sv:14:5
	input wire push;
	// Trace: ../../../hdl/src/core/stack.sv:15:5
	input wire pop;
	// Trace: ../../../hdl/src/core/stack.sv:16:5
	input wire [DataWidth - 1:0] data_in;
	// Trace: ../../../hdl/src/core/stack.sv:17:5
	output wire [DataWidth - 1:0] data_out;
	// Trace: ../../../hdl/src/core/stack.sv:18:5
	output wire [StackDepthWidth - 1:0] index_out;
	// Trace: ../../../hdl/src/core/stack.sv:21:3
	reg [DataWidth - 1:0] data [0:StackDepth - 1];
	// Trace: ../../../hdl/src/core/stack.sv:22:3
	reg [StackDepthWidth - 1:0] index;
	// Trace: ../../../hdl/src/core/stack.sv:25:3
	function automatic [StackDepthWidth - 1:0] sv2v_cast_0D03F;
		input reg [StackDepthWidth - 1:0] inp;
		sv2v_cast_0D03F = inp;
	endfunction
	always @(posedge clk)
		// Trace: ../../../hdl/src/core/stack.sv:26:5
		if (reset)
			// Trace: ../../../hdl/src/core/stack.sv:27:7
			index <= sv2v_cast_0D03F(StackDepth - 1);
		else if (pop) begin
			// Trace: ../../../hdl/src/core/stack.sv:29:7
			$display("--- pop ---");
			// Trace: ../../../hdl/src/core/stack.sv:30:7
			index <= index + 1;
		end
		else if (push) begin
			// Trace: ../../../hdl/src/core/stack.sv:32:7
			$display("--- push ---");
			// Trace: ../../../hdl/src/core/stack.sv:33:7
			data[index - 1] <= data_in;
			// Trace: ../../../hdl/src/core/stack.sv:34:7
			index <= index - 1;
		end
	// Trace: ../../../hdl/src/core/stack.sv:38:3
	assign data_out = data[index];
	// Trace: ../../../hdl/src/core/stack.sv:39:3
	assign index_out = index;
endmodule
module time_stamp (
	clk,
	reset,
	mono_timer,
	pend,
	csr_addr,
	csr_out
);
	// removed import config_pkg::*;
	// removed import decoder_pkg::*;
	// Trace: ../../../hdl/src/core/time_stamp.sv:9:5
	input wire clk;
	// Trace: ../../../hdl/src/core/time_stamp.sv:10:5
	input wire reset;
	// Trace: ../../../hdl/src/core/time_stamp.sv:11:5
	localparam [31:0] config_pkg_MonoTimerWidth = 32;
	// removed localparam type config_pkg_MonoTimerT
	input wire [31:0] mono_timer;
	// Trace: ../../../hdl/src/core/time_stamp.sv:14:5
	localparam [31:0] config_pkg_VecSize = 8;
	input wire [0:7] pend;
	// Trace: ../../../hdl/src/core/time_stamp.sv:15:5
	// removed localparam type config_pkg_CsrAddrT
	input wire [11:0] csr_addr;
	// Trace: ../../../hdl/src/core/time_stamp.sv:16:5
	// removed localparam type decoder_pkg_word
	output reg [31:0] csr_out;
	// Trace: ../../../hdl/src/core/time_stamp.sv:18:3
	wire old_pend [0:7];
	// Trace: ../../../hdl/src/core/time_stamp.sv:20:3
	localparam [31:0] config_pkg_TimeStampWidth = 8;
	// removed localparam type config_pkg_TimeStampT
	wire [7:0] ext_data;
	// Trace: ../../../hdl/src/core/time_stamp.sv:21:3
	reg ext_write_enable [0:7];
	// Trace: ../../../hdl/src/core/time_stamp.sv:22:3
	reg ext_stretch_enable [0:7];
	// Trace: ../../../hdl/src/core/time_stamp.sv:23:3
	wire [31:0] temp_direct_out [0:7];
	// Trace: ../../../hdl/src/core/time_stamp.sv:24:3
	wire [31:0] temp_out [0:7];
	// Trace: ../../../hdl/src/core/time_stamp.sv:26:3
	genvar k;
	generate
		for (k = 0; k < config_pkg_VecSize; k = k + 1) begin : gen_stamp
			// Trace: ../../../hdl/src/core/time_stamp.sv:28:7
			csr #(
				.CsrWidth(config_pkg_TimeStampWidth),
				.Write(0)
			) csr_stamp(
				.clk(clk),
				.reset(reset),
				.csr_enable(0),
				.csr_addr(0),
				.csr_op(0),
				.rs1_zimm(0),
				.rs1_data(0),
				.ext_data(ext_data),
				.ext_write_enable(ext_write_enable[k]),
				.direct_out(temp_direct_out[k]),
				.out(temp_out[k])
			);
			// Trace: ../../../hdl/src/core/time_stamp.sv:46:7
			always @(posedge pend[k]) begin : gen_trig
				// Trace: ../../../hdl/src/core/time_stamp.sv:47:9
				ext_write_enable[k] <= 1;
				// Trace: ../../../hdl/src/core/time_stamp.sv:48:9
				ext_stretch_enable[k] <= 1;
			end
			// Trace: ../../../hdl/src/core/time_stamp.sv:52:7
			always @(posedge clk) begin : gen_un_trig
				// Trace: ../../../hdl/src/core/time_stamp.sv:53:9
				if (ext_stretch_enable[k])
					// Trace: ../../../hdl/src/core/time_stamp.sv:53:36
					ext_stretch_enable[k] <= 0;
				else
					// Trace: ../../../hdl/src/core/time_stamp.sv:54:14
					ext_write_enable[k] <= 0;
			end
		end
	endgenerate
	// Trace: ../../../hdl/src/core/time_stamp.sv:60:3
	localparam [31:0] config_pkg_TimeStampPreScaler = 0;
	function automatic [7:0] sv2v_cast_89F12;
		input reg [7:0] inp;
		sv2v_cast_89F12 = inp;
	endfunction
	assign ext_data = sv2v_cast_89F12(mono_timer >> config_pkg_TimeStampPreScaler);
	// Trace: ../../../hdl/src/core/time_stamp.sv:63:3
	localparam [11:0] config_pkg_TimeStampCsrBase = 'hb40;
	function automatic [11:0] sv2v_cast_12;
		input reg [11:0] inp;
		sv2v_cast_12 = inp;
	endfunction
	always @(*) begin : sv2v_autoblock_1
		reg [0:1] _sv2v_jump;
		_sv2v_jump = 2'b00;
		// Trace: ../../../hdl/src/core/time_stamp.sv:64:5
		begin : sv2v_autoblock_2
			// Trace: ../../../hdl/src/core/time_stamp.sv:64:10
			reg signed [31:0] k;
			// Trace: ../../../hdl/src/core/time_stamp.sv:64:10
			begin : sv2v_autoblock_3
				reg signed [31:0] _sv2v_value_on_break;
				for (k = 0; k < config_pkg_VecSize; k = k + 1)
					if (_sv2v_jump < 2'b10) begin
						_sv2v_jump = 2'b00;
						// Trace: ../../../hdl/src/core/time_stamp.sv:65:7
						if (csr_addr == (config_pkg_TimeStampCsrBase + sv2v_cast_12(k))) begin
							// Trace: ../../../hdl/src/core/time_stamp.sv:66:9
							csr_out = temp_out[k];
							// Trace: ../../../hdl/src/core/time_stamp.sv:67:9
							_sv2v_jump = 2'b10;
						end
						_sv2v_value_on_break = k;
					end
				if (!(_sv2v_jump < 2'b10))
					k = _sv2v_value_on_break;
				if (_sv2v_jump != 2'b11)
					_sv2v_jump = 2'b00;
			end
		end
	end
endmodule
module timer (
	clk,
	reset,
	csr_enable,
	csr_addr,
	csr_op,
	rs1_zimm,
	rs1_data,
	ext_data,
	ext_write_enable,
	interrupt_clear,
	interrupt_set,
	csr_direct_out,
	csr_out
);
	// removed import config_pkg::*;
	// removed import decoder_pkg::*;
	// Trace: ../../../hdl/src/core/timer.sv:9:5
	input wire clk;
	// Trace: ../../../hdl/src/core/timer.sv:10:5
	input wire reset;
	// Trace: ../../../hdl/src/core/timer.sv:12:5
	input wire csr_enable;
	// Trace: ../../../hdl/src/core/timer.sv:13:5
	// removed localparam type config_pkg_CsrAddrT
	input wire [11:0] csr_addr;
	// Trace: ../../../hdl/src/core/timer.sv:14:5
	// removed localparam type decoder_pkg_csr_op_t
	input wire [2:0] csr_op;
	// Trace: ../../../hdl/src/core/timer.sv:15:5
	// removed localparam type decoder_pkg_r
	input wire [4:0] rs1_zimm;
	// Trace: ../../../hdl/src/core/timer.sv:16:5
	// removed localparam type decoder_pkg_word
	input wire [31:0] rs1_data;
	// Trace: ../../../hdl/src/core/timer.sv:17:5
	localparam [31:0] config_pkg_TimerPreWith = 4;
	// removed localparam type config_pkg_TimerPresWidthT
	localparam [31:0] config_pkg_TimerWidth = 16;
	// removed localparam type config_pkg_TimerWidthT
	// removed localparam type config_pkg_TimerT
	input wire [(config_pkg_TimerWidth + config_pkg_TimerPreWith) - 1:0] ext_data;
	// Trace: ../../../hdl/src/core/timer.sv:18:5
	input wire ext_write_enable;
	// Trace: ../../../hdl/src/core/timer.sv:19:5
	input wire interrupt_clear;
	// Trace: ../../../hdl/src/core/timer.sv:21:5
	output wire interrupt_set;
	// Trace: ../../../hdl/src/core/timer.sv:22:5
	output wire [31:0] csr_direct_out;
	// Trace: ../../../hdl/src/core/timer.sv:23:5
	output wire [31:0] csr_out;
	// Trace: ../../../hdl/src/core/timer.sv:25:3
	assign csr_direct_out = 0;
	// Trace: ../../../hdl/src/core/timer.sv:26:3
	assign csr_out = 0;
	// Trace: ../../../hdl/src/core/timer.sv:27:3
	assign interrupt_set = 0;
endmodule
// Trace: ../../../hdl/src/core/wb_mux.sv:4:1
// removed ["import decoder_pkg::*;"]
module wb_mux (
	sel,
	alu,
	dm,
	csr,
	pc_plus_4,
	out
);
	// Trace: ../../../hdl/src/core/wb_mux.sv:6:5
	// removed localparam type decoder_pkg_wb_mux_t
	input wire [31:0] sel;
	// Trace: ../../../hdl/src/core/wb_mux.sv:7:5
	// removed localparam type decoder_pkg_word
	input wire [31:0] alu;
	// Trace: ../../../hdl/src/core/wb_mux.sv:8:5
	input wire [31:0] dm;
	// Trace: ../../../hdl/src/core/wb_mux.sv:9:5
	input wire [31:0] csr;
	// Trace: ../../../hdl/src/core/wb_mux.sv:10:5
	input wire [31:0] pc_plus_4;
	// Trace: ../../../hdl/src/core/wb_mux.sv:11:5
	output reg [31:0] out;
	// Trace: ../../../hdl/src/core/wb_mux.sv:14:3
	always @(*)
		// Trace: ../../../hdl/src/core/wb_mux.sv:15:5
		case (sel)
			32'd0:
				// Trace: ../../../hdl/src/core/wb_mux.sv:16:15
				out = alu;
			32'd1:
				// Trace: ../../../hdl/src/core/wb_mux.sv:17:14
				out = dm;
			32'd2:
				// Trace: ../../../hdl/src/core/wb_mux.sv:18:15
				out = csr;
			32'd3:
				// Trace: ../../../hdl/src/core/wb_mux.sv:19:21
				out = pc_plus_4;
			default:
				// Trace: ../../../hdl/src/core/wb_mux.sv:20:16
				out = alu;
		endcase
endmodule
module rom (
	clk,
	address,
	data_out
);
	// removed import config_pkg::*;
	// Trace: ../../../hdl/src/rom.sv:7:5
	input wire clk;
	// Trace: ../../../hdl/src/rom.sv:8:5
	localparam [31:0] config_pkg_IMemSize = 'h1000;
	localparam [31:0] config_pkg_IMemAddrWidth = $clog2(32'h00001000);
	// removed localparam type config_pkg_IMemAddrT
	input wire [config_pkg_IMemAddrWidth - 1:0] address;
	// Trace: ../../../hdl/src/rom.sv:9:5
	localparam [31:0] config_pkg_IMemDataWidth = 32;
	// removed localparam type config_pkg_IMemDataT
	output wire [31:0] data_out;
	// Trace: ../../../hdl/src/rom.sv:12:3
	reg [31:0] mem [0:(config_pkg_IMemSize >> 2) - 1];
	// Trace: ../../../hdl/src/rom.sv:13:3
	integer errno;
	// Trace: ../../../hdl/src/rom.sv:14:3
	integer fd;
	// Trace: ../../../hdl/src/rom.sv:20:3
	assign data_out = mem[address[config_pkg_IMemAddrWidth - 1:2]];
	// Trace: ../../../hdl/src/rom.sv:23:3
	initial begin
		// Trace: ../../../hdl/src/rom.sv:24:5
		begin : sv2v_autoblock_1
			// Trace: ../../../hdl/src/rom.sv:24:10
			integer k;
			// Trace: ../../../hdl/src/rom.sv:24:10
			for (k = 0; k < (config_pkg_IMemSize >> 2); k = k + 1)
				begin
					// Trace: ../../../hdl/src/rom.sv:25:7
					mem[k] = 0;
				end
		end
		// Trace: ../../../hdl/src/rom.sv:27:5
		$display("Loading memory file binary.mem");
	end
endmodule
module mem (
	clk,
	write_enable,
	width,
	sign_extend,
	address,
	data_in,
	data_out,
	alignment_error
);
	// removed import config_pkg::*;
	// removed import mem_pkg::*;
	// Trace: ../../../hdl/src/mem.sv:8:15
	parameter integer MemSize = 'h1000;
	// Trace: ../../../hdl/src/mem.sv:9:16
	localparam integer MemAddrWidth = $clog2(MemSize);
	// Trace: ../../../hdl/src/mem.sv:11:5
	input wire clk;
	// Trace: ../../../hdl/src/mem.sv:12:5
	input wire write_enable;
	// Trace: ../../../hdl/src/mem.sv:13:5
	// removed localparam type mem_pkg_mem_width_t
	input wire [1:0] width;
	// Trace: ../../../hdl/src/mem.sv:14:5
	input wire sign_extend;
	// Trace: ../../../hdl/src/mem.sv:15:5
	input wire [MemAddrWidth - 1:0] address;
	// Trace: ../../../hdl/src/mem.sv:16:5
	input wire [31:0] data_in;
	// Trace: ../../../hdl/src/mem.sv:17:5
	output reg [31:0] data_out;
	// Trace: ../../../hdl/src/mem.sv:18:5
	output reg alignment_error;
	// Trace: ../../../hdl/src/mem.sv:21:3
	reg [31:0] mem [0:(MemSize >> 2) - 1];
	// Trace: ../../../hdl/src/mem.sv:22:3
	reg [31:0] read_word;
	// Trace: ../../../hdl/src/mem.sv:23:3
	reg [31:0] write_word;
	// Trace: ../../../hdl/src/mem.sv:25:3
	always @(posedge clk)
		// Trace: ../../../hdl/src/mem.sv:27:5
		if (write_enable) begin
			// Trace: ../../../hdl/src/mem.sv:28:7
			write_word = mem[address[MemAddrWidth - 1:2]];
			// Trace: ../../../hdl/src/mem.sv:30:7
			case (width)
				2'b00:
					// Trace: ../../../hdl/src/mem.sv:32:11
					write_word[address[1:0] * 8+:8] = data_in[7:0];
				2'b01: begin
					// Trace: ../../../hdl/src/mem.sv:38:11
					write_word[{address[1:1], 1'sd1} * 8+:8] = data_in[15:8];
					// Trace: ../../../hdl/src/mem.sv:39:11
					write_word[{address[1:1], 1'sd0} * 8+:8] = data_in[7:0];
				end
				2'b10:
					// Trace: ../../../hdl/src/mem.sv:42:11
					write_word = data_in;
				default:
					;
			endcase
			// Trace: ../../../hdl/src/mem.sv:47:7
			mem[address[MemAddrWidth - 1:2]] = write_word;
		end
	// Trace: ../../../hdl/src/mem.sv:52:3
	function automatic signed [23:0] sv2v_cast_24_signed;
		input reg signed [23:0] inp;
		sv2v_cast_24_signed = inp;
	endfunction
	function automatic signed [15:0] sv2v_cast_16_signed;
		input reg signed [15:0] inp;
		sv2v_cast_16_signed = inp;
	endfunction
	always @(*) begin
		// Trace: ../../../hdl/src/mem.sv:53:5
		read_word = mem[address[MemAddrWidth - 1:2]];
		// Trace: ../../../hdl/src/mem.sv:54:5
		alignment_error = 0;
		// Trace: ../../../hdl/src/mem.sv:55:5
		case (width)
			2'b00:
				// Trace: ../../../hdl/src/mem.sv:57:9
				data_out = {sv2v_cast_24_signed($signed(read_word[(address[1:0] * 8) + 7-:1] && sign_extend)), read_word[address[1:0] * 8+:8]};
			2'b01: begin
				// Trace: ../../../hdl/src/mem.sv:62:9
				alignment_error = address[0:0];
				// Trace: ../../../hdl/src/mem.sv:63:9
				data_out = {sv2v_cast_16_signed($signed(read_word[({address[1:1], 1'sd1} * 8) + 7-:1] && sign_extend)), read_word[{address[1:1], 1'sd1} * 8+:8], read_word[{address[1:1], 1'sd0} * 8+:8]};
			end
			2'b10: begin
				// Trace: ../../../hdl/src/mem.sv:70:9
				alignment_error = address[1:0] != 0;
				// Trace: ../../../hdl/src/mem.sv:71:9
				data_out = read_word;
			end
			default:
				// Trace: ../../../hdl/src/mem.sv:73:16
				data_out = 0;
		endcase
	end
endmodule
module top_n_clic (
	clk,
	reset,
	btn,
	LED2
);
	// Trace: ../../../hdl/src/icebreaker_top_n_clic.sv:5:5
	input wire clk;
	// Trace: ../../../hdl/src/icebreaker_top_n_clic.sv:6:5
	input wire reset;
	// Trace: ../../../hdl/src/icebreaker_top_n_clic.sv:7:5
	input wire [3:0] btn;
	// Trace: ../../../hdl/src/icebreaker_top_n_clic.sv:8:5
	output wire LED2;
	// Trace: ../../../hdl/src/icebreaker_top_n_clic.sv:11:3
	// removed import config_pkg::*;
	// Trace: ../../../hdl/src/icebreaker_top_n_clic.sv:12:3
	// removed import decoder_pkg::*;
	// Trace: ../../../hdl/src/icebreaker_top_n_clic.sv:13:3
	// removed import mem_pkg::*;
	// Trace: ../../../hdl/src/icebreaker_top_n_clic.sv:15:3
	localparam [31:0] config_pkg_IMemSize = 'h1000;
	localparam [31:0] config_pkg_IMemAddrWidth = $clog2(32'h00001000);
	// removed localparam type config_pkg_IMemAddrT
	wire [config_pkg_IMemAddrWidth - 1:0] pc_interrupt_mux_out;
	// Trace: ../../../hdl/src/icebreaker_top_n_clic.sv:17:3
	wire [config_pkg_IMemAddrWidth - 1:0] pc_reg_out;
	// Trace: ../../../hdl/src/icebreaker_top_n_clic.sv:18:3
	reg_n #(.DataWidth(config_pkg_IMemAddrWidth)) pc_reg(
		.clk(clk),
		.reset(reset),
		.in(pc_interrupt_mux_out),
		.out(pc_reg_out)
	);
	// Trace: ../../../hdl/src/icebreaker_top_n_clic.sv:28:3
	// removed localparam type decoder_pkg_word
	wire [31:0] alu_res;
	// Trace: ../../../hdl/src/icebreaker_top_n_clic.sv:29:3
	// removed localparam type decoder_pkg_pc_branch_mux_t
	wire branch_logic_out;
	// Trace: ../../../hdl/src/icebreaker_top_n_clic.sv:30:3
	wire [config_pkg_IMemAddrWidth - 1:0] pc_adder_out;
	// Trace: ../../../hdl/src/icebreaker_top_n_clic.sv:31:3
	wire [config_pkg_IMemAddrWidth - 1:0] pc_branch_mux_out;
	// Trace: ../../../hdl/src/icebreaker_top_n_clic.sv:32:3
	function automatic [config_pkg_IMemAddrWidth - 1:0] sv2v_cast_02BB2;
		input reg [config_pkg_IMemAddrWidth - 1:0] inp;
		sv2v_cast_02BB2 = inp;
	endfunction
	pc_branch_mux #(.AddrWidth(config_pkg_IMemAddrWidth)) pc_branch_mux(
		.sel(branch_logic_out),
		.pc_next(pc_adder_out),
		.pc_branch(sv2v_cast_02BB2(alu_res)),
		.out(pc_branch_mux_out)
	);
	// Trace: ../../../hdl/src/icebreaker_top_n_clic.sv:41:3
	wire [config_pkg_IMemAddrWidth - 1:0] n_clic_interrupt_addr;
	// Trace: ../../../hdl/src/icebreaker_top_n_clic.sv:42:3
	// removed localparam type decoder_pkg_pc_interrupt_mux_t
	wire n_clic_pc_interrupt_sel;
	// Trace: ../../../hdl/src/icebreaker_top_n_clic.sv:43:3
	pc_interrupt_mux #(.AddrWidth(config_pkg_IMemAddrWidth)) pc_interrupt_mux(
		.sel(n_clic_pc_interrupt_sel),
		.pc_normal(pc_branch_mux_out),
		.pc_interrupt(n_clic_interrupt_addr),
		.out(pc_interrupt_mux_out)
	);
	// Trace: ../../../hdl/src/icebreaker_top_n_clic.sv:53:3
	pc_adder #(.AddrWidth(config_pkg_IMemAddrWidth)) pc_adder(
		.in(pc_reg_out),
		.out(pc_adder_out)
	);
	// Trace: ../../../hdl/src/icebreaker_top_n_clic.sv:61:3
	wire [31:0] imem_data_out;
	// Trace: ../../../hdl/src/icebreaker_top_n_clic.sv:72:3
	rom imem(
		.clk(clk),
		.address(pc_interrupt_mux_out[config_pkg_IMemAddrWidth - 1:0]),
		.data_out(imem_data_out)
	);
	// Trace: ../../../hdl/src/icebreaker_top_n_clic.sv:82:3
	// removed localparam type decoder_pkg_wb_mux_t
	wire [31:0] decoder_wb_mux_sel;
	// Trace: ../../../hdl/src/icebreaker_top_n_clic.sv:83:3
	// removed localparam type decoder_pkg_alu_a_mux_t
	wire [1:0] decoder_alu_a_mux_sel;
	// Trace: ../../../hdl/src/icebreaker_top_n_clic.sv:84:3
	// removed localparam type decoder_pkg_alu_b_mux_t
	wire [31:0] decoder_alu_b_mux_sel;
	// Trace: ../../../hdl/src/icebreaker_top_n_clic.sv:85:3
	// removed localparam type decoder_pkg_alu_op_t
	wire [2:0] decoder_alu_op;
	// Trace: ../../../hdl/src/icebreaker_top_n_clic.sv:86:3
	wire decoder_sub_arith;
	// Trace: ../../../hdl/src/icebreaker_top_n_clic.sv:87:3
	wire [31:0] decoder_imm;
	// Trace: ../../../hdl/src/icebreaker_top_n_clic.sv:88:3
	// removed localparam type decoder_pkg_r
	wire [4:0] decoder_rs1;
	// Trace: ../../../hdl/src/icebreaker_top_n_clic.sv:89:3
	wire [4:0] decoder_rs2;
	// Trace: ../../../hdl/src/icebreaker_top_n_clic.sv:92:3
	wire decoder_dmem_write_enable;
	// Trace: ../../../hdl/src/icebreaker_top_n_clic.sv:93:3
	wire decoder_dmem_sign_extend;
	// Trace: ../../../hdl/src/icebreaker_top_n_clic.sv:94:3
	// removed localparam type mem_pkg_mem_width_t
	wire [1:0] decoder_mem_with;
	// Trace: ../../../hdl/src/icebreaker_top_n_clic.sv:97:3
	wire decoder_branch_instr;
	// Trace: ../../../hdl/src/icebreaker_top_n_clic.sv:98:3
	// removed localparam type decoder_pkg_branch_op_t
	wire [2:0] decoder_branch_op;
	// Trace: ../../../hdl/src/icebreaker_top_n_clic.sv:99:3
	wire decoder_branch_always;
	// Trace: ../../../hdl/src/icebreaker_top_n_clic.sv:102:3
	wire decoder_csr_enable;
	// Trace: ../../../hdl/src/icebreaker_top_n_clic.sv:103:3
	// removed localparam type decoder_pkg_csr_op_t
	wire [2:0] decoder_csr_op;
	// Trace: ../../../hdl/src/icebreaker_top_n_clic.sv:104:3
	// removed localparam type config_pkg_CsrAddrT
	wire [11:0] decoder_csr_addr;
	// Trace: ../../../hdl/src/icebreaker_top_n_clic.sv:105:3
	wire [1:0] decoder_dmem_width;
	// Trace: ../../../hdl/src/icebreaker_top_n_clic.sv:106:3
	wire [4:0] decoder_rd;
	// Trace: ../../../hdl/src/icebreaker_top_n_clic.sv:109:3
	wire decoder_wb_write_enable;
	// Trace: ../../../hdl/src/icebreaker_top_n_clic.sv:111:3
	decoder decoder(
		.instr(imem_data_out),
		.csr_addr(decoder_csr_addr),
		.rs1(decoder_rs1),
		.rs2(decoder_rs2),
		.imm(decoder_imm),
		.branch_always(decoder_branch_always),
		.branch_instr(decoder_branch_instr),
		.branch_op(decoder_branch_op),
		.alu_a_mux_sel(decoder_alu_a_mux_sel),
		.alu_b_mux_sel(decoder_alu_b_mux_sel),
		.alu_op(decoder_alu_op),
		.sub_arith(decoder_sub_arith),
		.dmem_write_enable(decoder_dmem_write_enable),
		.dmem_sign_extend(decoder_dmem_sign_extend),
		.dmem_width(decoder_dmem_width),
		.csr_enable(decoder_csr_enable),
		.csr_op(decoder_csr_op),
		.wb_mux_sel(decoder_wb_mux_sel),
		.rd(decoder_rd),
		.wb_write_enable(decoder_wb_write_enable)
	);
	// Trace: ../../../hdl/src/icebreaker_top_n_clic.sv:143:3
	wire [31:0] wb_mux_out;
	// Trace: ../../../hdl/src/icebreaker_top_n_clic.sv:144:3
	wire [31:0] rf_rs1;
	// Trace: ../../../hdl/src/icebreaker_top_n_clic.sv:145:3
	wire [31:0] rf_rs2;
	// Trace: ../../../hdl/src/icebreaker_top_n_clic.sv:146:3
	wire n_clic_interrupt_out;
	// Trace: ../../../hdl/src/icebreaker_top_n_clic.sv:147:3
	wire [31:0] rf_stack_ra;
	// Trace: ../../../hdl/src/icebreaker_top_n_clic.sv:149:3
	localparam [31:0] config_pkg_PrioNum = 4;
	localparam [31:0] config_pkg_PrioWidth = 2;
	// removed localparam type config_pkg_PrioT
	wire [1:0] n_clic_level_out;
	// Trace: ../../../hdl/src/icebreaker_top_n_clic.sv:150:3
	rf_stack rf(
		.clk(clk),
		.reset(reset),
		.writeEn(decoder_wb_write_enable),
		.writeRaEn(n_clic_interrupt_out),
		.level(n_clic_level_out),
		.writeAddr(decoder_rd),
		.writeData(wb_mux_out),
		.readAddr1(decoder_rs1),
		.readAddr2(decoder_rs2),
		.readData1(rf_rs1),
		.readData2(rf_rs2)
	);
	// Trace: ../../../hdl/src/icebreaker_top_n_clic.sv:167:3
	branch_logic branch_logic(
		.a(rf_rs1),
		.b(rf_rs2),
		.branch_always(decoder_branch_always),
		.branch_instr(decoder_branch_instr),
		.op(decoder_branch_op),
		.out(branch_logic_out)
	);
	// Trace: ../../../hdl/src/icebreaker_top_n_clic.sv:179:3
	wire [31:0] alu_a_mux_out;
	// Trace: ../../../hdl/src/icebreaker_top_n_clic.sv:180:3
	alu_a_mux alu_a_mux(
		.sel(decoder_alu_a_mux_sel),
		.imm(decoder_imm),
		.rs1(rf_rs1),
		.zero(32'sd0),
		.out(alu_a_mux_out)
	);
	// Trace: ../../../hdl/src/icebreaker_top_n_clic.sv:190:3
	wire [31:0] alu_b_mux_out;
	// Trace: ../../../hdl/src/icebreaker_top_n_clic.sv:191:3
	function automatic signed [31:0] sv2v_cast_32_signed;
		input reg signed [31:0] inp;
		sv2v_cast_32_signed = inp;
	endfunction
	alu_b_mux alu_b_mux(
		.sel(decoder_alu_b_mux_sel),
		.rs2(rf_rs2),
		.imm(decoder_imm),
		.pc_plus_4(sv2v_cast_32_signed($signed(pc_adder_out))),
		.pc(sv2v_cast_32_signed($signed(pc_reg_out))),
		.out(alu_b_mux_out)
	);
	// Trace: ../../../hdl/src/icebreaker_top_n_clic.sv:203:3
	alu alu(
		.a(alu_a_mux_out),
		.b(alu_b_mux_out),
		.sub_arith(decoder_sub_arith),
		.op(decoder_alu_op),
		.res(alu_res)
	);
	// Trace: ../../../hdl/src/icebreaker_top_n_clic.sv:211:3
	wire [31:0] dmem_data_out;
	// Trace: ../../../hdl/src/icebreaker_top_n_clic.sv:212:3
	wire dmem_alignment_error;
	// Trace: ../../../hdl/src/icebreaker_top_n_clic.sv:213:3
	localparam [31:0] config_pkg_DMemSize = 'h1000;
	localparam [31:0] config_pkg_DMemAddrWidth = $clog2(32'h00001000);
	mem dmem(
		.clk(clk),
		.write_enable(decoder_dmem_write_enable),
		.width(decoder_dmem_width),
		.sign_extend(decoder_dmem_sign_extend),
		.address(alu_res[config_pkg_DMemAddrWidth - 1:0]),
		.data_in(rf_rs2),
		.data_out(dmem_data_out),
		.alignment_error(dmem_alignment_error)
	);
	// Trace: ../../../hdl/src/icebreaker_top_n_clic.sv:228:3
	wire [31:0] csr_led_out;
	// Trace: ../../../hdl/src/icebreaker_top_n_clic.sv:229:3
	wire [31:0] csr_led_direct_out;
	// Trace: ../../../hdl/src/icebreaker_top_n_clic.sv:230:3
	csr #(
		.CsrWidth(1),
		.Addr(0)
	) csr_led(
		.clk(clk),
		.reset(reset),
		.csr_enable(decoder_csr_enable),
		.csr_addr(decoder_csr_addr),
		.rs1_zimm(decoder_rs1),
		.rs1_data(rf_rs1),
		.csr_op(decoder_csr_op),
		.ext_data(0),
		.ext_write_enable(0),
		.direct_out(csr_led_direct_out),
		.out(csr_led_out)
	);
	// Trace: ../../../hdl/src/icebreaker_top_n_clic.sv:248:3
	assign LED2 = csr_led_out[0];
	// Trace: ../../../hdl/src/icebreaker_top_n_clic.sv:270:3
	wire [31:0] n_clic_csr_out;
	// Trace: ../../../hdl/src/icebreaker_top_n_clic.sv:271:3
	n_clic n_clic(
		.clk(clk),
		.reset(reset),
		.csr_enable(decoder_csr_enable),
		.csr_addr(decoder_csr_addr),
		.rs1_zimm(decoder_rs1),
		.rs1_data(rf_rs1),
		.csr_op(decoder_csr_op),
		.pc_in(pc_branch_mux_out),
		.csr_out(n_clic_csr_out),
		.int_addr(n_clic_interrupt_addr),
		.pc_interrupt_sel(n_clic_pc_interrupt_sel),
		.level_out(n_clic_level_out),
		.interrupt_out(n_clic_interrupt_out)
	);
	// Trace: ../../../hdl/src/icebreaker_top_n_clic.sv:290:3
	reg [31:0] csr_out;
	// Trace: ../../../hdl/src/icebreaker_top_n_clic.sv:292:3
	always @(*)
		// Trace: ../../../hdl/src/icebreaker_top_n_clic.sv:293:5
		csr_out = n_clic_csr_out;
	// Trace: ../../../hdl/src/icebreaker_top_n_clic.sv:302:3
	wb_mux wb_mux(
		.sel(decoder_wb_mux_sel),
		.dm(dmem_data_out),
		.alu(alu_res),
		.csr(csr_out),
		.pc_plus_4(sv2v_cast_32_signed($signed(pc_adder_out))),
		.out(wb_mux_out)
	);
endmodule
module top (
	CLK,
	LED1,
	LED2
);
	// removed import config_pkg::*;
	// removed import decoder_pkg::*;
	// Trace: fpga_icebreaker.sv:8:5
	input CLK;
	// Trace: fpga_icebreaker.sv:9:5
	output reg LED1;
	// Trace: fpga_icebreaker.sv:10:5
	output wire LED2;
	// Trace: fpga_icebreaker.sv:12:3
	wire [3:0] btn;
	// Trace: fpga_icebreaker.sv:13:3
	assign btn = 4'h0;
	// Trace: fpga_icebreaker.sv:15:3
	top_n_clic hippo(
		.clk(CLK),
		.reset(0),
		.btn(btn),
		.LED2(LED2)
	);
	// Trace: fpga_icebreaker.sv:22:3
	reg [31:0] r_count;
	// Trace: fpga_icebreaker.sv:25:3
	always @(posedge CLK) begin
		// Trace: fpga_icebreaker.sv:26:5
		r_count <= r_count + 1;
		// Trace: fpga_icebreaker.sv:27:5
		LED1 <= r_count[22];
	end
endmodule
