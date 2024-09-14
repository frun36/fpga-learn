module quadruple_display(
    output  [7:0] display_pins,
    output reg [3:0] select_digit,

    input clk,
    input [15:0] number
);
    reg [3:0] digit;
    reg [1:0] counter;

    reg rst = 0;

    wire slow_clk;

    clock_divider #(.MODULO(120)) cd(.clk(clk), .rst(rst), .out(slow_clk));

    display dis(.display_pins(display_pins), .digit(digit));

    always @(posedge slow_clk) counter <= counter + 1;

    always @(counter) begin
        select_digit = 4'b0000 + (1 << counter);
    end

    always @(counter) begin
        case (counter)
            2'b00: digit = number[3:0];
            2'b01: digit = number[7:4];
            2'b10: digit = number[11:8];
            2'b11: digit = number[15:12];
        endcase
    end
endmodule