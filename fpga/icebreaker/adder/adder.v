/* Small test of adder on the iCEBreaker dev board. */

module adder(
	input a,
	input b,
	output s,
	output c
);

assign s = a ^ b;
assign c = a & b;

endmodule

module top (
    input CLK,

    output LED1,
    output LED2,
    output LED3,
    output LED4,
    output LED5,

    input BTN1,
    input BTN2,
    input BTN3
);

	wire a;
	wire b;
	wire s;
	wire c;

  assign LED1 = BTN1;
  assign 	LED2 = BTN2;
  assign 	LED3 = BTN3;

	assign a = BTN1;
	assign b = BTN2;
	assign LED4 = s;
	assign LED5 = c;
  

  adder adder_inst(
	a,
	b,
	s,
	c
  );

endmodule

