`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 2023/08/30 16:23:01
// Design Name: 
// Module Name: test_alu_10other
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

module test_alu_10other;
    reg [31:0] A ;
    reg [31:0] B ;
    reg [31:0] R1 [1:0];
    reg [31:0] R2 [1:0];
    reg Cin ;
    reg [4 :0] Card[9:0];
    wire [31:0] F[9:0] ;
    wire Cout [9:0];
    wire Zero [9:0];
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
        B <= {{32{(timer % 32'b100 == 32'b0)}}  & R1[1] |
             {32{(timer % 32'b100 == 32'b1)}} & R2[0] |
             {32{(timer % 32'b100 == 32'b10)}} & R1[0] |
             {32{(timer % 32'b100 == 32'b11)}} & R2[1]} >> 30 ;
        //sum : 10011
        Cin = 1;
        Card[0] = `OP_7;
        Card[1] = `OP_8;
        Card[2] = `OP_9;
        Card[3] = `OP_10;
        Card[4] = `OP_11;
        Card[5] = `OP_12;
        Card[6] = `OP_13;
        Card[7] = `OP_14;
        Card[8] = `OP_15;
        Card[9] = `OP_16;
    end

    always @(posedge clk) begin 
        R1[0] <= $random;
        R1[1] <= $random;
        R2[0] <= $random | 32'h80000000;
        R2[1] <= $random | 32'h80000000;
        A <= {32{(timer % 32'b100 == 32'b0) || (timer % 32'b100 == 32'b1)}} & R1[0] |
             {32{(timer % 32'b100 == 32'b10) || (timer % 32'b100 == 32'b11)}} & R2[0] ;
        B <= {{32{(timer % 32'b100 == 32'b0)}}  & R1[1] |
             {32{(timer % 32'b100 == 32'b1)}} & R2[0] |
             {32{(timer % 32'b100 == 32'b10)}} & R1[0] |
             {32{(timer % 32'b100 == 32'b11)}} & R2[1]} >> 30 ;
    end

    wire [31:0] res10 [9:0];

    ALU alu1( .A(A) ,
    .B(B) ,
    .Cin(Cin) ,
    .Card(Card[0]),
    .F(F[0]) ,
    .Cout(Cout[0]),
    .Zero(Zero[0]));
    assign res10[0] = A - F[0];

    ALU alu2( .A(A) ,
    .B(B) ,
    .Cin(Cin) ,
    .Card(Card[1]),
    .F(F[1]) ,
    .Cout(Cout[1]),
    .Zero(Zero[1]));
    assign res10[1] = B - F[1];


    ALU alu3( .A(A) ,
    .B(B) ,
    .Cin(Cin) ,
    .Card(Card[2]),
    .F(F[2]) ,
    .Cout(Cout[2]),
    .Zero(Zero[2]));
    assign res10[2] = ~A - F[2];


    ALU alu4( .A(A) ,
    .B(B) ,
    .Cin(Cin) ,
    .Card(Card[3]),
    .F(F[3]) ,
    .Cout(Cout[3]),
    .Zero(Zero[3]));
    assign res10[3] = ~B - F[3];


    ALU alu5( .A(A) ,
    .B(B) ,
    .Cin(Cin) ,
    .Card(Card[4]),
    .F(F[4]) ,
    .Cout(Cout[4]),
    .Zero(Zero[4]));
    assign res10[4] = (A | B) - F[4];


    ALU alu6( .A(A) ,
    .B(B) ,
    .Cin(Cin) ,
    .Card(Card[5]),
    .F(F[5]) ,
    .Cout(Cout[5]),
    .Zero(Zero[5]));
    assign res10[5] = A & B - F[5];


    ALU alu7( .A(A) ,
    .B(B) ,
    .Cin(Cin) ,
    .Card(Card[6]),
    .F(F[6]) ,
    .Cout(Cout[6]),
    .Zero(Zero[6]));
    assign res10[6] = (A ^ B) - F[6];


    ALU alu8( .A(A) ,
    .B(B) ,
    .Cin(Cin) ,
    .Card(Card[7]),
    .F(F[7]) ,
    .Cout(Cout[7]),
    .Zero(Zero[7]));
    assign res10[7] = ~(A ^ B) - F[7];


    ALU alu9( .A(A) ,
    .B(B) ,
    .Cin(Cin) ,
    .Card(Card[8]),
    .F(F[8]) ,
    .Cout(Cout[8]),
    .Zero(Zero[8]));
    assign res10[8] = ~(A & B) - F[8];


    ALU alu10( .A(A) ,
    .B(B) ,
    .Cin(Cin) ,
    .Card(Card[9]),
    .F(F[9]) ,
    .Cout(Cout[9]),
    .Zero(Zero[9]));
    assign res10[9] = F[9];

endmodule