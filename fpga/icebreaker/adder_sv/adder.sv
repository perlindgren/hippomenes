/* Small test of SystemVerilog adder on the iCEBreaker dev board. */

module adder (
    input  a,
    input  b,
    output s,
    output c
);

  always_comb begin
    s = a ^ b;
    c = a & b;
  end

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

  logic a;
  logic b;
  logic s;
  logic c;

  always_comb begin
    LED1 = BTN1;
    LED2 = BTN2;
    LED3 = BTN3;
    a = BTN1;
    b = BTN2;
    LED4 = s;
    LED5 = c;
  end

  adder adder_inst (
      .a,
      .b,
      .s,
      .c
  );

endmodule

