`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 2023/08/30 16:22:09
// Design Name: 
// Module Name: test_alu_4sub
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

module test_alu_4sub;
    reg [31:0] A ;
    reg [31:0] B ;
    reg [31:0] R1 [1:0];
    reg [31:0] R2 [1:0];
    reg Cin ;
    reg [4 :0] Card[3:0];
    wire [31:0] F[3:0] ;
    wire Cout [3:0];
    wire Zero [3:0];

    reg clk = 0;
    reg [31:0] timer = 32'b0; 
    always #10 begin
        clk <= ~clk;
        timer <= timer + 1;
    end
    initial begin 
        // A = 32'b     10111;
        // B = 32'b1100111111;
        //sum : 1101010110: 2+4+16+64+256+512=86+768=854 
        R1[0] <= $random;
        R1[1] <= $random;
        R2[0] <= $random | 32'h80000000;
        R2[1] <= $random | 32'h80000000;
        A <= {32{(timer % 32'b100 == 32'b0) || (timer % 32'b100 == 32'b1)}} & R1[0] |
             {32{(timer % 32'b100 == 32'b10) || (timer % 32'b100 == 32'b11)}} & R2[0] ;
        B <= {32{(timer % 32'b100 == 32'b0)}}  & R1[1] |
             {32{(timer % 32'b100 == 32'b10)}} & R2[0] |
             {32{(timer % 32'b100 == 32'b10)}} & R1[0] |
             {32{(timer % 32'b100 == 32'b10)}} & R2[1] ;
        //sub : 1
        Cin = 1;
        Card[0] = `OP_3;
        Card[1] = `OP_4;
        Card[2] = `OP_5;
        Card[3] = `OP_6;
    end

    always @(posedge clk) begin
        R1[0] <= $random;
        R1[1] <= $random;
        R2[0] <= $random | 32'h80000000;
        R2[1] <= $random | 32'h80000000;
        A <= {32{(timer % 32'b100 == 32'b0) || (timer % 32'b100 == 32'b1)}} & R1[0] |
             {32{(timer % 32'b100 == 32'b10) || (timer % 32'b100 == 32'b11)}} & R2[0] ;
        B <= {32{(timer % 32'b100 == 32'b0)}}  & R1[1] |
             {32{(timer % 32'b100 == 32'b10)}} & R2[0] |
             {32{(timer % 32'b100 == 32'b10)}} & R1[0] |
             {32{(timer % 32'b100 == 32'b10)}} & R2[1] ;
    end

    wire test_4sub [3:0];

    ALU alu1( .A(A) ,
    .B(B) ,
    .Cin(Cin) ,
    .Card(Card[0]),
    .F(F[0]) ,
    .Cout(Cout[0]),
    .Zero(Zero[0]));
    assign test_4sub[0] = A - B - F[0];

    ALU alu2( .A(A) ,
    .B(B) ,
    .Cin(Cin) ,
    .Card(Card[1]),
    .F(F[1]) ,
    .Cout(Cout[1]),
    .Zero(Zero[1]));
    assign test_4sub[1] = A - B -Cin - F[1];

    ALU alu3( .A(A) ,
    .B(B) ,
    .Cin(Cin) ,
    .Card(Card[2]),
    .F(F[2]) ,
    .Cout(Cout[2]),
    .Zero(Zero[2]));
    assign test_4sub[2] = B - A - F[2];

    ALU alu4( .A(A) ,
    .B(B) ,
    .Cin(Cin) ,
    .Card(Card[3]),
    .F(F[3]) ,
    .Cout(Cout[3]),
    .Zero(Zero[3]));
    assign test_4sub[3] = B - A - Cin - F[3];

endmodule
