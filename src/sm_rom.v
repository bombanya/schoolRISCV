/*
 * schoolRISCV - small RISC-V CPU 
 *
 * originally based on Sarah L. Harris MIPS CPU 
 *                   & schoolMIPS project
 * 
 * Copyright(c) 2017-2020 Stanislav Zhelnio 
 *                        Aleksandr Romanov 
 */ 

module sm_rom
#(
    parameter SIZE = 64
)
(
    input clk,
    input wr,
    input rst,
    input [31:0] data_in,
    input  [31:0] a,
    output [31:0] rd,

    input  [31:0] dbg_a,
    output [31:0] dbg_rd
);
    integer i;
    reg [31:0] rom [SIZE - 1:0];
    assign rd = rom [a];

    assign dbg_rd = rom[dbg_a];

    always @(posedge clk) begin
        if (rst) begin
            for (i = 0; i < SIZE; i = i + 1) begin
                rom[i] <= 0;
            end
        end else if (wr) begin
            rom[a] <= data_in;
        end
    end
   

    initial begin
        $readmemh ("program.mem", rom);
    end

endmodule
