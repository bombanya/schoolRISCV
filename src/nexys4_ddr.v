
module nexys4_ddr
(
    input         CLK100MHZ,

    input         BTNC, //reset
    input         BTNU, //clk_e

    input  [15:0] SW, 

    output [15:0] LED,

    output        CA,
    output        CB,
    output        CC,
    output        CD,
    output        CE,
    output        CF,
    output        CG,

    output [ 7:0] AN,

    input         UART_TXD_IN
);

    // wires & inputs
    wire          clk;
    wire          clkIn     =  CLK100MHZ;
    wire          rst_n     =  BTNC;
    wire          clkEnable =  SW [9] | BTNU;
    wire [  3:0 ] clkDevide =  SW [8:5];
    wire [  4:0 ] regAddr   =  SW [4:0];
    wire [ 31:0 ] regData;
    wire          dbgSource = SW[10];
    wire [31:0]   commandRegData;
    wire          uart_on   = SW[12];

    //cores
    sm_top sm_top
    (
        .clkIn      ( clkIn     ),
        .rst_n      ( !rst_n     ),
        .clkDevide  ( clkDevide ),
        .clkEnable  ( clkEnable ),
        .clk        ( clk       ),
        .regAddr    ( regAddr   ),
        .regData    ( regData   ),
        .dbgSource  (dbgSource),
        .commandRegData(commandRegData),
        .uart(UART_TXD_IN),
        .uart_on(uart_on)
    );

    //outputs
    assign LED[0]    = clk;
    //assign LED[15:1] = regData[14:0];

    //hex out
    wire [ 31:0 ] h7segment = SW[11] ? regData : commandRegData;

    assign LED[15:1] = regData[14:0];

    seven_seg_controller display(
        .clk_in(clkIn),
        .rst_in(rst_n),
        .val_in(h7segment),
        .cat_out({CG,CF,CE,CD,CC,CB,CA}),
        .an_out(AN)
    );

endmodule
