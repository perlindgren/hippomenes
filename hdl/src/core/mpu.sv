`timescale 1ns / 1ps

typedef enum integer {
    OP_LOAD   = 7'b0000011,
    OP_STORE  = 7'b0100011
} op_t;

//Physical memory protection
//Denies read/write access to memory if outside task's stack
//Can be granted access to memory outside stack if specified by csr
module mpu#(
    parameter integer unsigned maps = 9,  // Number of configurations
    parameter integer unsigned rows = 4,
    parameter integer unsigned stack_top = 1280
) (
    input logic clk,
    input logic reset,

    input logic [15:0] mem_address,   //The address which is accessed
    input logic [15:0] sp,
    input logic [6:0] op,
    input logic [7:0] interrupt_prio,
    input logic [3:0] id, 

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
    output logic mem_fault_out,
    output logic mem_fault_out_ff
);

typedef struct packed {
    logic [15:0] mem_address;
    logic [13:0] length;
    logic        write_en;       // Write enable
    logic        read_en;        // Read enable
} mpu_addr_t;

// generate vector table
mpu_addr_t  mpu_addr_map    [maps][rows];


generate
localparam CsrAddrT AddrCsrBase    = 'h400; 
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
            .direct_out(temp_addr[k][i])
            //.out()//do i need?
        );
        assign mpu_addr_map[k][i]   = mpu_addr_t'(temp_addr[k][i]);
    end
end
endgenerate

mpu_addr_t current_map[rows];


bit [15:0] ep_vec[3:0];
bit [15:0] ep;
logic [7:0] last_prio;
logic [rows-1:0]invalid_access;
logic invalid_stack;

always_ff @(posedge clk) begin
    if (reset) begin
        ep_vec <= '{default: '0};
        last_prio <= '0;
    end
    if (interrupt_prio != last_prio)begin
        ep_vec[interrupt_prio] = sp;
    end
    last_prio <= interrupt_prio;
    ep = ep_vec[interrupt_prio];
    current_map         <= mpu_addr_map[id];
    mem_fault_out_ff    <= mem_fault_out;
    invalid_stack       = (mem_address > ep || mem_address < stack_top);
end
genvar k;

generate
    logic [15:0] top_addr[rows];
    logic [15:0] bot_addr[rows];
    logic read_en[rows];
    logic write_en[rows];
    for (k = 0; k < rows; k++ ) begin
        always_comb begin
            bot_addr[k] = current_map[k].mem_address;
            top_addr[k] = bot_addr[k] + current_map[k].length;
            read_en[k]  = current_map[k].read_en;
            write_en[k] = current_map[k].write_en;
            
            if ( top_addr[k] >= mem_address && bot_addr[k] <= mem_address) begin
                case (op)
                    OP_LOAD:    invalid_access[k] = !read_en[k];
                    OP_STORE:   invalid_access[k] = !write_en[k];
                    default:    invalid_access[k] = 1;
                endcase 
            end 
            else begin
                invalid_access[k] = 1;
            end
        end
    end
endgenerate
always_comb begin
    mem_fault_out = &invalid_access && invalid_stack && (OP_LOAD == op || OP_STORE == op);
end
endmodule
