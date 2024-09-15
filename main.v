module main(
    input			clk,
    input			rst_btn,

    output  [7:0]   display,
    output  [3:0]   digit,
    output          led,
    output          cf_led,
    output          zf_led
);
    wire rst;
    assign rst = ~rst_btn;
    
    wire slow_clk;
    clock_divider #(.MODULO(300000)) cdiv(
        .clk(clk),
        .rst(rst),
        .out(slow_clk)
    );

    wire hlt;
    wire cpu_clk;
    clock c(
        .in(slow_clk),
        .hlt(hlt),
        .out(cpu_clk)
    );
    assign {led, cf_led, zf_led} = {cpu_clk, flags_cf, flags_zf};

    reg		[7:0]	bus;
    always @(*) begin
        if (ir_en) begin
            bus = ir_addr_out;
        end else if (adder_en) begin
            bus = adder_out;
        end else if (a_en) begin
            bus = a_out;
        end else if (mem_en) begin
            bus = mem_out;
        end else if (pc_en) begin
            bus = pc_out;
        end else begin
            bus = 8'b0;
        end
    end


    wire pc_inc;
    wire pc_load;
    wire pc_en;
    wire    [7:0]   pc_out;  
    pc pc(
        .clk(cpu_clk),
        .rst(rst),
        .inc(pc_inc),
        .load(pc_load),
        .bus(bus),
        .out(pc_out)
    );

    wire mar_load;
    wire mem_st;
    wire mem_en;
    wire    [7:0]   mem_out;
    memory mem(
        .clk(cpu_clk),
        .rst(rst),
        .load(mar_load),
        .store(mem_st),
        .bus(bus),
        .out(mem_out)
    );

    wire a_load;
    wire a_en;
    wire    [7:0]   a_out;
    register reg_a(
        .clk(cpu_clk),
        .rst(rst),
        .load(a_load),
        .bus(bus),
        .out(a_out)
    );

    wire b_load;
    wire    [7:0]   b_out;
    register reg_b(
        .clk(cpu_clk),
        .rst(rst),
        .load(b_load),
        .bus(bus),
        .out(b_out)
    );

    wire adder_sub;
    wire adder_en;
    wire adder_cf;
    wire adder_zf;
    wire    [7:0]   adder_out;
    adder adder(
        .a(a_out),
        .b(b_out),
        .sub(adder_sub),
        .out(adder_out),
        .cf(adder_cf),
        .zf(adder_zf)
    );

    wire ir_load;
    wire ir_en;
    wire    [3:0]   ir_instr_out;
    wire    [3:0]   ir_addr_out;
    ir ir (
        .clk(cpu_clk),
        .rst(rst),
        .load(ir_load),
        .bus(bus),
        .instr_out(ir_instr_out),
        .addr_out(ir_addr_out)
    );

    wire out_load;
    wire    [7:0]   out_out;
    register out(
        .clk(cpu_clk),
        .rst(rst),
        .load(out_load),
        .bus(bus),
        .out(out_out)
    );

    wire flags_load;
    wire flags_cf;
    wire flags_zf;
    flags flags(
        .clk(cpu_clk),
        .rst(rst),
        .load(flags_load),
        .cf_in(adder_cf),
        .zf_in(adder_zf),
        .cf_out(flags_cf),
        .zf_out(flags_zf)
    );

    controller controller(
        .clk(cpu_clk),
        .rst(rst),
        .flags({flags_cf, flags_zf}),
        .opcode(ir_instr_out),
        .out(
        {
            hlt,
            pc_inc,
            pc_load,
            pc_en,
            mar_load,
            mem_st,
            mem_en,
            ir_load,
            ir_en,
            a_load,
            a_en,
            b_load,
            adder_sub,
            adder_en,
            flags_load,
            out_load
        })
    );

    reg [3:0] digit_mask = 4'b0011;
    reg [3:0] dp = 4'b0000;
    quadruple_display dis(
        .clk(clk), 
        .rst(rst),
        .number({8'b0, out_out}),
        .dp(dp),
        .digit_mask(digit_mask),
        .select_digit(digit), 
        .display_pins(display), 
    );

endmodule


