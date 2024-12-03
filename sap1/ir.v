module ir (
    input           clk,
    input           rst,
    input           load,
    input   [7:0]   bus,

    output  [3:0]   instr_out,
    output  [3:0]   addr_out
);
    reg     [7:0]   register;

    always @(posedge clk or posedge rst) begin
        if (rst) register <= 8'b0; 
        else if (load) register <= bus;
    end

    assign instr_out = register[7:4];
    assign addr_out = register[3:0];
endmodule