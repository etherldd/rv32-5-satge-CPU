`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 2023/10/11 10:30:55
// Design Name: 
// Module Name: EX_MA
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


module EX_MA(
    input clk,
    input resetn,
    input is_insert_nop,
    input [31:0] new_inst,
    input [31:0] new_pc,
    input [31:0] new_rs2_data,
    input [31:0] new_alu_out,
    input new_branch_neq_ex,
    input new_branch_lt_ex,
    input new_branch_rs2_eq_0_ex,
    output [31:0] cur_inst,
    output [31:0] cur_pc,
    output [31:0] cur_alu_out,
    output [31:0] cur_rs2_data,
    output cur_branch_neq_ma,
    output cur_branch_lt_ma,
    output cur_branch_rs2_eq_0_ma
    );
    reg [31:0] inst;
    reg [31:0] pc;
    reg [31:0] rs2_data; // for memery
    reg [31:0] alu_out;
    reg branch_neq;
    reg branch_lt;
    reg branch_rs2_eq_0;
    initial begin
        inst <= 32'b0;
        pc <= 32'b0;
        alu_out <= 32'b0;
        rs2_data <= 32'b0;
        branch_neq <= 0;
        branch_lt <= 0;
        branch_rs2_eq_0 <= 0;
    end
    always @(negedge clk) begin
        if (is_insert_nop) begin
            inst <= 32'b0;
            pc <= 32'b0;
            alu_out <= 32'b0;
            rs2_data <= 32'b0;
            branch_neq <= 0;
            branch_lt <= 0;
            branch_rs2_eq_0 <= 0;
        end
        else if (resetn) begin
            inst <= new_inst;
            pc   <= new_pc;
            rs2_data <= new_rs2_data;
            alu_out  <= new_alu_out;
            branch_neq <= new_branch_neq_ex;
            branch_lt <= new_branch_lt_ex;
            branch_rs2_eq_0 <= new_branch_rs2_eq_0_ex;
        end
    end
    assign cur_inst = inst;
    assign cur_pc   = pc;
    assign cur_alu_out = alu_out;
    assign cur_rs2_data = rs2_data;
    assign cur_branch_neq_ma = branch_neq;
    assign cur_branch_lt_ma = branch_lt;
    assign cur_branch_rs2_eq_0_ma = branch_rs2_eq_0;
endmodule
