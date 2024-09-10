`timescale 1ns / 1ps

typedef enum integer {
    OP_LOAD   = 'b0000011,
    OP_STORE  = 'b0100011
} op_t;

module pmp(
    //On off flag
    input logic toggle, 
    input logic [DMemAddrWidth-1:0] addr,   //The address which is accessed
    input logic [DMemAddrWidth-1:0] sp,
    input logic interrupt_raised,
    input logic [6:0] op,

    //interruption flag for n-clic    
    output logic mem_interrupt_out 
);

logic [DMemAddrWidth-1:0] task_entry[1];
logic is_memory_accessed;

initial begin
    task_entry[0] = '0;
end


always_comb begin
    //check if opcode is load/save
    if (op == OP_LOAD || op == OP_STORE )  begin
        is_memory_accessed = 1;
    end else begin
        is_memory_accessed = 0;
    end

    if (interrupt_raised == 1) begin
        task_entry[0] = sp;
    end


    mem_interrupt_out = 0;
    if ((addr < sp || addr > task_entry[0]) && is_memory_accessed) begin
        mem_interrupt_out = 1;
    end
    
end

endmodule