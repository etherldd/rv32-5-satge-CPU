`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 2023/09/05 15:21:32
// Design Name: 
// Module Name: branch_comparator
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

module branch_comparator(
    input [31:0] A,
    input [31:0] B,
    output neq,
    output B_is_zero,
    output lt
    );
    assign lt = (A < B)? 1 : 0;
    assign neq = (A != B)? 1 : 0;
    assign B_is_zero = (B == 0)? 1 : 0;
endmodule

