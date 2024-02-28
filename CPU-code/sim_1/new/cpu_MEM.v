`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 2023/09/06 19:33:58
// Design Name: 
// Module Name: cpu_MEM
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


module cpu_MEM(

    );
    reg [31:0] pc_wire = 32'b1000;
    reg clk = 0;
    always #5 clk = ~clk;
    wire [31:0] imem_rdata;
    IMEM IMEM_(.clk(clk), .ram_addr(pc_wire), .ram_wen(0), .ram_rdata(imem_rdata));
    wire [4:0] rs1 = imem_rdata[25:21];
    wire [4:0] rs2 = imem_rdata[20:16];
    wire [4:0] rd  = imem_rdata[15:11];
endmodule
