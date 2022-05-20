`timescale 1ns / 1ps

module sqrt(
    input clk_in,
    input rst_in,
    
    input [7:0] a_in,
    input start_in,
    
    output busy_out,
    output reg [3:0] y_out
    );
    
    localparam IDLE = 1'b0;
    localparam WORK = 1'b1;
    
    reg [3:0] ctr;
    wire [7:0] m;
    reg [7:0] y;
    wire [7:0] b;
    reg state;
    reg [7:0] a;
    
    assign b = y | m;
    assign busy_out = state;
    assign m = 1 << (ctr - 2);
    
    always @(posedge clk_in, posedge rst_in) begin
        if (rst_in) begin
            ctr <= 8;
            y <= 0;
            state <= IDLE;
            y_out <= 0;
        end else begin
            case (state)
                IDLE:
                    begin
                        if (start_in) begin
                            state <= WORK;
                            a <= a_in;
                            ctr <= 8;
                            y <= 0;
                        end
                    end
                WORK:
                    begin
                        if (ctr == 0) begin
                            state <= IDLE;
                            y_out <= y;
                        end else begin
                            if (a >= b) begin
                                a <= a - b;
                                y <= (y >> 1) | m;
                            end else begin
                                y <= y >> 1;
                            end
                            ctr <= ctr - 2;
                        end
                    end
            endcase
        end
    end
endmodule
