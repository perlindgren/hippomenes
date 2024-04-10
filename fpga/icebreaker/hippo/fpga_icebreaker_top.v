module top (
	CLK,
	LED1
);
	input CLK;
	output reg LED1;
	wire [3:0] btn;
	assign btn = 4'h0;
	top_n_clic hippo(
		.clk(CLK),
		.reset(0),
		.btn(btn)
	);
	reg [31:0] r_count;
	always @(posedge CLK) begin
		r_count <= r_count + 1;
		LED1 <= r_count[22];
	end
endmodule
module alu (
	a,
	b,
	sub_arith,
	op,
	res
);
	input wire [31:0] a;
	input wire [31:0] b;
	input wire sub_arith;
	input wire [2:0] op;
	output reg [31:0] res;
	always @(*)
		case (op)
			3'b000: res = a + b;
			3'b001: res = a << b[4:0];
			3'b010: res = {31'sd0, $signed(a) < $signed(b)};
			3'b011: res = {31'sd0, $unsigned(a) < $unsigned(b)};
			3'b100: res = a ^ b;
			3'b101:
				if (sub_arith)
					res = $signed(a) >>> b[4:0];
				else
					res = a >> b[4:0];
			3'b110: res = a | b;
			3'b111: res = a & b;
			default: res = 0;
		endcase
endmodule
module alu_a_mux (
	sel,
	imm,
	rs1,
	zero,
	out
);
	input wire [1:0] sel;
	input wire [31:0] imm;
	input wire [31:0] rs1;
	input wire [31:0] zero;
	output reg [31:0] out;
	always @(*)
		case (sel)
			2'b00: out = imm;
			2'b01: out = rs1;
			2'b10: out = zero;
			default: out = imm;
		endcase
endmodule
module alu_b_mux (
	sel,
	rs2,
	imm,
	pc_plus_4,
	pc,
	out
);
	input wire [31:0] sel;
	input wire [31:0] rs2;
	input wire [31:0] imm;
	input wire [31:0] pc_plus_4;
	input wire [31:0] pc;
	output reg [31:0] out;
	always @(*)
		case (sel)
			32'd0: out = rs2;
			32'd1: out = imm;
			32'd2: out = pc_plus_4;
			32'd3: out = pc;
			default: out = rs2;
		endcase
endmodule
module branch_logic (
	a,
	b,
	branch_always,
	branch_instr,
	op,
	out
);
	input wire [31:0] a;
	input wire [31:0] b;
	input wire branch_always;
	input wire branch_instr;
	input wire [2:0] op;
	output reg out;
	reg take;
	always @(*) begin
		case (op)
			3'b000: take = a == b;
			3'b001: take = a != b;
			3'b100: take = $signed(a) < $signed(b);
			3'b101: take = !($signed(a) < $signed(b));
			3'b110: take = $unsigned(a) < $unsigned(b);
			3'b111: take = !($unsigned(a) < $unsigned(b));
			default: take = 0;
		endcase
		out = branch_always || (branch_instr && take);
	end
endmodule
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
	parameter [31:0] CsrWidth = 32;
	function automatic [CsrWidth - 1:0] sv2v_cast_6F739;
		input reg [CsrWidth - 1:0] inp;
		sv2v_cast_6F739 = inp;
	endfunction
	parameter [CsrWidth - 1:0] ResetValue = sv2v_cast_6F739(0);
	parameter [11:0] Addr = 12'd0;
	parameter [0:0] Read = 1;
	parameter [0:0] Write = 1;
	input wire clk;
	input wire reset;
	input wire csr_enable;
	input wire [11:0] csr_addr;
	input wire [2:0] csr_op;
	input wire [4:0] rs1_zimm;
	input wire [31:0] rs1_data;
	input wire [CsrWidth - 1:0] ext_data;
	input wire ext_write_enable;
	output wire [31:0] direct_out;
	output wire [31:0] out;
	reg [CsrWidth - 1:0] data;
	reg [CsrWidth - 1:0] tmp;
	always @(*) begin
		tmp = data;
		if ((csr_enable && (csr_addr == Addr)) && Write) begin
			$display("@ %h", csr_addr);
			case (csr_op)
				3'b001: begin
					$display("CSR CSRRW %h", rs1_data);
					tmp = sv2v_cast_6F739(rs1_data);
				end
				3'b010:
					if (rs1_zimm != 0) begin
						$display("CSR CSRRS %h", rs1_data);
						tmp = data | sv2v_cast_6F739(rs1_data);
					end
				3'b011:
					if (rs1_zimm != 0) begin
						$display("CSR CSRRC %h", rs1_data);
						tmp = data & ~sv2v_cast_6F739(rs1_data);
					end
				3'b101: begin
					$display("CSR CSRRWI %h", rs1_zimm);
					tmp = sv2v_cast_6F739($unsigned(rs1_zimm));
				end
				3'b110:
					if (rs1_zimm != 0) begin
						$display("CSR CSRRSI %h", rs1_zimm);
						tmp = data | sv2v_cast_6F739($unsigned(rs1_zimm));
					end
				3'b111:
					if (rs1_zimm != 0) begin
						$display("CSR CSRRCI %h", rs1_zimm);
						tmp = data & ~sv2v_cast_6F739($unsigned(rs1_zimm));
					end
				default:
					;
			endcase
		end
	end
	function automatic [31:0] sv2v_cast_32;
		input reg [31:0] inp;
		sv2v_cast_32 = inp;
	endfunction
	assign direct_out = sv2v_cast_32($unsigned(tmp));
	assign out = sv2v_cast_32($unsigned(data));
	always @(posedge clk)
		if (reset)
			data <= ResetValue;
		else if (ext_write_enable) begin
			$display("--- ext data ---");
			data <= ext_data;
		end
		else
			data <= tmp;
endmodule
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
	input wire [31:0] instr;
	output reg [31:0] imm;
	output reg [11:0] csr_addr;
	output reg [4:0] rs1;
	output reg [4:0] rs2;
	output reg branch_always;
	output reg branch_instr;
	output reg [2:0] branch_op;
	output reg [1:0] alu_a_mux_sel;
	output reg [31:0] alu_b_mux_sel;
	output reg [2:0] alu_op;
	output reg sub_arith;
	output reg dmem_write_enable;
	output reg dmem_sign_extend;
	output reg [1:0] dmem_width;
	output reg csr_enable;
	output reg [2:0] csr_op;
	output reg [31:0] wb_mux_sel;
	output reg [4:0] rd;
	output reg wb_write_enable;
	reg [6:0] funct7;
	reg [2:0] funct3;
	reg [6:0] op;
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
		csr_addr = instr[31:20];
		{funct7, rs2, rs1, funct3, rd, op} = instr;
		$display;
		$display("inst %h, rs2 %b, rs1 %b, rd %b, opcode %b", instr, rs2, rs1, rd, op);
		imm = 0;
		branch_op = 3'b000;
		branch_instr = 0;
		branch_always = 0;
		alu_a_mux_sel = 2'b10;
		alu_b_mux_sel = 32'd1;
		alu_op = 3'b000;
		sub_arith = 0;
		dmem_write_enable = 0;
		dmem_sign_extend = 0;
		dmem_width = 2'b10;
		csr_enable = 0;
		csr_op = 3'b001;
		wb_mux_sel = 32'd0;
		wb_write_enable = 0;
		case (sv2v_cast_32_signed(op))
			32'sb00000000000000000000000000110111: begin
				$display("lui");
				imm = {instr[31:12], {12 {1'b0}}};
				alu_a_mux_sel = 2'b10;
				alu_b_mux_sel = 32'd1;
				alu_op = 3'b110;
				wb_mux_sel = 32'd0;
				wb_write_enable = 1;
			end
			32'sb00000000000000000000000000010111: begin
				$display("auipc");
				imm = {instr[31:12], {12 {1'b0}}};
				alu_a_mux_sel = 2'b00;
				alu_b_mux_sel = 32'd3;
				alu_op = 3'b000;
				wb_mux_sel = 32'd0;
				wb_write_enable = 1;
			end
			32'sb00000000000000000000000001101111: begin
				$display("jal");
				wb_write_enable = 1;
				imm = {sv2v_cast_12_signed($signed(instr[31])), instr[19:12], instr[20], instr[30:21], 1'b0};
				$display("--------  bl imm %h", imm);
				alu_a_mux_sel = 2'b00;
				alu_b_mux_sel = 32'd3;
				wb_mux_sel = 32'd3;
				branch_always = 1;
			end
			32'sb00000000000000000000000001100111: begin
				$display("jalr");
				wb_write_enable = 1;
				imm = sv2v_cast_32_signed($signed(instr[31:20]));
				alu_a_mux_sel = 2'b01;
				alu_b_mux_sel = 32'd1;
				wb_mux_sel = 32'd3;
				branch_always = 1;
			end
			32'sb00000000000000000000000001100011: begin
				$display("branch");
				branch_instr = 1;
				wb_write_enable = 0;
				imm = {sv2v_cast_20_signed($signed(instr[31])), instr[7], instr[30:25], instr[11:8], 1'b0};
				$display("--------  bl imm %h", imm);
				branch_op = funct3;
				alu_a_mux_sel = 2'b00;
				alu_b_mux_sel = 32'd3;
				alu_op = 3'b000;
			end
			32'sb00000000000000000000000000000011: begin
				$display("load");
				imm = {sv2v_cast_20_signed($signed(instr[31])), instr[31:20]};
				$display("--------  load imm %h", imm);
				branch_op = funct3;
				alu_a_mux_sel = 2'b01;
				alu_b_mux_sel = 32'd1;
				alu_op = 3'b000;
				dmem_width = funct3[1:0];
				dmem_sign_extend = !funct3[2];
				wb_mux_sel = 32'd1;
				wb_write_enable = 1;
			end
			32'sb00000000000000000000000000100011: begin
				$display("store");
				imm = {sv2v_cast_20_signed($signed(instr[31])), instr[31:25], instr[11:7]};
				$display("--------  store imm %h", imm);
				branch_op = funct3;
				alu_a_mux_sel = 2'b01;
				alu_b_mux_sel = 32'd1;
				alu_op = 3'b000;
				dmem_width = funct3[1:0];
				dmem_sign_extend = !funct3[2];
				dmem_write_enable = 1;
				wb_mux_sel = 32'd1;
				wb_write_enable = 0;
			end
			32'sb00000000000000000000000000010011: begin
				$display("alui");
				imm = sv2v_cast_32_signed($signed(instr[31:20]));
				sub_arith = instr[30];
				alu_a_mux_sel = 2'b01;
				alu_b_mux_sel = 32'd1;
				alu_op = funct3;
				wb_mux_sel = 32'd0;
				wb_write_enable = 1;
			end
			32'sb00000000000000000000000000110011: begin
				$display("alu");
				sub_arith = instr[30];
				alu_a_mux_sel = 2'b01;
				alu_b_mux_sel = 32'd0;
				alu_op = funct3;
				wb_mux_sel = 32'd0;
				wb_write_enable = 1;
			end
			32'sb00000000000000000000000000001111:
				$display("fence");
			32'sb00000000000000000000000001110011: begin
				$display("system");
				wb_write_enable = 1;
				wb_mux_sel = 32'd2;
				csr_enable = 1;
				csr_op = funct3;
			end
			default:
				$display("-- non matched op --");
		endcase
	end
endmodule
module mono_timer (
	clk,
	reset,
	mono_timer
);
	input wire clk;
	input wire reset;
	localparam [31:0] config_pkg_MonoTimerWidth = 32;
	output reg [31:0] mono_timer;
	always @(posedge clk)
		if (reset)
			mono_timer <= 0;
		else
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
	input wire clk;
	input wire reset;
	input wire csr_enable;
	input wire [11:0] csr_addr;
	input wire [4:0] rs1_zimm;
	input wire [31:0] rs1_data;
	input wire [2:0] csr_op;
	localparam [31:0] config_pkg_IMemSize = 'h1000;
	localparam [31:0] config_pkg_IMemAddrWidth = $clog2(32'h00001000);
	input wire [config_pkg_IMemAddrWidth - 1:0] pc_in;
	output reg [31:0] csr_out;
	output reg [config_pkg_IMemAddrWidth - 1:0] int_addr;
	output reg pc_interrupt_sel;
	localparam [31:0] config_pkg_PrioNum = 4;
	localparam [31:0] config_pkg_PrioWidth = 2;
	output wire [1:0] level_out;
	output reg interrupt_out;
	wire [31:0] timer_direct_out;
	wire [31:0] timer_out;
	wire timer_interrupt_set;
	reg timer_interrupt_clear;
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
	reg m_int_thresh_write_enable;
	wire [31:0] m_int_thresh_direct_out;
	wire [31:0] m_int_thresh_out;
	reg [1:0] m_int_thresh_data;
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
	wire [31:0] mstatus_direct_out;
	wire [31:0] mstatus_out;
	localparam [11:0] config_pkg_MStatusAddr = 'h300;
	localparam [31:0] config_pkg_MStatusWidth = 4;
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
	reg push;
	reg pop;
	wire [(config_pkg_IMemAddrWidth + config_pkg_PrioWidth) - 1:0] stack_out;
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
	localparam [31:0] config_pkg_VecSize = 8;
	wire [3:0] entry [0:7];
	wire [1:0] prio [0:7];
	wire [config_pkg_IMemAddrWidth - 3:0] csr_vec_data [0:7];
	reg [0:7] ext_write_enable;
	reg [31:0] ext_entry_data;
	wire [31:0] temp_vec [0:7];
	wire [31:0] temp_entry [0:7];
	wire [31:0] vec_out [0:7];
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
			assign entry[k] = sv2v_cast_2E83E(temp_entry[k]);
			assign prio[k] = entry[k][3-:2];
			assign csr_vec_data[k] = sv2v_cast_EDBD9(temp_vec[k]);
		end
	endgenerate
	reg [1:0] max_prio [0:7];
	reg [config_pkg_IMemAddrWidth - 3:0] max_vec [0:7];
	localparam [31:0] config_pkg_VecWidth = 3;
	reg [2:0] max_index [0:7];
	function automatic [2:0] sv2v_cast_92A66;
		input reg [2:0] inp;
		sv2v_cast_92A66 = inp;
	endfunction
	always @(*) begin
		if ((entry[0][1] && entry[0][0]) && (prio[0] >= m_int_thresh.data)) begin
			max_prio[0] = prio[0];
			max_vec[0] = csr_vec_data[0];
			max_index[0] = 0;
		end
		else begin
			max_prio[0] = m_int_thresh.data;
			max_vec[0] = 0;
			max_index[0] = 0;
		end
		begin : sv2v_autoblock_1
			integer k;
			for (k = 1; k < config_pkg_VecSize; k = k + 1)
				if ((entry[k][1] && entry[k][0]) && (prio[k] >= max_prio[k - 1])) begin
					max_prio[k] = prio[k];
					max_vec[k] = csr_vec_data[k];
					max_index[k] = sv2v_cast_92A66(k);
				end
				else begin
					max_prio[k] = max_prio[k - 1];
					max_vec[k] = max_vec[k - 1];
					max_index[k] = max_index[k - 1];
				end
		end
	end
	function automatic [3:0] sv2v_cast_35E60;
		input reg [3:0] inp;
		sv2v_cast_35E60 = inp;
	endfunction
	function automatic signed [config_pkg_IMemAddrWidth - 1:0] sv2v_cast_02BB2_signed;
		input reg signed [config_pkg_IMemAddrWidth - 1:0] inp;
		sv2v_cast_02BB2_signed = inp;
	endfunction
	always @(*) begin : sv2v_autoblock_2
		reg [2:0] max_i;
		max_i = max_index[7];
		ext_write_enable = {config_pkg_VecSize {1'b0}};
		ext_entry_data = {config_pkg_VecSize {sv2v_cast_35E60(1'sb0)}};
		if (timer_interrupt_set) begin
			ext_write_enable[0] = 1;
			ext_entry_data[28+:4] = entry[0] | 1;
		end
		if (mstatus_direct_out[3] == 0) begin
			push = 0;
			pop = 0;
			m_int_thresh_data = 0;
			m_int_thresh_write_enable = 0;
			int_addr = pc_in;
			interrupt_out = 0;
			pc_interrupt_sel = 1'b0;
			timer_interrupt_clear = 0;
		end
		else if (max_prio[7] > m_int_thresh.data) begin
			push = 1;
			pop = 0;
			int_addr = {max_vec[7], 2'b00};
			m_int_thresh_data = max_prio[7];
			m_int_thresh_write_enable = 1;
			interrupt_out = 1;
			pc_interrupt_sel = 1'b1;
			ext_write_enable[max_i] = 1;
			ext_entry_data[(7 - max_i) * 4+:4] = entry[max_i] & ~1;
			if (max_i == 0) begin
				$display("take timer");
				timer_interrupt_clear = 1;
			end
			else
				timer_interrupt_clear = 0;
			$display("max_i: %d", max_i);
			$display("max_index[VecSize-1] %d", max_index[7]);
			$display("interrupt take int_addr %d", int_addr);
		end
		else if ((((pc_in == ~sv2v_cast_02BB2_signed(0)) && entry[max_i][1]) && entry[max_i][0]) && (max_prio[7] >= m_int_thresh.data)) begin
			push = 0;
			pop = 0;
			int_addr = {max_vec[7], 2'b00};
			m_int_thresh_data = 0;
			m_int_thresh_write_enable = 0;
			interrupt_out = 1;
			pc_interrupt_sel = 1'b1;
			ext_write_enable[max_i] = 1;
			ext_entry_data[(7 - max_i) * 4+:4] = entry[max_i] & ~1;
			if (max_i == 0) begin
				$display("take timer");
				timer_interrupt_clear = 1;
			end
			else
				timer_interrupt_clear = 0;
			$display("tail chaining level_out %d, pop %d", level_out, pop);
		end
		else if (pc_in == ~sv2v_cast_02BB2_signed(0)) begin
			push = 0;
			pop = 1;
			int_addr = stack_out[config_pkg_IMemAddrWidth + 1-:((config_pkg_IMemAddrWidth + 1) >= 2 ? config_pkg_IMemAddrWidth : 3 - (config_pkg_IMemAddrWidth + 1))];
			m_int_thresh_data = stack_out[1-:config_pkg_PrioWidth];
			m_int_thresh_write_enable = 1;
			interrupt_out = 0;
			pc_interrupt_sel = 1'b1;
			timer_interrupt_clear = 0;
			$display("interrupt return");
		end
		else begin
			push = 0;
			pop = 0;
			m_int_thresh_data = 0;
			m_int_thresh_write_enable = 0;
			int_addr = pc_in;
			interrupt_out = 0;
			pc_interrupt_sel = 1'b0;
			timer_interrupt_clear = 0;
		end
	end
	localparam [11:0] config_pkg_StackDepthAddr = 'h350;
	localparam [11:0] config_pkg_TimerAddr = 'h400;
	function automatic [31:0] sv2v_cast_32;
		input reg [31:0] inp;
		sv2v_cast_32 = inp;
	endfunction
	always @(*) begin
		csr_out = 0;
		if (csr_addr == config_pkg_TimerAddr) begin
			csr_out = timer_out;
			$display("!!! CSR timer_out !!!");
		end
		else if (csr_addr == config_pkg_MIntThreshAddr) begin
			csr_out = m_int_thresh_out;
			$display("!!! CSR m_thresh_out !!!");
		end
		else if (csr_addr == config_pkg_StackDepthAddr) begin
			csr_out = sv2v_cast_32($unsigned(level_out));
			$display("!!! CSR StackDepth !!!");
		end
		else begin : sv2v_autoblock_3
			reg signed [31:0] k;
			for (k = 0; k < config_pkg_VecSize; k = k + 1)
				begin
					if (csr_addr == (config_pkg_VecCsrBase + sv2v_cast_12(k)))
						csr_out = vec_out[k];
					if (csr_addr == (config_pkg_EntryCsrBase + sv2v_cast_12(k)))
						csr_out = entry_out[k];
				end
		end
	end
endmodule
module pc_adder (
	in,
	out
);
	parameter [31:0] AddrWidth = 32;
	input wire [AddrWidth - 1:0] in;
	output wire [AddrWidth - 1:0] out;
	assign out = in + 4;
endmodule
module pc_branch_mux (
	sel,
	pc_next,
	pc_branch,
	out
);
	parameter [31:0] AddrWidth = 32;
	input wire sel;
	input wire [AddrWidth - 1:0] pc_next;
	input wire [AddrWidth - 1:0] pc_branch;
	output reg [AddrWidth - 1:0] out;
	always @(*)
		case (sel)
			1'b0: out = pc_next;
			1'b1: out = pc_branch;
			default: out = pc_next;
		endcase
endmodule
module pc_interrupt_mux (
	sel,
	pc_normal,
	pc_interrupt,
	out
);
	parameter [31:0] AddrWidth = 32;
	input wire sel;
	input wire [AddrWidth - 1:0] pc_normal;
	input wire [AddrWidth - 1:0] pc_interrupt;
	output reg [AddrWidth - 1:0] out;
	always @(*)
		case (sel)
			1'b0: out = pc_normal;
			1'b1: out = pc_interrupt;
			default: out = pc_normal;
		endcase
endmodule
module reg_n (
	clk,
	reset,
	in,
	out
);
	parameter integer DataWidth = 32;
	input wire clk;
	input wire reset;
	input wire [DataWidth - 1:0] in;
	output wire [DataWidth - 1:0] out;
	reg [DataWidth - 1:0] data;
	always @(posedge clk)
		if (reset)
			data <= 0;
		else
			data <= in;
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
	input wire clk_i;
	input wire rst_ni;
	localparam [31:0] config_pkg_RegNum = 32;
	localparam [31:0] config_pkg_RegAddrWidth = 5;
	input wire [4:0] raddr_a_i;
	localparam [31:0] config_pkg_RegWidth = 32;
	output reg [31:0] rdata_a_o;
	input wire [4:0] raddr_b_i;
	output reg [31:0] rdata_b_o;
	input wire [4:0] waddr_a_i;
	input wire [31:0] wdata_a_i;
	input wire we_a_i;
	input wire ra_set;
	wire [31:0] x3_31_a_o;
	wire [31:0] x3_31_b_o;
	reg x3_31_we;
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
	wire [31:0] ra_a_o;
	wire [31:0] ra_b_o;
	reg ra_we;
	reg [31:0] ra_wdata;
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
	localparam [4:0] config_pkg_Ra = 1;
	localparam [4:0] config_pkg_Sp = 2;
	always @(*) begin
		if (raddr_a_i == config_pkg_Ra) begin
			$display("raddr_a_i == Ra");
			rdata_a_o = ra_a_o;
		end
		else
			rdata_a_o = x3_31_a_o;
		if (raddr_b_i == config_pkg_Ra) begin
			$display("raddr_b_i == Ra");
			rdata_b_o = ra_b_o;
		end
		else
			rdata_b_o = x3_31_b_o;
		x3_31_we = we_a_i && (waddr_a_i > config_pkg_Sp);
		ra_we = (we_a_i && (waddr_a_i == config_pkg_Ra)) || ra_set;
		if (ra_set)
			ra_wdata = ~0;
		else
			ra_wdata = wdata_a_i;
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
	parameter [31:0] RegNum = 32;
	localparam [31:0] RegAddrWidth = ($clog2(RegNum) > 0 ? $clog2(RegNum) : 1);
	input wire clk_i;
	input wire rst_ni;
	input wire [RegAddrWidth - 1:0] raddr_a_i;
	localparam [31:0] config_pkg_RegWidth = 32;
	output wire [31:0] rdata_a_o;
	input wire [RegAddrWidth - 1:0] raddr_b_i;
	output wire [31:0] rdata_b_o;
	input wire [RegAddrWidth - 1:0] waddr_a_i;
	input wire [31:0] wdata_a_i;
	input wire we_a_i;
	reg [31:0] mem [0:RegNum - 1];
	wire we;
	assign we = we_a_i;
	assign rdata_a_o = mem[raddr_a_i];
	assign rdata_b_o = mem[raddr_b_i];
	always @(posedge clk_i) begin : sync_write
		if (we == 1'b1) begin
			$display("<< -- write -- >>");
			mem[waddr_a_i] <= wdata_a_i;
		end
	end
	initial begin : sv2v_autoblock_1
		reg signed [31:0] k;
		for (k = 0; k < RegNum; k = k + 1)
			mem[k] = 0;
	end
	wire unused_reset;
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
	input wire clk;
	input wire reset;
	input wire writeEn;
	input wire writeRaEn;
	localparam [31:0] config_pkg_PrioNum = 4;
	localparam [31:0] config_pkg_PrioWidth = 2;
	input wire [1:0] level;
	localparam [31:0] config_pkg_RegNum = 32;
	localparam [31:0] config_pkg_RegAddrWidth = 5;
	input wire [4:0] writeAddr;
	localparam [31:0] config_pkg_RegWidth = 32;
	input wire [31:0] writeData;
	input wire [4:0] readAddr1;
	input wire [4:0] readAddr2;
	output reg [31:0] readData1;
	output reg [31:0] readData2;
	wire [31:0] a_o [0:3];
	wire [31:0] b_o [0:3];
	reg we [0:3];
	reg ra_set [0:3];
	genvar k;
	generate
		for (k = 0; k < config_pkg_PrioNum; k = k + 1) begin : gen_rf
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
	wire [31:0] sp_a_o;
	wire [31:0] sp_b_o;
	reg sp_we;
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
	wire [1:0] level_reg_out;
	reg_n #(.DataWidth(config_pkg_PrioWidth)) level_reg(
		.clk(clk),
		.reset(reset),
		.in(level),
		.out(level_reg_out)
	);
	localparam [4:0] config_pkg_Ra = 1;
	localparam [4:0] config_pkg_Sp = 2;
	localparam [4:0] config_pkg_Zero = 0;
	function automatic [1:0] sv2v_cast_F4B85;
		input reg [1:0] inp;
		sv2v_cast_F4B85 = inp;
	endfunction
	always @(*) begin
		sp_we = writeEn && (writeAddr == config_pkg_Sp);
		begin : sv2v_autoblock_1
			integer k;
			for (k = 0; k < config_pkg_PrioNum; k = k + 1)
				begin
					we[k] = ((level == sv2v_cast_F4B85(k)) && writeEn) && ((writeAddr == config_pkg_Ra) || (writeAddr > config_pkg_Sp));
					ra_set[k] = 0;
				end
		end
		if (writeRaEn)
			ra_set[level - 1] = 1;
		if (readAddr1 == config_pkg_Zero)
			readData1 = 0;
		else if (readAddr1 == config_pkg_Sp)
			readData1 = sp_a_o;
		else
			readData1 = a_o[level];
		if (readAddr2 == config_pkg_Zero)
			readData2 = 0;
		else if (readAddr2 == config_pkg_Sp)
			readData2 = sp_b_o;
		else
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
	parameter [31:0] StackDepth = 8;
	localparam integer StackDepthWidth = $clog2(StackDepth);
	parameter [31:0] DataWidth = 8;
	input wire clk;
	input wire reset;
	input wire push;
	input wire pop;
	input wire [DataWidth - 1:0] data_in;
	output wire [DataWidth - 1:0] data_out;
	output wire [StackDepthWidth - 1:0] index_out;
	reg [DataWidth - 1:0] data [0:StackDepth - 1];
	reg [StackDepthWidth - 1:0] index;
	function automatic [StackDepthWidth - 1:0] sv2v_cast_0D03F;
		input reg [StackDepthWidth - 1:0] inp;
		sv2v_cast_0D03F = inp;
	endfunction
	always @(posedge clk)
		if (reset)
			index <= sv2v_cast_0D03F(StackDepth - 1);
		else if (pop) begin
			$display("--- pop ---");
			index <= index + 1;
		end
		else if (push) begin
			$display("--- push ---");
			data[index - 1] <= data_in;
			index <= index - 1;
		end
	assign data_out = data[index];
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
	input wire clk;
	input wire reset;
	localparam [31:0] config_pkg_MonoTimerWidth = 32;
	input wire [31:0] mono_timer;
	localparam [31:0] config_pkg_VecSize = 8;
	input wire [0:7] pend;
	input wire [11:0] csr_addr;
	output reg [31:0] csr_out;
	wire old_pend [0:7];
	localparam [31:0] config_pkg_TimeStampWidth = 8;
	wire [7:0] ext_data;
	reg ext_write_enable [0:7];
	reg ext_stretch_enable [0:7];
	wire [31:0] temp_direct_out [0:7];
	wire [31:0] temp_out [0:7];
	genvar k;
	generate
		for (k = 0; k < config_pkg_VecSize; k = k + 1) begin : gen_stamp
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
			always @(posedge pend[k]) begin : gen_trig
				ext_write_enable[k] <= 1;
				ext_stretch_enable[k] <= 1;
			end
			always @(posedge clk) begin : gen_un_trig
				if (ext_stretch_enable[k])
					ext_stretch_enable[k] <= 0;
				else
					ext_write_enable[k] <= 0;
			end
		end
	endgenerate
	localparam [31:0] config_pkg_TimeStampPreScaler = 0;
	function automatic [7:0] sv2v_cast_89F12;
		input reg [7:0] inp;
		sv2v_cast_89F12 = inp;
	endfunction
	assign ext_data = sv2v_cast_89F12(mono_timer >> config_pkg_TimeStampPreScaler);
	localparam [11:0] config_pkg_TimeStampCsrBase = 'hb40;
	function automatic [11:0] sv2v_cast_12;
		input reg [11:0] inp;
		sv2v_cast_12 = inp;
	endfunction
	always @(*) begin : sv2v_autoblock_1
		reg [0:1] _sv2v_jump;
		_sv2v_jump = 2'b00;
		begin : sv2v_autoblock_2
			reg signed [31:0] k;
			begin : sv2v_autoblock_3
				reg signed [31:0] _sv2v_value_on_break;
				for (k = 0; k < config_pkg_VecSize; k = k + 1)
					if (_sv2v_jump < 2'b10) begin
						_sv2v_jump = 2'b00;
						if (csr_addr == (config_pkg_TimeStampCsrBase + sv2v_cast_12(k))) begin
							csr_out = temp_out[k];
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
module wb_mux (
	sel,
	alu,
	dm,
	csr,
	pc_plus_4,
	out
);
	input wire [31:0] sel;
	input wire [31:0] alu;
	input wire [31:0] dm;
	input wire [31:0] csr;
	input wire [31:0] pc_plus_4;
	output reg [31:0] out;
	always @(*)
		case (sel)
			32'd0: out = alu;
			32'd1: out = dm;
			32'd2: out = csr;
			32'd3: out = pc_plus_4;
			default: out = alu;
		endcase
endmodule
module rom (
	clk,
	address,
	data_out
);
	input wire clk;
	localparam [31:0] config_pkg_IMemSize = 'h1000;
	localparam [31:0] config_pkg_IMemAddrWidth = $clog2(32'h00001000);
	input wire [config_pkg_IMemAddrWidth - 1:0] address;
	localparam [31:0] config_pkg_IMemDataWidth = 32;
	output wire [31:0] data_out;
	reg [31:0] mem [0:(config_pkg_IMemSize >> 2) - 1];
	integer errno;
	integer fd;
	assign data_out = mem[address[config_pkg_IMemAddrWidth - 1:2]];
	initial begin
		begin : sv2v_autoblock_1
			integer k;
			for (k = 0; k < (config_pkg_IMemSize >> 2); k = k + 1)
				mem[k] = 0;
		end
		$display("Loading memory file binary.mem");
		$readmemh("binary.mem", mem);
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
	parameter integer MemSize = 'h1000;
	localparam integer MemAddrWidth = $clog2(MemSize);
	input wire clk;
	input wire write_enable;
	input wire [1:0] width;
	input wire sign_extend;
	input wire [MemAddrWidth - 1:0] address;
	input wire [31:0] data_in;
	output reg [31:0] data_out;
	output reg alignment_error;
	reg [31:0] mem [0:(MemSize >> 2) - 1];
	reg [31:0] read_word;
	reg [31:0] write_word;
	always @(posedge clk)
		if (write_enable) begin
			write_word = mem[address[MemAddrWidth - 1:2]];
			case (width)
				2'b00: write_word[address[1:0] * 8+:8] = data_in[7:0];
				2'b01: begin
					write_word[{address[1:1], 1'sd1} * 8+:8] = data_in[15:8];
					write_word[{address[1:1], 1'sd0} * 8+:8] = data_in[7:0];
				end
				2'b10: write_word = data_in;
				default:
					;
			endcase
			mem[address[MemAddrWidth - 1:2]] = write_word;
		end
	function automatic signed [23:0] sv2v_cast_24_signed;
		input reg signed [23:0] inp;
		sv2v_cast_24_signed = inp;
	endfunction
	function automatic signed [15:0] sv2v_cast_16_signed;
		input reg signed [15:0] inp;
		sv2v_cast_16_signed = inp;
	endfunction
	always @(*) begin
		read_word = mem[address[MemAddrWidth - 1:2]];
		alignment_error = 0;
		case (width)
			2'b00: data_out = {sv2v_cast_24_signed($signed(read_word[(address[1:0] * 8) + 7-:1] && sign_extend)), read_word[address[1:0] * 8+:8]};
			2'b01: begin
				alignment_error = address[0:0];
				data_out = {sv2v_cast_16_signed($signed(read_word[({address[1:1], 1'sd1} * 8) + 7-:1] && sign_extend)), read_word[{address[1:1], 1'sd1} * 8+:8], read_word[{address[1:1], 1'sd0} * 8+:8]};
			end
			2'b10: begin
				alignment_error = address[1:0] != 0;
				data_out = read_word;
			end
			default: data_out = 0;
		endcase
	end
endmodule
module top_n_clic (
	clk,
	reset,
	btn
);
	input wire clk;
	input wire reset;
	input wire [3:0] btn;
	localparam [31:0] config_pkg_IMemSize = 'h1000;
	localparam [31:0] config_pkg_IMemAddrWidth = $clog2(32'h00001000);
	wire [config_pkg_IMemAddrWidth - 1:0] pc_interrupt_mux_out;
	wire [config_pkg_IMemAddrWidth - 1:0] pc_reg_out;
	reg_n #(.DataWidth(config_pkg_IMemAddrWidth)) pc_reg(
		.clk(clk),
		.reset(reset),
		.in(pc_interrupt_mux_out),
		.out(pc_reg_out)
	);
	wire [31:0] alu_res;
	wire branch_logic_out;
	wire [config_pkg_IMemAddrWidth - 1:0] pc_adder_out;
	wire [config_pkg_IMemAddrWidth - 1:0] pc_branch_mux_out;
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
	wire [config_pkg_IMemAddrWidth - 1:0] n_clic_interrupt_addr;
	wire n_clic_pc_interrupt_sel;
	pc_interrupt_mux #(.AddrWidth(config_pkg_IMemAddrWidth)) pc_interrupt_mux(
		.sel(n_clic_pc_interrupt_sel),
		.pc_normal(pc_branch_mux_out),
		.pc_interrupt(n_clic_interrupt_addr),
		.out(pc_interrupt_mux_out)
	);
	pc_adder #(.AddrWidth(config_pkg_IMemAddrWidth)) pc_adder(
		.in(pc_reg_out),
		.out(pc_adder_out)
	);
	wire [31:0] imem_data_out;
	rom imem(
		.clk(clk),
		.address(pc_interrupt_mux_out[config_pkg_IMemAddrWidth - 1:0]),
		.data_out(imem_data_out)
	);
	wire [31:0] decoder_wb_mux_sel;
	wire [1:0] decoder_alu_a_mux_sel;
	wire [31:0] decoder_alu_b_mux_sel;
	wire [2:0] decoder_alu_op;
	wire decoder_sub_arith;
	wire [31:0] decoder_imm;
	wire [4:0] decoder_rs1;
	wire [4:0] decoder_rs2;
	wire decoder_dmem_write_enable;
	wire decoder_dmem_sign_extend;
	wire [1:0] decoder_mem_with;
	wire decoder_branch_instr;
	wire [2:0] decoder_branch_op;
	wire decoder_branch_always;
	wire decoder_csr_enable;
	wire [2:0] decoder_csr_op;
	wire [11:0] decoder_csr_addr;
	wire [1:0] decoder_dmem_width;
	wire [4:0] decoder_rd;
	wire decoder_wb_write_enable;
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
	wire [31:0] wb_mux_out;
	wire [31:0] rf_rs1;
	wire [31:0] rf_rs2;
	wire n_clic_interrupt_out;
	wire [31:0] rf_stack_ra;
	localparam [31:0] config_pkg_PrioNum = 4;
	localparam [31:0] config_pkg_PrioWidth = 2;
	wire [1:0] n_clic_level_out;
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
	branch_logic branch_logic(
		.a(rf_rs1),
		.b(rf_rs2),
		.branch_always(decoder_branch_always),
		.branch_instr(decoder_branch_instr),
		.op(decoder_branch_op),
		.out(branch_logic_out)
	);
	wire [31:0] alu_a_mux_out;
	alu_a_mux alu_a_mux(
		.sel(decoder_alu_a_mux_sel),
		.imm(decoder_imm),
		.rs1(rf_rs1),
		.zero(32'sd0),
		.out(alu_a_mux_out)
	);
	wire [31:0] alu_b_mux_out;
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
	alu alu(
		.a(alu_a_mux_out),
		.b(alu_b_mux_out),
		.sub_arith(decoder_sub_arith),
		.op(decoder_alu_op),
		.res(alu_res)
	);
	wire [31:0] dmem_data_out;
	wire dmem_alignment_error;
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
	wire [31:0] n_clic_csr_out;
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
	reg [31:0] csr_out;
	always @(*) csr_out = n_clic_csr_out;
	wb_mux wb_mux(
		.sel(decoder_wb_mux_sel),
		.dm(dmem_data_out),
		.alu(alu_res),
		.csr(csr_out),
		.pc_plus_4(sv2v_cast_32_signed($signed(pc_adder_out))),
		.out(wb_mux_out)
	);
endmodule
