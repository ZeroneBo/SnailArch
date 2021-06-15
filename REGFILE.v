module REGFILE (
    input wire [2:0] srcA, // 指定A的源寄存器
    input wire [2:0] srcB, // 指定B的源寄存器
    output wire [7:0] A,
    output wire [7:0] B,
    input wire [2:0] dstM, // 指定M的目标寄存器
    input wire [2:0] dstE, // 指定E的目标寄存器
    input wire [7:0] M,
    input wire [7:0] E,
    input wire clk
);

    reg [7:0] rf [0:7];

    assign A = (srcA == 3'o0)? 8'h00: rf[srcA];
    assign B = (srcB == 3'o0)? 8'h00: rf[srcB];

    always @(posedge clk) begin
        if (dstM != 3'o0)
            rf[dstM] <= M;
        if (dstE != 3'o0 && dstE != dstM)
            rf[dstE] <= E;
    end
    
endmodule