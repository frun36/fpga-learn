module adder(
    input   [7:0]   a,
    input   [7:0]   b,
    input           sub,

    output  [7:0]   out,
    output          cf,
    output          zf
);
    assign {cf, out} = sub ? {1'b0, a} - {1'b0, b} : {1'b0, a} + {1'b0, b};

    assign zf = (out == 8'b0);
endmodule
