module memory(
    input           clk,
    input           rst,
    input           load,
    input   [7:0]   bus,

    output  [7:0]   out
);
    reg     [3:0]   mar;
    reg     [7:0]   ram [0:15];

    initial begin
	    $readmemh("program.bin", ram);
    end

    always @(posedge clk or posedge rst) begin
        if (rst) mar <= 4'b0;
        else if (load) mar <= bus[3:0];
    end

    assign out = ram[mar];
endmodule