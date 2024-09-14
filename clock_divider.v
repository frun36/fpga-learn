module clock_divider #(
    parameter   MODULO   = 6000000
) (
    input           clk,
    input           rst,
    output reg      out
);
    localparam WIDTH = (MODULO == 1) ? 1 : $clog2(MODULO);

    reg [WIDTH - 1 : 0] count = 0;

    always @ (posedge clk or posedge rst) begin
        if (rst) begin
            count <= 0;
            out <= 0;
        end
        else if (count == MODULO - 1) begin
            count <= 0;
            out <= ~out;
        end
        else 
            count <= count + 1'b1;
    end
endmodule