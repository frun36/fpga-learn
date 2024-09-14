module pc(
    input           clk,
    input           rst,
    input           inc,

    output  [7:0]   out
);
    reg     [3:0]   counter;

    always @(posedge clk or posedge rst) begin
        if (rst) counter <= 4'b0; 
        else if (inc) counter <= counter + 1;
    end

    assign out = counter;
endmodule