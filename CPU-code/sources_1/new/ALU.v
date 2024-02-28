`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 2023/08/30 11:51:49
// Design Name: 
// Module Name: ALU
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
`define OP_1     5'b00001
`define OP_2     5'b00010
`define OP_3     5'b00011
`define OP_4     5'b00100
`define OP_5     5'b00101
`define OP_6     5'b00110
`define OP_7     5'b00111
`define OP_8     5'b01000
`define OP_9     5'b01001
`define OP_10    5'b01010
`define OP_11    5'b01011
`define OP_12    5'b01100
`define OP_13    5'b01101
`define OP_14    5'b01110
`define OP_15    5'b01111
`define OP_16    5'b10000

module ALU(
    input [31:0] A ,
    input [31:0] B ,
    input Cin ,
    input [4 :0] Card,
    output [31:0] F ,
    output Cout,
    output Zero
    );
        wire [31:0] result [15:0];
        wire Couts [15:0];
        wire Zeros [15:0];
        genvar j;
        generate    for (j = 0; j < 16; j = j+1) begin
                assign Zeros[j] = &(~(result[j]));
            end
        endgenerate
        wire grand;
        assign grand = 0;
        //full_adder fa(.A(), .B(), .Cin(), .F(), .Cout());
        //1.for A + B
        full_adder fa1(.A(A), .B(B), .Cin(grand), .F(result[0]), .Cout(Couts[0]));
        //2.for A + B + Cin
        full_adder fa2(.A(A), .B(B), .Cin(Cin), .F(result[1]), .Cout(Couts[1]));
        //new2 for slt
        assign result[1] = A < B ? 1 : 0;

        //prepare for 3 4 5 6
        wire [31:0] B_neg, A_neg;
        wire Cin_neg;
        assign B_neg = ~B + 1;
        assign A_neg = ~A + 1;
        assign Cin_neg = ~Cin_neg + 1;
        //3.for A - B
        //4.for A - B - Cin
        full_adder fa3(.A(A), .B(B_neg), .Cin(grand), .F(result[2]), .Cout(Couts[2]));
        wire [31:0] result3_pre;
        full_adder fa4(.A(A), .B(B_neg), .Cin(grand), .F(result3_pre), .Cout(Couts[3]));
        assign result[3] = Cin ? result3_pre - 1: result3_pre;
        //5.for B - A
        //6.for B - A - Cin
        full_adder fa5(.A(A_neg), .B(B), .Cin(grand), .F(result[4]),  .Cout(Couts[4]));
        wire [31:0] result5_pre;
        full_adder fa6(.A(A_neg), .B(B), .Cin(grand), .F(result5_pre), .Cout(Couts[5]));
        assign result[5] = Cin? result5_pre - 1: result5_pre;
        //7.for A
        //8.for B
        assign result[6] = A;
        assign result[7] = B;
        assign result[8] = ~A;
        assign result[9] = ~B;
        assign result[10] = A | B;
        assign result[11] = A & B;
        assign result[12] = A ^ B;
        assign result[13] = ~(A ^ B);
        assign result[14] = ~(A & B);
        assign result[15] = A << B;
        //for later Couts
        genvar i;
        generate for (i = 6; i < 16; i = i+1) begin
            assign Couts[i] = 0;
        end
        endgenerate
        assign F = 
        ({32{Card == `OP_1}}  & result[0]) |
        ({32{Card == `OP_2}}  & result[1]) |
        ({32{Card == `OP_3}}  & result[2]) |
        ({32{Card == `OP_4}}  & result[3]) |
        ({32{Card == `OP_5}}  & result[4]) |
        ({32{Card == `OP_6}}  & result[5]) |
        ({32{Card == `OP_7}}  & result[6]) |
        ({32{Card == `OP_8}}  & result[7]) |
        ({32{Card == `OP_9}}  & result[8]) |
        ({32{Card == `OP_10}} & result[9]) |
        ({32{Card == `OP_11}} & result[10]) |
        ({32{Card == `OP_12}} & result[11]) |
        ({32{Card == `OP_13}} & result[12]) |
        ({32{Card == `OP_14}} & result[13]) |
        ({32{Card == `OP_15}} & result[14]) |
        ({32{Card == `OP_16}} & result[15]);

        assign Cout = 
        ({Card == `OP_1}  & Couts[0]) |
        ({Card == `OP_2}  & Couts[1]) |
        ({Card == `OP_3}  & Couts[2]) |
        ({Card == `OP_4}  & Couts[3]) |
        ({Card == `OP_5}  & Couts[4]) |
        ({Card == `OP_6}  & Couts[5]) |
        ({Card == `OP_7}  & Couts[6]) |
        ({Card == `OP_8}  & Couts[7]) |
        ({Card == `OP_9}  & Couts[8]) |
        ({Card == `OP_10} & Couts[9]) |
        ({Card == `OP_11} & Couts[10]) |
        ({Card == `OP_12} & Couts[11]) |
        ({Card == `OP_13} & Couts[12]) |
        ({Card == `OP_14} & Couts[13]) |
        ({Card == `OP_15} & Couts[14]) |
        ({Card == `OP_16} & Couts[15]);
        
        assign Zero = 
        ({Card == `OP_1}  & Zeros[0]) |
        ({Card == `OP_2}  & Zeros[1]) |
        ({Card == `OP_3}  & Zeros[2]) |
        ({Card == `OP_4}  & Zeros[3]) |
        ({Card == `OP_5}  & Zeros[4]) |
        ({Card == `OP_6}  & Zeros[5]) |
        ({Card == `OP_7}  & Zeros[6]) |
        ({Card == `OP_8}  & Zeros[7]) |
        ({Card == `OP_9}  & Zeros[8]) |
        ({Card == `OP_10} & Zeros[9]) |
        ({Card == `OP_11} & Zeros[10]) |
        ({Card == `OP_12} & Zeros[11]) |
        ({Card == `OP_13} & Zeros[12]) |
        ({Card == `OP_14} & Zeros[13]) |
        ({Card == `OP_15} & Zeros[14]) |
        ({Card == `OP_16} & Zeros[15]);
        
endmodule