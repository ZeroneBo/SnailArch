/*
 * v1.0 +
 * 增加了指令
 * and xor push pop call ret
*/

// // v3.0 新指令集: 
// 增加了条件转移指令CMOV
// 把原指令集OPI、OPR细分为: irmov,rrmov,op
// 并重命名LD、ST
// NOP
// IRMOV
// RRMOV
// CMOV: 条件转移指令
// RMMOV: ST
// MRMOV: LD
// OP: OPR
// JXX
// PUSH
// POP
// CALL
// RET
// HLT
// OPfuncode: ADD SUB AND OR NOT XOR NXOR
// JXXfuncode: JMP JLT JLE JE JNE JGE JGT

// v2.0指令集: 指令高4位 类型码
`define NOP 4'h0
`define LD 4'h1 // ra + valc -> rb
`define ST 4'h2 // rb -> ra + valc
`define OPR 4'h3 // 寄存器操作 + funcode => ADD SUB
`define OPI 4'h4 // 立即数操作
`define JXX 4'h5 // + funcode => BE BNE BGT BLT JMP
`define PUSH 4'h6
`define POP 4'h7
`define CALL 4'h8
`define RET 4'h9
`define HLT 4'hF

// 指令低4位 功能码 funcode
// OP funcode
`define ADD 4'h0
`define SUB 4'h1
`define AND 4'h2
`define XOR 4'h3
// JXX funcode
`define JMP 4'h0
`define BEQ 4'h1
`define BNE 4'h2
`define BLT 4'h3
`define BGT 4'h4
// 添加寄存器名
`define r0 3'h0
`define r1 3'h1
`define r2 3'h2
`define r3 3'h3
`define r4 3'h4
`define r5 3'h5
`define r6 3'h6
`define r7 3'h7