module register(
    input           clk,
    input           rst,
    input           load,
    input   [7:0]   bus,

    output  [7:0]   out
);
    reg     [7:0]   register;

    always @(posedge clk or posedge rst) begin
        if (rst) register <= 8'b0; 
        else if (load) register <= bus;
    end

    assign out = register;
endmodule