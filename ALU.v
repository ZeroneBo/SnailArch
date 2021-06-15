/*
 * v1.0 +
 * 增加了 and xor
 * 测试正确
*/
`include "SNAIL.h"

module ALU (
    input wire [7:0] A,
    input wire [7:0] B,
    input wire [3:0] op, // 功能码
    output wire [7:0] E,
    output wire [1:0] cc
);

    assign E = (op == `ADD)? A + B:
               (op == `SUB)? A - B:
               (op == `AND)? A & B:
               (op == `XOR)? A ^ B: 8'hxx;
    assign cc = {A == B, A > B}; // ==10, <00, >01

endmodule