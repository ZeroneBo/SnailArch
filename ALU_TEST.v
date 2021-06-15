`timescale 10ns/1ns

module ALU_TEST;
    wire [7:0] A, B;
    wire [3:0] op;
    wire [7:0] E;
    wire [1:0] cc;
    reg clk;
    reg [7:0] jcqa, jcqb;
    reg [3:0] jcqop;

// 实例化ALU
    ALU alu (
        .A(A), // .A代表模块端口, A代表实例
        .B(B),
        .op(op),
        .E(E),
        .cc(cc)
    );
    parameter CYCLE = 1.0;
    always #(CYCLE/2)clk <= ~clk;
    assign op = jcqop;
    assign A = jcqa;
    assign B = jcqb;

    initial begin
        clk = 1'b1;
        jcqa = 8'h03;
        jcqb = 8'h02;
        jcqop = 4'h0;
    #10
        $finish;
    end
    always @(posedge clk) begin
        $write("%3d ", A);
        $write("%3d ", B);
        $write("%3d ", op);
        $write("%3d \n", E);
        jcqb = jcqb + 1;
        jcqop = (jcqop + 1) % 4;
    end

    initial begin
        $dumpfile("ALU_TEST.vcd");
        $dumpvars(0, alu);
        $dumpvars(0, clk);
    end
    
endmodule