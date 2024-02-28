`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 2023/09/01 18:19:17
// Design Name: 
// Module Name: test_ram
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


module test_ram;

    reg clk = 0;
    reg [15:0] ram_addr = 16'b1;
    reg [31:0] ram_wdata = 32'b111;
    reg ram_wen = 1;
    wire [31:0] ram_rdata;
    ram_top ram(
    .clk(clk) ,
    .ram_addr(ram_addr) ,
    .ram_wdata(ram_wdata),
    .ram_wen(ram_wen) ,
    .ram_rdata(ram_rdata)
    );

    reg [31:0] timer = 32'b0;
    always #10 begin
        clk <= ~clk; 
    end

    //write to r1 = 111

    always @(posedge clk) begin 
        //radd1 is always 0
        if (timer % 2 == 0) begin
            #2
            ram_wen <= ~ram_wen;
            timer = timer + 1;
        end 
        else begin
            #2
            ram_wdata <= ram_rdata + 1;
            ram_addr <= ram_addr + 1;
            ram_wen <= ~ram_wen;
            timer <= timer + 1;
        end
    end

endmodule
