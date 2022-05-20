`timescale 1 ns / 100 ps

`include "sr_cpu.vh"

module nexys_tb;

    reg         clk;
    reg         rst_n;
    wire CA;
    wire CB;
    wire CC;
    wire CD;
    wire CE;
    wire CF;
    wire CG;
    wire [7:0] AN;
    wire [15:0] LED;
    wire [14:0] pc = LED[15:1];

    nexys4_ddr mut(
        .CLK100MHZ(clk),
        .BTNC(rst_n),
        .BTNU(1'b1),
        .SW(16'b0000100111100000),
        .CA(CA),
        .CB(CB),
        .CC(CC),
        .CD(CD),
        .CE(CE),
        .CF(CF),
        .CG(CG),
        .AN(AN),
        .LED(LED)
    );

    initial begin
        clk = 0;
        forever clk = #5 ~clk;
    end

    initial begin
        rst_n = 1;
        repeat (4)  @(posedge clk);
        rst_n = 0;
    end
endmodule