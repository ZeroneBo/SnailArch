`include "SNAIL.h"

// [ins fun][ra rb][rc]
`define ins rom_data[23:20]
`define fun rom_data[19:16]
`define rA rom_data[14:12]
`define rB rom_data[10:8]
`define rC rom_data[6:4]

module SNAIL (
    output wire [7:0] ram_addr,
    output wire [7:0] ram_wdat,
    input wire [7:0] ram_rdat,
    output wire ram_rd_, ram_wr_,

    output wire [7:0] rom_addr,
    input wire [23:0] rom_data,

    input wire clk, rst_
);

    wire [7:0] valA, valB, aluB, valC, valE, valM, valP;
    wire [1:0] cc;
    wire [2:0] dstM, dstE;
    wire [7:0] new_PC;

    PC pc(
        .new_PC(new_PC),
        .PC(rom_addr),
        .clk(clk),
        .rst_(rst_)
    );

    REGFILE regfile(
        .srcA(`rA),
        .srcB(`rB),
        .A(valA),
        .B(valB),
        .dstM(dstM),
        .dstE(dstE),
        .M(valM),
        .E(valE),
        .clk(clk)
    );

    ALU alu(
        .A(valA),
        .B(aluB),
        .op(`fun), // 功能码
        .E(valE),
        .cc(cc)
    );

    assign valC = (`ins == `JXX && `fun == `JMP)? rom_data[15:8]: rom_data[7:0];
    assign valP = rom_addr + (
        (`ins == `HLT)? 0: // 不再向下读指令
        (`ins == `NOP)? 1: // NOP指令占1B
        (`ins == `JXX && `fun == `JMP)? 2:3); // JMP指令跳到操作数处, 其他指令加3B
    assign aluB = (
        (`ins == `LD) ||
        (`ins == `ST) ||
        (`ins == `OPI))? valC: valB;
    
    // 访存
    assign ram_addr = valE;
    assign ram_wdat = valB;
    assign ram_rd_ = (`ins == `LD)? 1'b0: 1'b1;
    assign ram_wr_ = (`ins == `ST)? 1'b0: 1'b1;

    assign valM = ram_rdat;
    assign dstM = (`ins == `LD)? `rB: 3'o0; // 3'0: r0寄存器
    assign dstE = (`ins == `OPR)? `rC:
        (`ins == `OPI)? `rB: 3'o0;

    assign new_PC = (`ins == `JXX && (
        `fun == `JMP ||
        `fun == `BEQ && cc[1:1] ||
        `fun == `BNE && ~cc[1:1] ||
        `fun == `BLT && ~cc[1:1] && ~cc[0:0] ||
        `fun == `BGT && cc[0:0]))? valC: valP;
endmodule