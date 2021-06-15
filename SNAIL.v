/*
 * v1.0 + ing
 * 
 *
 */
`include "SNAIL.h"

// [ins fun][ra rb][rc]
`define ins rom_data[23:20]
`define fun rom_data[19:16]
// `define rA rom_data[14:12]
// `define rB rom_data[10:8]
// `define rC rom_data[6:4]

module SNAIL (
    output wire [7:0] ram_addr,
    output wire [7:0] ram_wdat,
    input wire [7:0] ram_rdat,
    output wire ram_rd_, ram_wr_,

    output wire [7:0] rom_addr,
    input wire [23:0] rom_data,

    input wire clk, rst_
);

    wire [7:0] valA, aluA, valB, aluB, valC, valE, valM, valP;
    wire [1:0] cc;
    wire [2:0] rA, rB, rC, dstM, dstE;
    wire [7:0] new_PC;

    PC pc(
        .new_PC(new_PC),
        .PC(rom_addr),
        .clk(clk),
        .rst_(rst_)
    );

    REGFILE regfile(
        .srcA(rA),
        .srcB(rB),
        .A(valA),
        .B(valB),
        .dstM(dstM),
        .dstE(dstE),
        .M(valM),
        .E(valE),
        .clk(clk)
    ); // r7为堆栈指针寄存器

    ALU alu(
        .A(aluA),
        .B(aluB),
        .op(`fun), // 功能码
        .E(valE),
        .cc(cc)
    );

    assign rA = (`ins == `RET)? `r7: rom_data[14:12];
    assign rB = (`ins == `RET || `ins == `CALL ||
        `ins == `PUSH || `ins == `POP)? `r7: rom_data[10:8];
    assign rC = rom_data[6:4];
    assign valC = (
        `ins == `JXX && `fun == `JMP || `ins == `CALL)? rom_data[15:8]: rom_data[7:0];
    assign valP = rom_addr + (
        (`ins == `HLT)? 0: // 不再向下读指令
        (`ins == `NOP || `ins == `RET)? 1: // NOP、RET占1B
        // 其他指令加3B
        (`ins == `JXX && `fun == `JMP ||
        `ins == `PUSH || `ins == `POP || `ins == `CALL)? 2:3);
    assign aluA = (`ins == `CALL || `ins == `PUSH)? -1:
        (`ins == `RET || `ins == `POP)?1: valA;
    assign aluB = (
        (`ins == `LD) ||
        (`ins == `ST) ||
        (`ins == `OPI))? valC: valB;
    
    // 访存
    assign ram_addr = (`ins == `RET)? valA:
        (`ins == `POP)? valB: valE;
    assign ram_wdat = (`ins == `PUSH)? valA:
        (`ins == `CALL)? valP: valB;
    assign ram_rd_ = (`ins == `LD || `ins == `RET || `ins == `POP)? 1'b0: 1'b1;
    assign ram_wr_ = (`ins == `ST || `ins == `PUSH || `ins == `CALL)? 1'b0: 1'b1;
    // 写回
    assign valM = ram_rdat;
    assign dstM = (`ins == `POP)? rA:
        (`ins == `LD)? rB: 3'o0; // 3'0: r0寄存器
    assign dstE = 
        (`ins == `CALL || `ins == `RET || `ins == `PUSH || `ins == `POP)? `r7:
        (`ins == `OPR)? rC:
        (`ins == `OPI)? rB: 3'o0;

    assign new_PC = 
    (( // 跳转指令
        `ins == `JXX && (
        `fun == `JMP ||
        `fun == `BEQ && cc[1:1] ||
        `fun == `BNE && ~cc[1:1] ||
        `fun == `BLT && ~cc[1:1] && ~cc[0:0] ||
        `fun == `BGT && cc[0:0])
    ) || `ins == `CALL)? valC:
    (`ins == `RET)? valM: valP;
endmodule