module math_unit(
    input clk_in,
    input rst_in,
    input [7:0] a,
    input [7:0] b,
    input start,

    output busy,
    output [15:0] res
);

    wire start_rise;
    wire busy_sqrt;
    wire ready_sqrt;
    wire ready_mul;

    wire [3:0] sqrt_b;

    assign busy = start | busy_sqrt | ready_sqrt | ready_mul;

    edge_detector edge_start (
        .clk_in(clk_in),
        .rst_in(rst_in),
        .sig(start),
        .rise(start_rise)
    );

    sqrt root(
        .clk_in(clk_in),
        .rst_in(rst_in),
        .a_in(b),
        .start_in(start_rise),
        .busy_out(busy_sqrt),
        .y_out(sqrt_b)
    );

    edge_detector #(.INIT(1'b1)) edge_sqrt(
        .clk_in(clk_in),
        .rst_in(rst_in),
        .sig(!busy_sqrt),
        .rise(ready_sqrt)
    );

    mult multiplier(
        .clk_in(clk_in),
        .rst_in(rst_in),
        .a_in(a),
        .b_in({4'd0, sqrt_b}),
        .start_in(ready_sqrt),
        .y_out(res),
        .busy_out(ready_mul)
    );

endmodule