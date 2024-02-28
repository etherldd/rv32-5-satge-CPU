`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 2023/09/16 11:42:08
// Design Name: 
// Module Name: test_branch_comp
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


module test_branch_comp(

    );
    reg [31:0] A;
    reg [31:0] B;
    wire neq;
    wire B_is_zero;
    wire lt;
    branch_comparator bc(
    .A(A),
    .B(B),
    .neq(neq),
    .B_is_zero(B_is_zero),
    .lt(lt)
    );
    initial begin
        //test neq
        A = 32'b11;
        B = 32'b1;
        //test B_is_zero
        #10 B = 0;
        //test lt
        #10 A = 32'b1;
        B = 32'b111;
    end
endmodule
