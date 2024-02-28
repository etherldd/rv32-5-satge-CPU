//////////////////////////////////////////////////////////////////////////////////
`timescale 1ns / 1ps
// Company: 
// Engineer: 
// 
// Create Date: 2023/09/05 16:35:44
// Design Name: 
// Module Name: Control
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

//alu_select
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

module Control(
    //Part for Reg
      // input [31:0] inst_if, 
      // output is_rs1_wb_change,
      // output is_rs2_wb_change,
    //Part for EX
      input [31:0] inst_ex,
      output [2:0] Immsel,
      output Asel,
      output is_Asel_change,
      output Asel_changeto,
      output Bsel,
      output is_Bsel_change,
      output Bsel_changeto,
      output [4:0] ALUsel,

    //Part for MA
      input [31:0] inst_ma,
      input branch_lt_ma,
      input branch_rs2_eq_0_ma,
      output MemWe,
      output [1:0] WBsel,

    //Part for WB
      input [31:0] inst_wb,
      input branch_neq_wb,
      input branch_lt_wb, // no use, but if blt added, use it
      input branch_rs2_eq_0_wb,
      output PCsel,
      output RegWe,

    //Part for data harzard
      output is_lw
    );
    //Part for EX
      assign Immsel = ((inst_ex[31:26] == 6'b000000) && (inst_ex[5:0] == 6'b000000))?  3'b000 : 
                      (inst_ex[31:26] == 6'b101011) ?                                 3'b001 : 
                      (inst_ex[31:26] == 6'b100011) ?                                 3'b010 : 
                      (inst_ex[31:26] == 6'b000101) ?                                 3'b011 : 3'b100;
      assign Asel = ((inst_ex[31:26] == 6'b000101)||(inst_ex[31:26] == 6'b000010)) ? 1 : 0;
      assign Bsel = ( 
                      ((inst_ex[31:26] == 6'b000000) && (inst_ex[5:0] == 6'b000000)) ||
                      (inst_ex[31:26] == 6'b101011) ||
                      (inst_ex[31:26] == 6'b100011) ||
                      (inst_ex[31:26] == 6'b000101) ||
                      (inst_ex[31:26] == 6'b000010)
                    ) ? 1 : 0;
      //bypassing
      // wire [4:0] rs1_if = inst_if[25:21];
      // wire [4:0] rs2_if = inst_if[20:16];
      wire [4:0] rs1_ex = inst_ex[25:21];
      wire [4:0] rs2_ex = inst_ex[20:16];
      wire [4:0] rd_ma = inst_ma[15:11];
      wire [4:0] rd_wb = inst_wb[15:11];
      wire RegWe_ma;
      assign RegWe_ma = (inst_ma[31:26] == 6'b000000 && !(inst_ma[10:0] == 11'b00000001010 && !branch_rs2_eq_0_ma) && !(inst_ma == 32'b0)) ? 1 : 0;
      //assign RegWe_ma = RegWe;//debug2
      assign RegWe_wb = RegWe;

      assign is_Asel_change = ((rs1_ex == rd_ma && RegWe_ma) || (rs1_ex == rd_wb && RegWe_wb));
      assign Asel_changeto = (rs1_ex == rd_ma && RegWe_ma) ? 0 : 1;
      assign is_Bsel_change = ((rs2_ex == rd_ma && RegWe_ma) || (rs2_ex == rd_wb && RegWe_wb));
      assign Bsel_changeto = (rs2_ex == rd_ma && RegWe_ma) ? 0 : 1;

      // assign is_rs1_wb_change = (rs1_if == rd_wb && RegWe_wb);
      // assign is_rs2_wb_change = (rs2_if == rd_wb && RegWe_wb);


      assign ALUsel = (inst_ex[31:26] == 6'b000000) && inst_ex[10:0] == 11'b00000100010 ? `OP_3  : //for sub
                      (inst_ex[31:26] == 6'b000000) && inst_ex[10:0] == 11'b00000100100 ? `OP_12 : //for and
                      (inst_ex[31:26] == 6'b000000) && inst_ex[10:0] == 11'b00000100101 ? `OP_11 : //for or
                      (inst_ex[31:26] == 6'b000000) && inst_ex[10:0] == 11'b00000100110 ? `OP_13 : //for xor
                      (inst_ex[31:26] == 6'b000000) && inst_ex[10:0] == 11'b00000001010 ? `OP_7  : //for A
                      (inst_ex[31:26] == 6'b000000) && inst_ex[10:0] == 11'b00000101010 ? `OP_2  : //for slt
                      ((inst_ex[31:26] == 6'b000000)&& (inst_ex[5:0] == 6'b000000))     ? `OP_16 : //for sll
                      (inst_ex[31:26] == 6'b000010)                                     ? `OP_8  : //for J
                      `OP_1;                                                                 //others : add 
    //Part for MA
      assign MemWe = inst_ma[31:26] == 6'b101011;
      assign WBsel = inst_ma[31:26] == 6'b100011 ? 2'b01 :
                    (inst_ma[31:26] == 6'b000000) && inst_ma[10:0] == 11'b00000101010 && branch_lt_ma  ? 2'b10 :
                    (inst_ma[31:26] == 6'b000000) && inst_ma[10:0] == 11'b00000101010 && !branch_lt_ma ? 2'b11 :
                    2'b00;
    //Part for WB
      assign PCsel = ((inst_wb[31:26] == 6'b000101 && branch_neq_wb) || (inst_wb[31:26] == 6'b000010)) ? 1 : 0;
      assign RegWe = ((inst_wb[31:26] == 6'b000000 && !(inst_wb[10:0] == 11'b00000001010 && !branch_rs2_eq_0_wb) && !(inst_wb == 32'b0)) || (inst_wb[31:26] == 6'b100011)) ? 1 : 0;
    
      assign is_lw = (inst_ma[31:26] == 6'b100011) && (rd_ma == rs1_ex || rd_ma == rs2_ex);
endmodule
