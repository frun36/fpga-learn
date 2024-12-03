module pc(
    input           clk,
    input           rst,
    input           inc,
    input           load,
    input   [7:0]   bus,

    output  [7:0]   out
);
    reg     [3:0]   counter;

    always @(posedge clk or posedge rst) begin
        if (rst) counter <= 4'b0; 
        else if (inc) counter <= counter + 1;
        else if (load) counter <= bus[3:0];
    end

    assign out = counter;
endmodule