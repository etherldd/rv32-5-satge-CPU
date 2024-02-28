`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 2023/09/06 17:17:56
// Design Name: 
// Module Name: IMEM
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


module IMEM(
    input clk ,
    input [15:0] ram_addr ,
    input [31:0] ram_wdata,
    input ram_wen ,
    output [31:0] ram_rdata
    );
    wire [15:0] real_addr = ram_addr >> 2;
    //imem_pip1, imem_pip2, imem_pip3, IRAM
    imem_pip1 iram(
    .clka (clk ),
    .wea (ram_wen ),
    .addra(real_addr ),
    .dina (ram_wdata ),
    .douta(ram_rdata )
    );
endmodule
