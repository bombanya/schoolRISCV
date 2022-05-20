`timescale 1ns / 1ps

module edge_detector
#(
    parameter INIT = 1'b0
)
(
    input clk_in,
    input rst_in,
    input sig,
    output rise
    );
    
    reg old_sig;
    assign rise = sig & !old_sig;
    
    always @(posedge clk_in) begin
        if (rst_in) begin
            old_sig <= INIT;
        end else begin
            old_sig <= sig;
        end
    end
endmodule
