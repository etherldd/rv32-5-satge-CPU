`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 2023/08/30 11:50:54
// Design Name: 
// Module Name: full_adder
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


module full_adder(
    input wire[31:0] A,
    input wire[31:0] B,
    input wire Cin,
    output wire[31:0] F,
    output wire Cout
    );
    
    wire Over [31:0];
    assign Cout = Over[31];
    half_adder ha(.A(A[0]), .B(B[0]), .Cin(Cin), .F(F[0]),.Cout(Over[0]));
    genvar i;
    generate for  (i = 1; i < 32; i = i + 1) begin
            half_adder ha(.A(A[i]), .B(B[i]), .Cin(Over[i-1]), .F(F[i]), .Cout(Over[i]));
        end
    endgenerate
endmodule
