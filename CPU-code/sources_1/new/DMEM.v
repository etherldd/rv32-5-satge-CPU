`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 2023/09/06 17:21:09
// Design Name: 
// Module Name: DMEM
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


module DMEM(
    input clk,
    input [15:0] ram_addr,
    input [31:0] ram_wdata,
    input ram_wen,
    output [31:0] ram_rdata
    );
    wire [15:0] real_addr = ram_addr >> 2;
    //DRAM, dmem_pip1, dmem_pip23
    dmem_pip1 dram(
    .clka (clk ),
    .wea (ram_wen ),
    .addra(real_addr ),
    .dina (ram_wdata ),
    .douta(ram_rdata )
    );
endmodule
