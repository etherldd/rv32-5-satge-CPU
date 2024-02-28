`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 2023/08/31 14:24:01
// Design Name: 
// Module Name: test_regfile
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


module test_regfile;
    reg [4:0] raddr1 = 5'b1;
    reg [4:0] raddr2 = 5'b0;
    wire [31:0] rdata1;
    wire [31:0] rdata2;
    reg WE = 1;
    reg [4:0] waddr = 5'b1;
    reg [31:0] wdata = 32'b111;

    reg clk = 0;

    reg [31:0] timer = 32'b0;

    always #10 begin
        clk <= ~clk; 
    end

    //write to r1 = 111

    // always @(posedge clk) begin 
    //     //radd1 is always 0
    //     if (timer % 2 == 0) begin
    //         #2
    //         raddr2 = raddr2 + 1;
    //         WE <= ~WE;
    //         timer = timer + 1;
    //     end 
    //     else begin
    //         #2
    //         wdata <= rdata2 + 1;
    //         waddr <= waddr + 1;
    //         WE <= ~WE;
    //         timer <= timer + 1;
    //     end
    // end

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
    
    

endmodule
