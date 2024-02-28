`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 2023/10/11 10:31:25
// Design Name: 
// Module Name: MA_WB
// Project Name: 
// Target Devices: 
// Tool Versions: 
// Description: 
// 
// Dependencies: 
// 
// Revision:
// Revision 0.01 - File Created
// Additional Comments:
// 
//////////////////////////////////////////////////////////////////////////////////


module MA_WB(
    input clk,
    input resetn,
    input [31:0] new_inst,
    input [31:0] new_wbdata,
    input [31:0] new_pc,
    input new_branch_neq_ma,
    input new_branch_lt_ma,
    input new_branch_rs2_eq_0_ma,
    output [31:0] cur_inst,
    output [31:0] cur_pc,
    output [31:0] cur_wbdata,
    output cur_branch_neq_wb,
    output cur_branch_lt_wb,
    output cur_branch_rs2_eq_0_wb
    );
    reg [31:0] inst;
    reg [31:0] wbdata;
    reg [31:0] pc;
    reg branch_neq;
    reg branch_lt;
    reg branch_rs2_eq_0;
    initial begin
        inst <= 32'b0;
        pc <= 32'b0;
        wbdata <= 32'b0;
        branch_neq <= 0;
        branch_lt <= 0;
        branch_rs2_eq_0 <= 0;
    end
    always @(negedge clk) begin
        if (resetn) begin
            inst   <= new_inst;
            wbdata <= new_wbdata;
            pc <= new_pc;
            branch_neq <= new_branch_neq_ma;
            branch_lt <= new_branch_lt_ma;
            branch_rs2_eq_0 <= new_branch_rs2_eq_0_ma;
        end
    end
    assign cur_inst = inst;
    assign cur_pc =  pc;
    assign cur_wbdata = wbdata;
    assign cur_branch_neq_wb = branch_neq;
    assign cur_branch_lt_wb = branch_lt;
    assign cur_branch_rs2_eq_0_wb = branch_rs2_eq_0;
endmodule
