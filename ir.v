module ir(
    input           clk,
    input           rst,
    input           load,
    input   [7:0]   bus,

    output  [7:0]   out
);
    reg     [7:0]   ir;

    always @(posedge clk or posedge rst) begin
        if (rst) ir <= 8'b0;
        else if (load) ir <= bus;
    end

    assign out = ir;
endmodule