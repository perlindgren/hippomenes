`timescale 1ns / 1ps

typedef enum integer {
    OP_LOAD   = 'b0000011,
    OP_STORE  = 'b0100011
} op_t;

//Physical memory protection
//Denies read/write access to memory if outside task's stack
//Can be granted access to memory outside stack if specified by csr
module pmp#(
    parameter integer unsigned maps = 8,  // Number of configurations
    parameter integer unsigned rows = 4
) (
    input logic clk,
    input logic reset,

    input logic [15:0] addr,   //The address which is accessed
    input logic [15:0] sp,
    input logic [6:0] op,
    input logic [7:0] interrupt_prio,
    input logic [2:0] id, 

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
    output logic mem_fault_out 
);


typedef struct packed {
    logic [13:0] addr;
    logic [15:0] length;
    logic       write_en;       // Write enable
    logic       read_en;        // Read enable
} pmp_addr_t;

// generate vector table
pmp_addr_t  pmp_addr_map    [maps][rows];


generate
    localparam CsrAddrT AddrCsrBase    = 'h400; // 3BF - B84 | 16 rader enlight spec
    word temp_addr [maps-1:0][rows-1:0];

    for (genvar k = 0; k < maps; k++) begin
        for (genvar i = 0; i < rows; i++) begin
            csr #(
                .Addr(AddrCsrBase + CsrAddrT'(i+rows*k))
            ) addr_csr (
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
                .ext_write_enable('0),
                .ext_data('0),
                // out
                .direct_out(temp_addr[k][i]),
                .out()//do i need?
            );
            assign pmp_addr_map[k][i]   = pmp_addr_t'(temp_addr[k][i]);
        end
    end
endgenerate

pmp_addr_t current_map[rows];

assign current_map   = pmp_addr_map[id];

bit [15:0] ep_vec[7:0];
bit [15:0] ep;
logic [7:0] last_prio;
logic below_ep;

logic [15:0] top_addr[rows];
logic [15:0] bot_addr[rows];
logic read_en[rows];
logic write_en[rows];
logic valid_access;

always_latch begin
    if (interrupt_prio != last_prio) begin
        ep_vec[id] = sp;
    end
    last_prio = interrupt_prio;
end

always_ff @(posedge reset) begin
    if (reset) begin
        ep_vec[id] = '{default: '0};
    end
end

assign ep = ep_vec[id];

always_comb begin
    valid_access = 0;
    below_ep = addr < ep;
    
    for (integer k = 0; k < rows; k++ ) begin
        bot_addr[k] = {current_map[k].addr, 2'b00};
        top_addr[k] = bot_addr[k] + current_map[k].length;
        read_en[k]  = current_map[k].read_en;
        write_en[k] = current_map[k].write_en;
        
        if ( top_addr[k] >= addr && bot_addr[k] <= addr && below_ep) begin
            case (op)
            OP_LOAD: begin
                valid_access = valid_access || read_en[k];
            end 
            OP_STORE: begin
                valid_access = valid_access || write_en[k];
            end
            endcase 
        end
    end
    
    mem_fault_out = !(below_ep == valid_access) && (op == OP_STORE || op == OP_LOAD);

end
endmodule