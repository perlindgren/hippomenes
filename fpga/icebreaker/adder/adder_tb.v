/* testbed */


module adder_tb();

  logic a;
  logic b;
  logic s;
  logic c;

  adder adder_inst(
	  a,
	  b,
	  s,
	  c
  );

  initial begin
    a = 0;
    b = 0;
    #10;

    a = 1;
    b = 0;
    #10;

    a = 0;
    b = 1;
    #10;

    a = 1;
    b = 1;
    #10;

  end

endmodule
