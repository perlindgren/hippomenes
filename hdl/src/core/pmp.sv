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

    //On off flag
    input logic toggle, 
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
    logic       locked;
    logic       reserved;
    logic [2:0] mode;           // pmpcfg.A
    logic       i_exection;     // instruction execution
    logic       write_en;       // Write enable
    logic       read_en;        // Read enable
} pmp_cfg_t;

typedef struct packed {
    logic [15:0] top_addr;
    logic [15:0] bot_addr;
} pmp_addr_t;

// generate vector table
pmp_addr_t  pmp_addr_map    [maps][rows];
pmp_cfg_t   pmp_cfg_map     [maps][rows];


generate
    localparam CsrAddrT AddrCsrBase    = 'h400; // 3BF - B84 | 16 rader enlight spec
    word temp_addr [maps-1:0][rows-1:0];

    //Todo: add csr control over cfg
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
                .ext_write_enable(0),
                .ext_data(0),
                // out
                .direct_out(temp_addr[k][i]),
                .out()//do i need?
            );
            assign pmp_addr_map[k][i]   = pmp_addr_t'(temp_addr[k][i]);
        end
    end
endgenerate

generate
    localparam integer unsigned cfg_rows    = rows>>2;
    localparam CsrAddrT         CfgCsrBase  = 'h480; // 3A0 - 3A3 | 4 rader
    word temp_cfg [maps-1:0][cfg_rows-1:0];
    //Todo: add csr control over cfg
    for (genvar k = 0; k < maps; k++) begin
        for (genvar i = 0; i < cfg_rows; i++) begin
            csr #(
                .Addr(CfgCsrBase + CsrAddrT'(i+cfg_rows*k))
            ) cfg_csr (
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
                .ext_write_enable(0),
                .ext_data(0),
                // out
                .direct_out(temp_cfg[k][i]),
                .out()//do i need?
            );
            assign pmp_cfg_map[k][4*i]      = pmp_cfg_t'(temp_cfg[k][i][7:0]);
            assign pmp_cfg_map[k][4*i+1]    = pmp_cfg_t'(temp_cfg[k][i][15:8]);
            assign pmp_cfg_map[k][4*i+2]    = pmp_cfg_t'(temp_cfg[k][i][23:16]);
            assign pmp_cfg_map[k][4*i+3]    = pmp_cfg_t'(temp_cfg[k][i][31:24]);
        end
    end
endgenerate

logic [15:0] ep_vec[7:0];
logic [15:0] ep;

always  @(interrupt_prio) begin
    ep_vec[id] = sp;
end

always_ff @(posedge clk) begin
    if (reset == 1) begin
        ep_vec = '{default:'0};
    end else begin
        ep = ep_vec[id];
    end
    //Todo: have different memfaults for operations
    mem_fault_out = addr < ep && (op == OP_STORE || op == OP_LOAD);
        
    for (integer k = 0; k < rows; k++ ) begin
        automatic logic [15:0] top_addr = pmp_addr_map[id][k].top_addr;
        automatic logic [15:0] bot_addr = pmp_addr_map[id][k].bot_addr;
        automatic logic read_en = pmp_cfg_map[id][k].read_en;
        automatic logic write_en = pmp_cfg_map[id][k].write_en;
        if ( top_addr <= addr && bot_addr >= addr && mem_fault_out) begin
            case (op)
            OP_LOAD: begin
                mem_fault_out = !read_en;
            end 
            OP_STORE: begin
                mem_fault_out = !write_en;
            end
            endcase 
        end
    end
end

endmodule