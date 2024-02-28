`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 2023/09/01 18:31:27
// Design Name: 
// Module Name: test_ramAndRegfile
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



module test_ramAndRegfile;
    reg clk = 0;
    //RAM
    reg [15:0] ram_addr = 16'b1;
    reg [31:0] ram_wdata = 32'b111;
    reg ram_wen = 0;
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
    reg [4:0] raddr2 = 5'b0;
    wire [31:0] rdata1;
    wire [31:0] rdata2;
    reg WE = 1;
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

    reg [31:0] timer = 32'b0;

    always #10 begin
        clk <= ~clk; 
    end

    always @(posedge clk) begin 
        //radd1 is always 0
        if (timer % 4 == 0) begin
            #2
            raddr2 = raddr2 + 1;
            WE <= ~WE;
            timer = timer + 1;
        end 
        else if (timer % 4 == 1) begin
            #2
            ram_wdata <= rdata2 + 1;
            waddr <= waddr + 1;
            timer <= timer + 1;
            ram_wen <= ~ram_wen;
        end
        else if (timer % 4 == 2) begin
            #2
            ram_wen <= ~ram_wen;
            timer = timer + 1;
        end 
        else begin
            #2
            wdata <= ram_rdata + 1;
            ram_addr <= ram_addr + 1;
            timer <= timer + 1;
            WE <= ~WE;
        end
    end
    
endmodule
