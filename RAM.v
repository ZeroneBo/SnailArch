module RAM (
    input wire [7:0] addr, // 输入 地址
    input wire [7:0] in,  // 输入 数据
    output wire [7:0] out, // 输出 数据
    input wire rd_, // 读使能
    input wire wr_, // 写使能
    input wire clk // 时钟
);

    reg [7:0] mem[0:255]; // 数组, 256个8位单元

// 连续赋值, 读电路是逻辑组合电路
    assign out = (rd_ == 1'b0)? mem[addr]: 8'hxx;

// mem 是寄存器变量, 只能在 always 中赋值
    always @(posedge clk) begin
        if (wr_ == 1'b0) begin
            mem[addr] <= in;
        end
    end
    
endmodule