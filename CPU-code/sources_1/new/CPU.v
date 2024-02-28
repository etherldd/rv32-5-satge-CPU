`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 2023/09/05 20:43:07
// Design Name: 
// Module Name: CPU
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

module CPU(
        input clk,
        input resetn,
        // debug signals
        output [31:0] debug_wb_pc ,     // 当 前 正 在 执 行 指 令 的PC
        output        debug_wb_rf_wen , // 当 前 通 用 寄 存 器 组 的 写 使 能 信 号
        output [4 :0] debug_wb_rf_addr, // 当 前 通 用 寄 存 器 组 写 回 的 寄 存 器 编 号
        output [31:0] debug_wb_rf_wdata // 当 前 指 令 需 要 写 回 的 数 据);
        );

    //clks
        wire clk_pc   = clk;  //5
        wire clk_imem = clk;  //1
        wire clk_reg  = clk;  //2, 5
        wire clk_dmem = clk;  //4

    //CU
        //Part for Reg
        wire [31:0] inst_if;
        // wire is_rs1_wb_change;
        // wire is_rs2_wb_change;
        //Part for EX
        wire [31:0] inst_ex;
        wire [2:0] Immsel;
        wire Asel;
        wire Bsel;
        wire [4:0] ALUsel;
        //bypassing
        wire is_Asel_change;
        wire Asel_changeto;
        wire is_Bsel_change;
        wire Bsel_changeto;

        //Part for MA
        wire [31:0] inst_ma;
        wire branch_lt_ma;
        wire branch_rs2_eq_0_ma;
        wire MemWe;
        wire [1:0] WBsel;


        //Part for WB
        wire [31:0] inst_wb;
        wire branch_neq_wb;
        wire branch_lt_wb;
        wire branch_rs2_eq_0_wb;
        wire PCsel;
        wire RegWe;

        //Part for data harzard
        wire is_lw;

        Control CU(
            //Part for Reg
            // .inst_if(inst_if), 
            // .is_rs1_wb_change(is_rs1_wb_change),
            // .is_rs2_wb_change(is_rs2_wb_change),
            //Part for EX
            .inst_ex(inst_ex),
            .Immsel(Immsel),
            .Asel(Asel),
            .Bsel(Bsel),
            .ALUsel(ALUsel),
            .is_Asel_change(is_Asel_change),
            .Asel_changeto(Asel_changeto),
            .is_Bsel_change(is_Bsel_change),
            .Bsel_changeto(Bsel_changeto),

            //Part for MA
            .inst_ma(inst_ma),
            .branch_lt_ma(branch_lt_ma),
            .branch_rs2_eq_0_ma(branch_rs2_eq_0_ma),
            .MemWe(MemWe),
            .WBsel(WBsel),

            //Part for WB
            .inst_wb(inst_wb),
            .branch_neq_wb(branch_neq_wb),
            .branch_lt_wb(branch_lt_wb),
            .branch_rs2_eq_0_wb(branch_rs2_eq_0_wb),
            .PCsel(PCsel),
            .RegWe(RegWe),

            //Part for data harzard
            .is_lw(is_lw)
        );

    //pc
        wire [31:0] pc_before;
        wire [31:0] pc_if; 
        wire [31:0] pc_plus_4;
        wire [31:0] pc_sub_4;
        assign pc_plus_4 = pc_if + 4;
        assign pc_sub_4  = pc_if - 4;
        PC pc(.clk(clk_pc), .resetn(resetn), .is_stay(is_lw), .wdata(pc_before), .pc(pc_if));


    //wire [31:0] inst_if; before
    wire [31:0] inst_reg;
    wire [31:0] pc_reg;
    //IF_DC
        IF_DC if_dc(
            .clk(clk),
            .resetn(resetn),
            .is_stay(is_lw),
            .new_inst(inst_if),
            .new_pc(pc_sub_4),  //for satge1 
            .cur_inst(inst_reg),
            .cur_pc(pc_reg)
        );

    //IMEM
        IMEM IMEM_(.clk(clk_imem), .ram_addr(pc_if), .ram_wen(0), .ram_rdata(inst_if));
        wire [4:0] rs1 = inst_reg[25:21];
        wire [4:0] rs2 = inst_reg[20:16];
        wire [4:0] rd  = inst_wb[15:11]; // to change!!!

    //RegFile
    
        wire [31:0] rs1_data;
        wire [31:0] rs2_data;
        wire [31:0] wdata;      // to change!!!

        RegFile regfile(.clk(clk_reg)  , .resetn(resetn)  , .raddr1(rs1), .raddr2(rs2),
                        .is_stay(is_lw),
                        .WE(RegWe), .rdata1(rs1_data), .rdata2(rs2_data), .waddr(rd), .wdata(wdata));  

    // wire [31:0] inst_ex before
    wire [31:0] pc_ex;
    wire [31:0] rs1_data_ex;
    wire [31:0] rs2_data_ex;

    //for solve bug lwlwadd
    // assign A_in_real = is_Asel_change ? (Asel_changeto == 0? alu_out_ma : wdata) : A_in;
    // assign B_in_real = is_Bsel_change ? (Bsel_changeto == 0? alu_out_ma : wdata) : B_in;
    wire is_rs1_change = is_Asel_change && Asel_changeto;
    wire [31:0] new_rs1_value = wdata;
    wire is_rs2_change = is_Bsel_change && Bsel_changeto;
    wire [31:0] new_rs2_value = wdata;
    
    wire [31:0] alu_out_ma; //at EX_MA out

    // wire [31:0] rs1_data_real = is_rs1_wb_change ? wdata : rs1_data;
    // wire [31:0] rs2_data_real = is_rs1_wb_change ? wdata : rs2_data;
    //DC_EX
        DC_EX dc_ex(
            .clk(clk),
            .resetn(resetn),
            .is_rs1_change(is_rs1_change),
            .new_rs1_value(new_rs1_value),
            .is_rs2_change(is_rs2_change),
            .new_rs2_value(new_rs2_value),
            .is_stay(is_lw),
            .new_inst(inst_reg),
            .new_pc(pc_reg),
            .new_rs1_data(rs1_data),
            .new_rs2_data(rs2_data),
            .cur_inst(inst_ex),
            .cur_pc(pc_ex),
            .cur_rs1_data(rs1_data_ex),
            .cur_rs2_data(rs2_data_ex)  
        );

    wire branch_neq_gene;
    wire branch_rs2_eq_0_gene;
    wire branch_lt_gene;

    wire [31:0] rs1_data_ex_real;
    wire [31:0] rs2_data_ex_real;
    //Branch_compare
    branch_comparator comparator(.A(rs1_data_ex_real), .B(rs2_data_ex_real), .neq(branch_neq_gene), .B_is_zero(branch_rs2_eq_0_gene) ,.lt(branch_lt_gene));

    //imm_generator
    wire [31:0] gene_imm;
    imm imm_generator(.inst(inst_ex), .imm_sel(Immsel), .gene_imm(gene_imm));

    //ALU
    wire [31:0] A_in;
    wire [31:0] B_in;
    wire [31:0] alu_out;


    // assign A_in_real = is_Asel_change ? (Asel_changeto == 0? alu_out_ma : wdata) : A_in;
    // assign B_in_real = is_Bsel_change ? (Bsel_changeto == 0? alu_out_ma : wdata) : B_in;
    // wire [31:0] rs1_data_ex_real;
    // wire [31:0] rs2_data_ex_real; before
    assign rs1_data_ex_real = is_Asel_change ? (Asel_changeto == 0? alu_out_ma : wdata) : rs1_data_ex; 
    assign rs2_data_ex_real = is_Bsel_change ? (Bsel_changeto == 0? alu_out_ma : wdata) : rs2_data_ex; 


    assign A_in = Asel ? pc_ex : rs1_data_ex_real;
    assign B_in = Bsel ? gene_imm : rs2_data_ex_real;
    // before : 146 wire [31:0] alu_out_ma; //at EX_MA out
        
    
    ALU alu(
        .A(A_in) ,
        .B(B_in) ,
        .Cin(0) ,
        .Card(ALUsel) ,
        .F(alu_out)
    );

    //wire [31:0] inst_ma before
    // wire [31:0] alu_out_ma; before
    wire [31:0] pc_ma;
    wire [31:0] rs2_data_ma;
    wire branch_neq_ma;
    // wire branch_rs2_eq_0_ma; before
    // wire branch_lt_ma; before

    //EX_MA
    EX_MA ex_ma(
        .clk(clk),
        .resetn(resetn),
        .is_insert_nop(is_lw),
        .new_inst(inst_ex),
        .new_pc(pc_ex),
        .new_rs2_data(rs2_data_ex_real),
        .new_alu_out(alu_out),
        .new_branch_neq_ex(branch_neq_gene),
        .new_branch_lt_ex(branch_lt_gene),
        .new_branch_rs2_eq_0_ex(branch_rs2_eq_0_gene),
        .cur_inst(inst_ma),
        .cur_pc(pc_ma),
        .cur_alu_out(alu_out_ma),
        .cur_rs2_data(rs2_data_ma),
        .cur_branch_neq_ma(branch_neq_ma),
        .cur_branch_lt_ma(branch_lt_ma),
        .cur_branch_rs2_eq_0_ma(branch_rs2_eq_0_ma)   
    );

    //pc select
    //!!!!!!!!!!!!!!!!!!!!!!!!!!to be modified
    //assign pc_before = PCsel ? alu_out : pc_plus_4;
    assign pc_before = pc_plus_4;

    //DMEM
    
    wire [31:0] dmem_rdata;
    DMEM DMEM_(.clk(clk_dmem), .ram_addr(alu_out_ma), .ram_wdata(rs2_data_ma), .ram_wen(MemWe), .ram_rdata(dmem_rdata));

    //Writing Back
    wire [31:0] wb_data =  WBsel == 2'b01 ? dmem_rdata : alu_out_ma;
                        //    WBsel == 2'b01 ? dmem_rdata :
                        //    WBsel == 2'b10 ? 32'b1 :
                        //    0;

    //MA_WB
    //before:
    // wire [31:0] inst_wb;
    // wire branch_neq_wb;
    // wire branch_lt_wb;
    // wire branch_rs2_eq_0_wb;
    wire [31:0] pc_wb;
    MA_WB ma_wb(
        .clk(clk),
        .resetn(resetn),
        .new_inst(inst_ma),
        .new_pc(pc_ma),
        .new_wbdata(wb_data),
        .new_branch_neq_ma(branch_neq_ma),
        .new_branch_lt_ma(branch_lt_ma),
        .new_branch_rs2_eq_0_ma(branch_rs2_eq_0_ma),
        .cur_inst(inst_wb),
        .cur_pc(pc_wb),
        .cur_wbdata(wdata),
        .cur_branch_neq_wb(branch_neq_wb),
        .cur_branch_lt_wb(branch_lt_wb),
        .cur_branch_rs2_eq_0_wb(branch_rs2_eq_0_wb)
    );
//+ 32'b100
    assign debug_wb_pc = pc_wb + 32'b100;
    assign debug_wb_rf_wen = RegWe;
    assign debug_wb_rf_addr = rd;
    assign debug_wb_rf_wdata = wdata;


endmodule
