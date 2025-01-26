module main (
    input clk,
    input rst,
    output tx
);
    reg [7:0] data = 8'h46;
    reg send = 1;
    wire ready;

    uart_tx #(
        .input_clk_hz(12_000_000),
        .baud_rate(9600)
    ) uut (
        .i_clk(clk),
        .i_rst(rst),
        .i_data(data),
        .i_ready(send),
        .o_ready(ready),
        .o_tx(tx)
    );
endmodule