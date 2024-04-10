module adder (
	a,
	b,
	s,
	c
);
	input a;
	input b;
	output reg s;
	output reg c;
	localparam [31:0] a_pkg_X = 32;
	integer y = a_pkg_X;
	always @(*) begin
		s = a ^ b;
		c = a & b;
	end
endmodule
module top (
	CLK,
	LED1
);
	input CLK;
	output reg LED1;
	reg [31:0] r_count;
	reg a;
	reg b;
	wire s;
	wire c;
	always @(*) begin
		a = 0;
		b = 1;
	end
	adder adder_inst(
		.a(a),
		.b(b),
		.s(s),
		.c(c)
	);
	always @(posedge CLK) begin
		r_count <= r_count + 1;
		LED1 <= r_count[22];
	end
endmodule
