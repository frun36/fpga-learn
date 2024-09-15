module controller(
    input           clk,
    input           rst,
    input   [3:0]   opcode,
    output  [13:0]  out
);

    localparam OP_NOP = 4'b0000;
    localparam OP_LDA = 4'b0001;
    localparam OP_ADD = 4'b0010;
    localparam OP_SUB = 4'b0011;
    localparam OP_STA = 4'b0100;
    localparam OP_JMP = 4'b0101;
    localparam OP_HLT = 4'b1111;

    reg [2:0] stage;

    reg hlt, pc_inc, pc_load, pc_en, mar_load, mem_st, mem_en, ir_load, ir_en, 
        a_load, a_en, b_load, adder_sub, adder_en;

    always @(negedge clk or posedge rst) begin
        if (rst)
            stage <= 3'b0;
        else begin
            if (stage >= 5) 
                stage <= 0;
            else 
                stage <= stage + 1;
        end
    end

    always @(*) begin
        {hlt, pc_inc, pc_load, pc_en, mar_load, mem_st, mem_en, ir_load, ir_en, 
         a_load, a_en, b_load, adder_sub, adder_en} = 13'b0;

        case (stage)
            0: begin
                pc_en = 1;
                mar_load = 1;
            end
            1: begin
                pc_inc = 1;
            end
            2: begin
                mem_en = 1;
                ir_load = 1;
            end
            3: begin
                case (opcode)
                    OP_LDA, OP_ADD, OP_SUB, OP_STA: begin
                        ir_en = 1;
                        mar_load = 1;
                    end
                    OP_JMP: begin
                        ir_en = 1;
                        pc_load = 1;
                    end
                    OP_HLT: begin
                        hlt = 1;
                    end
                endcase
            end
            4: begin
                case (opcode)
                    OP_LDA: begin
                        mem_en = 1;
                        a_load = 1;
                    end
                    OP_ADD, OP_SUB: begin
                        mem_en = 1;
                        b_load = 1;
                    end
                    OP_STA: begin
                        a_en = 1;
                        mem_st = 1;
                    end
                endcase
            end
            5: begin
                case (opcode)
                    OP_ADD: begin
                        adder_en = 1;
                        a_load = 1;
                    end
                    OP_SUB: begin
                        adder_sub = 1;
                        adder_en = 1;
                        a_load = 1;
                    end
                endcase
            end
        endcase
    end


    assign out = {
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
        adder_en
    };

endmodule
