module display(
    input       [3:0]   digit,
    input               dp,
    output reg  [7:0]   display_pins
    );


    always @(*) begin
        case (digit)
            4'h0: display_pins = 8'b00000011 ^ dp;
            4'h1: display_pins = 8'b10011111 ^ dp;
            4'h2: display_pins = 8'b00100101 ^ dp;
            4'h3: display_pins = 8'b00001101 ^ dp;
            4'h4: display_pins = 8'b10011001 ^ dp;
            4'h5: display_pins = 8'b01001001 ^ dp;
            4'h6: display_pins = 8'b01000001 ^ dp;
            4'h7: display_pins = 8'b00011111 ^ dp;
            4'h8: display_pins = 8'b00000001 ^ dp;
            4'h9: display_pins = 8'b00001001 ^ dp;
            4'ha: display_pins = 8'b00010001 ^ dp;
            4'hb: display_pins = 8'b11000001 ^ dp;
            4'hc: display_pins = 8'b01100011 ^ dp;
            4'hd: display_pins = 8'b10000101 ^ dp;
            4'he: display_pins = 8'b01100001 ^ dp;
            4'hf: display_pins = 8'b01110001 ^ dp;
        endcase
    end
endmodule
