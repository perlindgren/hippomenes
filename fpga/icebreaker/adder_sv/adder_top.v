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
	always @(*) begin
		s = a ^ b;
		c = a & b;
	end
endmodule
module top (
	CLK,
	LED1,
	LED2,
	LED3,
	LED4,
	LED5,
	BTN1,
	BTN2,
	BTN3
);
	input CLK;
	output reg LED1;
	output reg LED2;
	output reg LED3;
	output reg LED4;
	output reg LED5;
	input BTN1;
	input BTN2;
	input BTN3;
	reg a;
	reg b;
	wire s;
	wire c;
	always @(*) begin
		LED1 = BTN1;
		LED2 = BTN2;
		LED3 = BTN3;
		a = BTN1;
		b = BTN2;
		LED4 = s;
		LED5 = c;
	end
	adder adder_inst(
		.a(a),
		.b(b),
		.s(s),
		.c(c)
	);
endmodule
