`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 2023/10/11 10:29:18
// Design Name: 
// Module Name: IF_DC
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


module IF_DC(
    input clk,
    input resetn,
    input is_stay,
    input [31:0] new_inst,
    input [31:0] new_pc,
    output [31:0] cur_inst,
    output [31:0] cur_pc
    );
    reg [31:0] inst;
    reg [31:0] pc;
    initial begin
        inst <= 32'b0;
        pc <= 32'b0;
    end
    always @(negedge clk) begin
        if (resetn && !is_stay) begin
            inst <= new_inst;
            pc   <= new_pc;
        end
    end
    assign cur_inst = inst;
    assign cur_pc = pc;
endmodule
