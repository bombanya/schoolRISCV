`timescale 1ns / 1ps

module mult(
    input clk_in,
    input rst_in,
    
    input [7:0] a_in,
    input [7:0] b_in,
    input start_in,
    
    output busy_out,
    output reg [15:0] y_out
    );
    
    localparam IDLE = 2'b0;
    localparam WORK = 2'b1;
    localparam WAIT = 2'b10;
    
    reg [3:0] ctr;
    wire end_step;
    wire [7:0] part_sum;
    wire [15:0] shifted_part_sum;
    reg [7:0] a, b;
    reg [15:0] part_res;
    reg [1:0] state;
    
    assign part_sum = a & {8{b[ctr]}};
    assign shifted_part_sum = part_sum << ctr;
    assign end_step = (ctr == 4'h8);
    assign busy_out = state != IDLE;
    
    always @(posedge clk_in)
        if (rst_in) begin
            ctr <= 0;
            part_res <= 0;
            y_out <= 0;
            state <= IDLE;
        end else begin
            case (state)
                IDLE:
                    if (start_in) begin
                        state <= WORK;
                        a <= a_in;
                        b <= b_in;
                        ctr <= 0;
                        part_res <= 0;
                    end
                WORK:
                    begin
                        if (end_step) begin
                            state <= WAIT;
                            y_out <= part_res;
                        end
                        
                        part_res <= part_res + shifted_part_sum;
                        ctr <= ctr + 1;
                    end
                WAIT:
                    begin
                        state <= IDLE;
                    end
            endcase
        end
    
endmodule
