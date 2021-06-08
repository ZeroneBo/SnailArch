// 指令高4位 类型码
`define LD 4'h1
`define ST 4'h2
`define OPR 4'h3 // 寄存器操作 + funcode => ADD SUB
`define OPI 4'h4 // 立即数操作
`define JXX 4'h5 // + funcode => BE BNE BGT BLT JMP
`define HLT 4'hF
`define NOP 4'h0

// 指令低4位 功能码 funcode
// OP
`define ADD 4'h0
`define SUB 4'h1
// JXX
`define JMP 4'h0
`define BEQ 4'h1
`define BNE 4'h2
`define BLT 4'h3
`define BGT 4'h4