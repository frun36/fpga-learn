module clock(
    input           hlt,
    input           in,

    output          out
);
    assign out = hlt ? 1'b0 : in; 
endmodule