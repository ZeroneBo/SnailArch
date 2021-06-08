module ALU (
    input wire [7:0] A,
    input wire [7:0] B,
    input wire [3:0] op, // 功能码
    output wire [7:0] E,
    output wire [1:0] cc
);

    assign E = (op == 4'h0)? A + B:
               (op == 4'h1)? A - B: 8'hxx;
    assign cc = {A == B, A > B}; // ==10, <00, >01

endmodule