`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 2023/08/31 14:05:13
// Design Name: 
// Module Name: RegFile
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


module RegFile(
    input clk,
    input resetn,
    input is_stay,
    input [4:0] raddr1,
    input [4:0] raddr2,
    output reg [31:0] rdata1,
    output reg [31:0] rdata2,
    input WE,
    input [4:0] waddr,
    input [31:0] wdata
    );
    //built 32 registers, x0 is always 0
    reg [31:0] regs [31:0];
    integer  i;
    initial begin
        for (i = 0; i < 32; i = i + 1) begin
            regs[i] <= 32'b0;
        end
    end
    always @(resetn) begin
        if (!resetn) begin
            for (i = 0; i < 32; i = i + 1) begin
                    regs[i] <= 32'b0;
            end
        end
    end

    // implement_0
    // always @(posedge clk && resetn) begin
    //     rdata1 <= regs[raddr1];
    //     rdata2 <= regs[raddr2];
    //     if (WE && waddr != 5'b0) begin
    //         regs[waddr] <= wdata; 
    //     end 
    // end


    // implement_1
    always @(posedge clk && resetn) begin
        if (resetn) begin  // debug1 : delete !is_stay
            if (WE && waddr == raddr1 && raddr1 == raddr2) begin
                rdata1 <= wdata;
                rdata2 <= wdata;
            end
            else if (WE && waddr == raddr1) begin
                rdata1 <= wdata;
                rdata2 <= regs[raddr2];
            end else if (WE && waddr == raddr2) begin
                rdata1 <= regs[raddr1];
                rdata2 <= wdata;
            end else begin
                rdata1 <= regs[raddr1];
                rdata2 <= regs[raddr2];
            end
            if (WE && waddr != 5'b0) begin
                regs[waddr] <= wdata; 
            end 
        end
    end


    //implement_2
    // always @(posedge clk && resetn) begin
    //     if (WE && waddr != 5'b0) begin
    //         regs[waddr] <= wdata; 
    //     end 
    // end
    // always @(negedge clk && resetn) begin
    //     rdata1 <= regs[raddr1];
    //     rdata2 <= regs[raddr2];
    // end
    
endmodule
