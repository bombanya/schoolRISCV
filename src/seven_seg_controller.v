`timescale 1ns / 1ps

module seven_seg_controller(
    input clk_in,
    input rst_in,
    input [31:0] val_in,
    output [6:0] cat_out,
    output [7:0] an_out
    );
    
    reg [7:0] segment;
    reg [31:0] counter;
    reg [3:0] vals;
    
    binary_to_seven_seg converter(
        .bin_in(vals),
        .hex_out(cat_out)
    );
    
    assign an_out = segment;
    
    always @(*)
        case(segment)
            8'b1111_1110:   vals = val_in[3:0];
            8'b1111_1101:   vals = val_in[7:4];
            8'b1111_1011:   vals = val_in[11:8];
            8'b1111_0111:   vals = val_in[15:12];
            8'b1110_1111:   vals = val_in[19:16];
            8'b1101_1111:   vals = val_in[23:20];
            8'b1011_1111:   vals = val_in[27:24];
            8'b0111_1111:   vals = val_in[31:28];
            default:        vals = val_in[3:0];   
        endcase
    
    always @(posedge clk_in) begin
        if (rst_in) begin
            segment <= 8'b1111_1110;
            counter <= 32'b0;
        end else begin
            if (counter == 32'd200_000) begin
                counter <= 32'b0;
                segment <= {segment[6:0], segment[7]};
            end else begin
                counter <= counter + 1;
            end
        end
    end
endmodule
