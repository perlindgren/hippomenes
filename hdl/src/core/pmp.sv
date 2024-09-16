`timescale 1ns / 1ps

typedef enum integer {
    OP_LOAD   = 'b0000011,
    OP_STORE  = 'b0100011
} op_t;

//Physical memory protection
//Denies read/write access to memory if outside task's stack
//Can be granted access to memory outside stack if specified by csr
module pmp(
    input logic clk,
    input logic reset,
    //On off flag
    input logic toggle, 
    input logic [15:0] addr,   //The address which is accessed
    input logic [15:0] sp,
    input logic interrupt_raised,
    input logic [6:0] op,
    input logic [7:0] id,

    //interruption flag for n-clic    
    output logic mem_interrupt_out 
);

logic [15:0] entry_point;
logic is_memory_accessed;

rf #(
      .RegNum(VecSize-1)  // A single instance for Ra
  )  ep ( // entry points
      // Clock and Reset
      .clk_i(clk),
      .rst_ni(reset),
      // Read port R1
      .raddr_a_i(id),
      .rdata_a_o(entry_point),
      // Write port W1
      .waddr_a_i(id),
      .wdata_a_i(sp),
      .we_a_i(interrupt_raised)
  );


always_comb begin
    //check if opcode is load/save
    if (op == OP_LOAD || op == OP_STORE )  begin
        is_memory_accessed = 1;
    end else begin
        is_memory_accessed = 0;
    end

    mem_interrupt_out = 0;
    if ((addr < sp || addr > entry_point) && is_memory_accessed) begin
        mem_interrupt_out = 1;
    end
end

endmodule