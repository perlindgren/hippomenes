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
    input logic [6:0] op,
    input logic [7:0] interrupt_prio,
    input logic [7:0] id, 

    // csr registers
    input logic     csr_enable,
    input CsrAddrT  csr_addr,
    input r         rs1_zimm,
    input word      rs1_data,
    input csr_op_t  csr_op,
    
    // VCSR
    input CsrAddrT      vcsr_addr,
    input vcsr_width_t  vcsr_width,
    input vcsr_offset_t vcsr_offset,

    //interruption flag for n-clic    
    output logic mem_interrupt_out 
);


logic is_memory_accessed;
logic [15:0] ep_vec[7:0];
logic [15:0] ep;
csr #(
      .Addr('h400) 
  ) mstatus (
      .clk,
      .reset,
      .csr_enable,
      .csr_addr,
      .rs1_zimm,
      .rs1_data,
      .csr_op,
      .vcsr_width,
      .vcsr_offset,
      .vcsr_addr,
      .ext_data(MStatusT'(0)),
      .ext_write_enable(1'(0))
  );
  
initial begin
    
end

always_ff  @(interrupt_prio) begin
    ep_vec[$clog2(id)] = sp;
end

always_comb begin
    ep = ep_vec[$clog2(id)];
    
    if (reset == 1) begin
        ep_vec = '{default:'0};
    end
    //check if opcode is load/save
    if (op == OP_LOAD || op == OP_STORE )  begin
        is_memory_accessed = 1;
    end else begin
        is_memory_accessed = 0;
    end

    
    if ((addr < sp || addr > ep) && is_memory_accessed) begin
        mem_interrupt_out = 1;
    end else begin
        mem_interrupt_out = 0;
    end
end

endmodule