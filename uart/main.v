module main (
    input clk,
    input rst,
    output tx,
    input rx
);
    wire [7:0] data;
    wire send;
    wire ready;
    wire tx_ready;

    assign send = (ready & tx_ready);

    uart_tx #(
        .input_clk_hz(12_000_000),
        .baud_rate(9600)
    ) ut (
        .i_clk(clk),
        .i_rst(rst),
        .i_data(data),
        .i_ready(send),
        .o_ready(tx_ready),
        .o_tx(tx)
    );

    uart_rx #(
        .input_clk_hz(12_000_000),
        .baud_rate(9600)
    ) ur (
        .i_clk(clk),
        .i_rst(rst),
        .i_rx(rx),
        .o_ready(ready),
        .o_data(data)
    );
endmodule