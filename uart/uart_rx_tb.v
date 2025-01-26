`timescale 1ns/1ns

module uart_rx_tb();
    parameter CLK_FREQ_HZ = 1_000_000;
    parameter BAUD_RATE = 9600;
    localparam CLK_PERIOD_NS = 1_000_000_000 / CLK_FREQ_HZ;
    localparam BAUD_PERIOD_NS = 1_000_000_000 / BAUD_RATE;

    reg clk = 0;
    reg rst = 0;
    wire [7:0] data = 0;
    wire ready;
    reg tx;

    uart_rx #(
        .input_clk_hz(CLK_FREQ_HZ),
        .baud_rate(BAUD_RATE)
    ) uut (
        .i_clk(clk),
        .i_rst(rst),
        .i_rx(tx),
        .o_ready(ready),
        .o_data(data)
    );

    always #(CLK_PERIOD_NS / 2) clk = ~clk;

    parameter [7:0] DATA = 8'h66;
    integer i;
    initial begin
        $dumpfile("uart_rx_tb.vcd");
        $dumpvars(0, uart_rx_tb);


        rst = 0;
        #(5 * CLK_PERIOD_NS);
        rst = 1;

        tx <= 0;
        #(BAUD_PERIOD_NS);

        for (i = 0; i < 8; i = i + 1) begin
            tx <= DATA[i];
            #(BAUD_PERIOD_NS);
        end

        tx <= 1;
        #(BAUD_PERIOD_NS);

        #(5 * BAUD_PERIOD_NS);
        $finish;
    end
endmodule