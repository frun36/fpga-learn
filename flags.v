module flags(
    input           clk,
    input           rst,
    input           load,
    input           cf_in,
    input           zf_in,

    output reg      cf_out,
    output reg      zf_out
);
    reg     [1:0]   flags;

    always @(posedge clk or posedge rst) begin
        if (rst) flags <= 2'b0;
        else if (load) flags <= {cf_in, zf_in};
    end

    assign {cf_out, zf_out} = flags;

endmodule