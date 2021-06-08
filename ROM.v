// 组合逻辑电路, 只读指令, 不写入
module ROM (
    input wire [7:0] addr, // 输入 地址
    output wire [23:0] out // 输出 读出的指令, 指令最长占 3B
);

    reg [7:0] mem[0:255];
    
    assign out = {mem[addr], mem[addr+1], mem[addr+2]}; // 读连续的 3B

    // initial begin
    //     $readmemh("ROM.txt", mem, 0, 255); // 从文件中读入提前写好的程序
    // end

endmodule