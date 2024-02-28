`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 2023/09/04 14:01:44
// Design Name: 
// Module Name: test_regram_par
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

//0x100 <- 200 : read 200 : write reg : read reg

module test_regram_par;
    reg clk = 0;
    //RAM
    reg [15:0] ram_addr = 16'b100;
    reg [31:0] ram_wdata = 32'hc8;
    reg ram_wen = 1;
    wire [31:0] ram_rdata;
    ram_top ram(
    .clk(clk) ,
    .ram_addr(ram_addr) ,
    .ram_wdata(ram_wdata),
    .ram_wen(ram_wen) ,
    .ram_rdata(ram_rdata)
    );

    //RegFile
    reg [4:0] raddr1 = 5'b0;
    reg [4:0] raddr2 = 5'b1;
    wire [31:0] rdata1;
    wire [31:0] rdata2;
    reg WE = 0;
    reg [4:0] waddr = 5'b1;
    reg [31:0] wdata = 32'b111;
    RegFile regfile(
        .clk(clk),
        .raddr1(raddr1),
        .raddr2(raddr2),
        .rdata1(rdata1),
        .rdata2(rdata2),
        .WE(WE),
        .waddr(waddr),
        .wdata(wdata)
    );
    initial begin
        #2 clk = ~clk;
        #5 ram_wen = 0;
        clk = ~clk;

        #10 clk = ~clk;
        #15 WE = 1;
        clk = ~clk;
        wdata = ram_rdata;

        #15 clk = ~clk;
        #20 clk = ~clk;
        WE = 0;

        #25 clk = ~clk;
    end
endmodule
