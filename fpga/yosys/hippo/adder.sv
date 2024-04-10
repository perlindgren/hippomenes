module adder (
    input  a,
    input  b,
    output s,
    output c
);

  import a_pkg::*;

  integer y = X;

  always_comb begin
    s = a ^ b;
    c = a & b;
  end

endmodule
