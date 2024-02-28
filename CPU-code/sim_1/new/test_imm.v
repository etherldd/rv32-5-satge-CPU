`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 2023/09/16 11:52:16
// Design Name: 
// Module Name: test_imm
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


module test_imm(

    );
    //8C 00 10 08    LW   $2,  8($0)
    //00 01 48 80    SLL  $9,  $1,  0x2
    //AC 02 00 04    SW   $2,  4($0)
    //14 06 00 02    BNE  $0,  $6,  0x2
    //08 00 00 10    J    0x10
    reg [31:0] inst;
    wire [2:0] Immsel;
    wire [31:0] res;
    Control CU(
    .inst(inst),
    .Immsel(Immsel)
    );
    imm imm_(
    .inst(inst),
    .imm_sel(Immsel),
    .gene_imm(res)
    );
    initial begin
        inst = 32'h8C001008;
        #5
        inst = 32'h00014880;
        #5
        inst = 32'hAC020004;
        #5
        inst = 32'h14060002;
        #5
        inst = 32'h08000010;
    end
endmodule
