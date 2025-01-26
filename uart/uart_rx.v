module uart_rx #(
    parameter input_clk_hz = 12_000_000,
    parameter baud_rate = 9600
) (
    input i_clk,
    input i_rst,
    input i_rx,
    output reg [7:0] o_data,
    output reg o_ready
);
    localparam DIVIDER_LIMIT = input_clk_hz / baud_rate;
    localparam DIVIDER_WIDTH = $clog2(DIVIDER_LIMIT);
    reg [DIVIDER_WIDTH-1:0] clk_counter = 0;

    localparam STATE_IDLE = 2'b00;
    localparam STATE_START = 2'b01;
    localparam STATE_DATA = 2'b10;
    localparam STATE_STOP = 2'b11;
    reg [1:0] state = STATE_IDLE;

    reg [3:0] data_ctr = 0;

    always @(posedge i_clk) begin
        if (!i_rst) begin
            clk_counter <= 0;
            state <= STATE_IDLE;
            o_data <= 0;
            data_ctr <= 0;
            o_ready <= 0;
        end else begin
            case (state)
                STATE_IDLE: begin
                    if (!i_rx) begin
                        clk_counter <= 0;
                        state <= STATE_START;
                    end
                end

                STATE_START: begin
                    if (clk_counter == DIVIDER_LIMIT / 2) begin
                        clk_counter <= 0;
                        state <= STATE_DATA;
                    end else clk_counter <= clk_counter + 1;
                end

                STATE_DATA: begin
                    if (clk_counter == DIVIDER_LIMIT) begin
                        if (data_ctr == 8) begin
                            data_ctr <= 0;
                            if (i_rx) begin
                                o_ready <= 1;
                                state <= STATE_STOP;
                            end else state <= STATE_IDLE;
                        end else begin
                            clk_counter <= 0;
                            o_data[data_ctr] <= i_rx;
                            data_ctr <= data_ctr + 1;
                        end
                    end else clk_counter <= clk_counter + 1;
                end

                STATE_STOP: begin
                    o_ready <= 0;
                    state <= STATE_IDLE;
                end

            endcase
        end
    end
endmodule