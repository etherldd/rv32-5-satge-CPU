`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 2023/09/05 15:25:08
// Design Name: 
// Module Name: imm
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

`define Imm_1     3'b000
`define Imm_2     3'b001
`define Imm_3     3'b010
`define Imm_4     3'b011
`define Imm_5     3'b100

//        Imm_1 : sll[6:10] : 5
//        Imm_2 : sw[15:0]  : 16
//        Imm_3 : lw[20:16][10:0]
//        Imm_4 : bne[15:0] << 2
//        Imm_5 : j[25:0] << 2

module imm(
    input wire [31:0] inst,
    input wire [2:0]  imm_sel,
    output wire [31:0] gene_imm
    );
    wire [31:0] imm5 [4:0];
    assign imm5[0] = {{27{1'b0}}, inst[10:6]};
    assign imm5[1] = inst[15]? {{16{1'b1}}, inst[15:0]} : {{16{1'b0}}, inst[15:0]};
    assign imm5[2] = inst[20]? {{16{1'b1}}, inst[20:16], inst[10:0]} : {{16{1'b0}}, inst[20:16], inst[10:0]};
    assign imm5[3] = inst[15]? {{14{1'b1}}, inst[15:0], {2{1'b0}}} : {{14{1'b0}}, inst[15:0], {2{1'b0}}};
    assign imm5[4] = inst[25]? {{4{1'b1}},  inst[25:0], {2{1'b0}}} : {{4{1'b0}},  inst[25:0], {2{1'b0}}};
    assign gene_imm = imm5[imm_sel % 3'b101];
endmodule
