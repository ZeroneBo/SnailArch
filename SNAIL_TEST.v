`timescale 10ns/1ns
`include "SNAIL.h"
`define ins rom_out[23:20]

module SNAIL_TEST;
    wire [7:0] ram_addr, ram_in, ram_out, rom_addr;
    wire [23:0] rom_out;
    wire rd_, wr_;
    reg clk, rst_;

    parameter CYCLE = 1.0;

    RAM ram(
        .addr(ram_addr),
        .in(ram_in),
        .out(ram_out),
        .rd_(rd_),
        .wr_(wr_),
        .clk(clk)
    );

    ROM rom(
        .addr(rom_addr),
        .out(rom_out)
    );

    SNAIL cpu(
        .ram_addr(ram_addr),
        .ram_wdat(ram_in),
        .ram_rdat(ram_out),
        .ram_rd_(rd_),
        .ram_wr_(wr_),
        .rom_addr(rom_addr),
        .rom_data(rom_out),
        .clk(clk),
        .rst_(rst_)
    );

    always #(CYCLE/2) clk <= ~clk;

    integer i;

    always @(negedge clk) begin
        if (rst_ && (`ins == `HLT)) #(CYCLE + 0.1) $finish;
        $write("%3d: ", $stime);
        // $write("d- %h %h %h\n", rom_out[24:16], rom_out[15:8], rom_out[7:0]);
        for (i = 0; i < 1; i = i + 1) begin
            if (ram.mem[i] !== 8'hxx)
                $write(" %c ", ram.mem[i]);
                // $write(" %d ", ram.mem[i]);
            else
                $write(" . ");
        end
        $write("\n");
    end

    initial begin
        $dumpfile("SNAIL_TEST.vcd");  // 指定波形文件
        $dumpvars;  // 默认所有变量
        $readmemh("RAM.txt", ram.mem, 0, 255);  // 读十六进制文件到变量
        $readmemh("ROM.txt", rom.mem, 0, 255);
        clk = 1'b1;
        rst_ = 1'b0;
        #(CYCLE + CYCLE / 2) rst_ = ~rst_;
    end

endmodule