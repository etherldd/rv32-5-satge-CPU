`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 2023/09/05 20:47:24
// Design Name: 
// Module Name: PC
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


module PC(
        input clk, 
        input resetn,
        input is_stay,
        input [31:0] wdata, 
        output reg [31:0] pc
        );
    initial begin
        pc <= 32'b0;
    end
    always @(posedge clk) begin
        if (resetn && !is_stay) begin
            pc <= wdata;
        end
    end
    always @(resetn) begin
        if (!resetn) begin
            pc <= 32'b0;
        end
    end
endmodule
