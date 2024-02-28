`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 2023/10/11 10:30:26
// Design Name: 
// Module Name: DC_EX
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


module DC_EX(
    input clk,
    input resetn,
    input is_stay,
    input is_rs1_change,
    input [31:0] new_rs1_value,
    input is_rs2_change,
    input [31:0] new_rs2_value,
    input [31:0] new_inst,
    input [31:0] new_pc,
    input [31:0] new_rs1_data,
    input [31:0] new_rs2_data,
    output [31:0] cur_inst,
    output [31:0] cur_pc,
    output [31:0] cur_rs1_data,
    output [31:0] cur_rs2_data
    );
    reg [31:0] inst;
    reg [31:0] pc;
    reg [31:0] rs1_data;
    reg [31:0] rs2_data;
    initial begin
        inst <= 32'b0;
        pc <= 32'b0;
        rs1_data <= 32'b0;
        rs2_data <= 32'b0;
    end
    always @(negedge clk) begin
        if (resetn && !is_stay) begin //error : no need for && "!is_stay", because if_dc stay , dc_ex will also stay.
            inst <= new_inst;
            pc   <= new_pc;
            rs1_data <= new_rs1_data;
            rs2_data <= new_rs2_data;
        end
        if (resetn && is_stay) begin
            if (is_rs1_change) begin
                rs1_data <= new_rs1_value;
            end
            if (is_rs2_change) begin
                rs2_data <= new_rs2_value;
            end
        end
    end
    assign cur_inst = inst;
    assign cur_pc   = pc;
    assign cur_rs1_data = rs1_data;
    assign cur_rs2_data = rs2_data;
endmodule
