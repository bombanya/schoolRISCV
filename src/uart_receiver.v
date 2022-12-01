module uart_receiver(
    input enable,
    input uart_in,
    input clk,
    output reg [31:0] addr,
    output reg [31:0] data,
    output wr
);

    reg [4:0] bit_n;
    reg [3:0] msg;
    reg [13:0] cntr;

    assign wr = enable & (uart_in == 1) & msg == 0 & (bit_n == 0);

    always @(posedge clk) begin
        if (enable) begin
            if (msg == 0 && uart_in == 0) begin
                msg <= msg + 1;
            end else if (msg != 0) begin
                if (cntr == 10417) begin
                    cntr <= 0;
                    if (msg == 9) begin
                        msg <= 0;
                        if (bit_n == 0) begin
                            addr <= addr + 1;
                        end
                    end else begin
                        data[bit_n] <= uart_in;
                        bit_n <= bit_n + 1;
                        msg <= msg + 1;
                    end
                end else begin
                    cntr <= cntr + 1;
                end
            end
        end else begin
            bit_n <= 0;
            msg <= 0;
            cntr <= 0;
            addr <= -1;
            data <= 0;
        end
    end

endmodule