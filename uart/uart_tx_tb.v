`timescale 1ns/1ns

module uart_tx_tb();
    parameter CLK_FREQ_HZ = 1_000_000;
    parameter BAUD_RATE = 9600;
    localparam CLK_PERIOD_NS = 1_000_000_000 / CLK_FREQ_HZ;
    localparam BAUD_PERIOD_NS = 1_000_000_000 / BAUD_RATE;

    reg clk = 0;
    reg rst = 0;
    reg [7:0] data = 0;
    reg send = 0;
    wire ready;
    wire tx;

    uart_tx #(
        .input_clk_hz(CLK_FREQ_HZ),
        .baud_rate(BAUD_RATE)
    ) uut (
        .i_clk(clk),
        .i_rst(rst),
        .i_data(data),
        .i_ready(send),
        .o_ready(ready),
        .o_tx(tx)
    );

    always #(CLK_PERIOD_NS / 2) clk = ~clk;

    initial begin
        $dumpfile("uart_tx_tb.vcd");
        $dumpvars(0, uart_tx_tb);

        rst = 0;
        #(5 * CLK_PERIOD_NS);
        rst = 1;

        wait (ready);

        data = 8'b00110011;
        send = 1;

        #(32 * BAUD_PERIOD_NS);
        $finish;
    end
endmodule