module quadruple_display(
    input               clk,
    input               rst,
    input       [15:0]  number,
    input       [3:0]   dp,
    input       [3:0]   digit_mask,


    output reg  [3:0]   select_digit,
    output      [7:0]   display_pins
);
    reg [3:0]   digit;
    reg [1:0]   counter;
    reg         curr_dp;

    wire slow_clk;
    clock_divider #(.MODULO(120)) cd(.clk(clk), .rst(rst), .out(slow_clk));

    display dis(
        .digit(digit),
        .dp(curr_dp),
        .display_pins(display_pins) 
    );

    always @(posedge slow_clk) 
        counter <= counter + 1;

    always @(*)
        select_digit = (4'b0000 + (1 << counter)) & digit_mask;

    always @(*) begin
        case (counter)
            2'b00: digit = number[3:0];
            2'b01: digit = number[7:4];
            2'b10: digit = number[11:8];
            2'b11: digit = number[15:12];
        endcase
    end

    always @(*)
        curr_dp = dp[counter];

endmodule