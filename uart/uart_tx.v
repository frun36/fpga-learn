module uart_tx #(
    parameter input_clk_hz = 12_000_000,
    parameter baud_rate = 9600
) (
    input i_clk,
    input i_rst,
    input [7:0] i_data,
    input i_ready,
    output o_ready,
    output reg o_tx
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

    assign o_ready = (state == STATE_IDLE);

    always @(posedge i_clk) begin 
        if (!i_rst) begin
            state <= STATE_IDLE;
            clk_counter <= 0;
            data_ctr = 0;
        end else begin
            if (state == STATE_IDLE) begin
                o_tx <= 1; 
                if (i_ready) begin
                    state <= STATE_START;
                end
            end else if (clk_counter == DIVIDER_LIMIT) begin
                clk_counter <= 0;
                case (state)
                    STATE_START: begin
                        o_tx <= 0;
                        state <= STATE_DATA;
                    end
                    STATE_DATA: begin
                        if (data_ctr == 8) begin
                            data_ctr <= 0;
                            o_tx <= 1;
                            state <= STATE_STOP;
                        end else begin 
                            o_tx <= i_data[data_ctr];
                            data_ctr <= data_ctr + 1;
                        end
                    end
                    STATE_STOP: begin
                        o_tx <= 1;
                        state <= STATE_IDLE;
                    end 
                endcase
            end else clk_counter <= clk_counter + 1;
        end
    end
endmodule