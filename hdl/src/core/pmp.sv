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

//assign test_addr_interval = '{'h400, 'h404};
//assign pmp_addr[0] = test_addr_interval;

//assign test_cfg = '{0,1};
//assign pmp_cfg[0] = test_cfg;


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
logic [2:0]  task_id;

assign task_id = one_hot_decode(id);

always_ff  @(interrupt_prio) begin
    ep_vec[task_id] = sp;
end

always_ff @(posedge clk) begin
    
    //pmp_cfg
    //pmp_addr
    if (reset == 1) begin
        ep_vec = '{default:'0};
    end else begin
        ep = ep_vec[task_id];
    end
    //Todo: have different memfaults for operations
    mem_fault_out = addr < ep && (op == OP_STORE || op == OP_LOAD);

    for (integer k = 0; k < rows; k++ ) begin
        if (pmp_addr_map[task_id][k].top_addr <= addr && pmp_addr_map[task_id][k].bot_addr >= addr && mem_fault_out) begin
            case (op)
            OP_LOAD: begin
                mem_fault_out = !pmp_cfg_map[task_id][k].read_en;
            end 
            OP_STORE: begin
                mem_fault_out = !pmp_cfg_map[task_id][k].write_en;
            end
            endcase 
        end
    end
end

endmodule


//ta upp i rapport?
function integer one_hot_decode;
   input [7:0] value;
   begin
        case (value)
            8'b00000001: one_hot_decode = 3'd0;
            8'b00000010: one_hot_decode = 3'd1;
            8'b00000100: one_hot_decode = 3'd2;
            8'b00001000: one_hot_decode = 3'd3;
            8'b00010000: one_hot_decode = 3'd4;
            8'b00100000: one_hot_decode = 3'd5;
            8'b01000000: one_hot_decode = 3'd6;
            8'b10000000: one_hot_decode = 3'd7;
            default:     one_hot_decode = -1;  // In case of invalid one-hot code
        endcase
   end
endfunction