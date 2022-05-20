`timescale 1ns / 1ps

module binary_to_seven_seg(
    input [3:0] bin_in,
    output reg [6:0] hex_out
    );
    
    always @(*)
        case (bin_in)
            4'h0: hex_out <= 7'b1000000;
            4'h1: hex_out <= 7'b1111001;
            4'h2: hex_out <= 7'b0100100;
            4'h3: hex_out <= 7'b0110000;
            4'h4: hex_out <= 7'b0011001;
            4'h5: hex_out <= 7'b0010010;
            4'h6: hex_out <= 7'b0000010;
            4'h7: hex_out <= 7'b1111000;
            4'h8: hex_out <= 7'b0000000;
            4'h9: hex_out <= 7'b0011000;
            4'hA: hex_out <= 7'b0001000;
            4'hB: hex_out <= 7'b0000011;
            4'hC: hex_out <= 7'b1000110;
            4'hD: hex_out <= 7'b0100001;
            4'hE: hex_out <= 7'b0000110;
            4'hF: hex_out <= 7'b0001110;
        endcase
endmodule
