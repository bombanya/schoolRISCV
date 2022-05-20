/*
 * schoolRISCV - small RISC-V CPU 
 *
 * originally based on Sarah L. Harris MIPS CPU 
 *                   & schoolMIPS project
 * 
 * Copyright(c) 2017-2020 Stanislav Zhelnio 
 *                        Aleksandr Romanov 
 */ 

//hardware top level module
module sm_top
(
    input           clkIn,
    input           rst_n,
    input   [ 3:0 ] clkDevide,
    input           clkEnable,
    output          clk,
    input   [ 4:0 ] regAddr,
    output  [31:0 ] regData,
    input           dbgSource,
    output  [31:0] commandRegData,
    input uart,
    input uart_on
);
    //metastability input filters
    wire    [ 3:0 ] devide;
    wire            enable;
    wire    [ 4:0 ] addr;
    wire uart_on_cln;

    sm_debouncer #(.SIZE(4)) f0(clkIn, clkDevide, devide);
    sm_debouncer #(.SIZE(1)) f1(clkIn, clkEnable, enable);
    sm_debouncer #(.SIZE(5)) f2(clkIn, regAddr,   addr);
    sm_debouncer #(.SIZE(1)) f3(clkIn, uart_on,   uart_on_cln);

    //cores
    //clock devider
    sm_clk_divider sm_clk_divider
    (
        .clkIn      ( clkIn     ),
        .rst_n      ( rst_n     ),
        .devide     ( devide    ),
        .enable     ( enable    ),
        .clkOut     ( clk       )
    );

    //instruction memory
    wire    [31:0]  imAddr;
    wire    [31:0]  imData;
    wire [31:0] uart_addr;
    wire rom_wr;
    wire [31:0] rom_data_in;
    wire [31:0] rom_addr = uart_on_cln ? uart_addr : imAddr;
    wire [31:0] rom_dbg_data;
    wire uart_on_rise;

    edge_detector uart_on_edge(
        .clk_in(clkIn),
        .rst_in(!rst_n),
        .sig(uart_on_cln),
        .rise(uart_on_rise)
    );

    wire protect = rom_wr & uart_on_cln;

    sm_rom reset_rom(
        .clk(clkIn),
        .wr(protect),
        .rst(uart_on_rise),
        .data_in(rom_data_in),
        .a(rom_addr),
        .rd(imData),
        .dbg_a({27'b0, addr}),
        .dbg_rd(rom_dbg_data)
    );

    mmu sm_mmu(
        .enable(uart_on_cln),
        .uart_in(uart),
        .clk(clkIn),
        .addr(uart_addr),
        .data(rom_data_in),
        .wr(rom_wr)
    );

    wire cpu_rst = rst_n & !uart_on_cln;
    wire [31:0] cpu_reg_dbg;
    assign regData = dbgSource ? rom_dbg_data : cpu_reg_dbg;

    sr_cpu sm_cpu
    (
        .clk        ( clk       ),
        .rst_n      ( cpu_rst   ),
        .regAddr    ( addr      ),
        .regData    ( cpu_reg_dbg   ),
        .imAddr     ( imAddr    ),
        .imData     ( imData    ),
        .commandRegData(commandRegData)
    );

endmodule

//metastability input debouncer module
module sm_debouncer
#(
    parameter SIZE = 1
)
(
    input                      clk,
    input      [ SIZE - 1 : 0] d,
    output reg [ SIZE - 1 : 0] q
);
    reg        [ SIZE - 1 : 0] data;

    always @ (posedge clk) begin
        begin
            data <= d;
            q    <= data;
        end
    end

endmodule

//tunable clock devider
module sm_clk_divider
#(
    parameter shift  = 0
)
(
    input           clkIn,
    input           rst_n,
    input   [ 3:0 ] devide,
    input           enable,
    output          clkOut
);
    wire [31:0] cntr;
    wire [31:0] cntrNext = cntr + 1;
    sm_register_we r_cntr(clkIn, rst_n, enable, cntrNext, cntr);

    assign clkOut = cntr[shift + devide];
endmodule
