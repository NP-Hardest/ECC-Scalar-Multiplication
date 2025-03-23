module scalar_multiplication(k, x_p, clk, rst, add, sub, done);

    input [254:0] k, x_p;
    input clk, rst;
    output reg [254:0] add;
    output reg [254:0] sub;

    output reg done;


    wire [255:0] k_padded = {1'b0, k};


    reg [254:0] X1, X2, X3, Z2, Z3;
    reg [254:0] t1, t2, t3, t4, t5, t6, t7, t8, t9, t10, t11, t12, t13, t14;


    reg [254:0] a_add, b_add;
    reg [254:0] a_sub, b_sub;
    reg [254:0] a_mul, b_mul;
    reg [254:0] a_inv;

    reg start_mul;
    
    wire [254:0] add_res, sub_res, mul_res, inv_res;
    wire add_valid, sub_valid, mul_valid, inv_valid;    


    ffm multiplier(clk, rst, start_mul, a_mul, b_mul, mul_res, mul_valid);
    ffa adder(clk, rst, a_add, b_add, add_res, add_valid);
    ffs subtractor(clk, rst, a_sub, b_sub, sub_res, sub_valid);

    parameter IDLE = 0;
    parameter ADD_X2_Z2 = 1;
    parameter WAIT_ADD_X2_Z2 = 2;
    parameter SUB_X2_Z2 = 3;
    parameter WAIT_SUB_X2_Z2 = 4;
    parameter ADD_X3_Z3 = 5;
    parameter WAIT_ADD_X3_Z3 = 6; 
    parameter SUB_X3_Z3 = 7;
    parameter WAIT_SUB_X3_Z3 = 8; 
    parameter SQ_T1 = 9;
    parameter WAIT_SQ_T1 = 10;
    parameter SQ_T2 = 11;
    parameter WAIT_SQ_T2 = 12;
    parameter SUB_T6_T7 = 13;
    parameter WAIT_SUB_T6_T7 = 14;
    parameter MUL_T4_T1 = 15;
    parameter WAIT_MUL_T4_T1 = 16;
    parameter MUL_T3_T2 = 17;
    parameter WAIT_MUL_T3_T2 = 18;
    parameter DONE = 19;
    parameter OUT = 20;
    


    reg [4:0] state;

    always @ (posedge clk or posedge rst) begin
        if(rst) begin
            state <= IDLE;
            X1 <= x_p;
            X2 <= 1;
            Z2 <= 0;
            X3 <= x_p;
            Z3 <= 1;
            done <= 0;  // Ensure done is reset to 0
            add <= 0;   // Ensure add is reset to 0
            sub <= 0;   // Ensure sub is reset to 0
            t1 <= 0;    // Ensure temporary results are reset
            t2 <= 0;
            t6 <= 0;
            a_mul <= 0;
            b_mul <= 0;

        end

        else begin
            case (state) 
                IDLE: begin
                    done <= 0;
                    state <= ADD_X2_Z2;
                end

                ADD_X2_Z2: begin
                    a_add <= X2;
                    b_add <= Z2;

                    state <= WAIT_ADD_X2_Z2;
                end

                WAIT_ADD_X2_Z2: begin
                    if (add_valid) begin  
                        t1 <= add_res;
                        state <= SUB_X2_Z2;
                    end
                end

                SUB_X2_Z2: begin
                    a_sub <= X2;
                    b_sub <= Z2;
                    state <= WAIT_SUB_X2_Z2;
                end

                WAIT_SUB_X2_Z2: begin
                    if (sub_valid) begin  
                        t2 <= sub_res;
                        state <= ADD_X3_Z3;
                    end
                end
                
                ADD_X3_Z3: begin
                    a_add <= X3;
                    b_add <= Z3;
                    state <= WAIT_ADD_X3_Z3;
                end

                WAIT_ADD_X3_Z3: begin
                    if (add_valid) begin  
                        t3 <= add_res;
                        state <= SUB_X3_Z3;
                    end
                end

                SUB_X3_Z3: begin
                    a_sub <= X3;
                    b_sub <= Z3;
                    state <= WAIT_SUB_X3_Z3;
                end

                WAIT_SUB_X3_Z3: begin
                    if (sub_valid) begin  
                        t4 <= sub_res;
                        state <= SQ_T1;
                    end
                end

                SQ_T1: begin
                    a_mul    <= t1;
                    b_mul    <= t1;
                    start_mul<= 1;    
                    state    <= WAIT_SQ_T1;
                end

                WAIT_SQ_T1: begin
                    start_mul<= 0;  
                    if (mul_valid) begin  
                        t6    <= mul_res;
                        state <= SQ_T2;
                    end
                end

                SQ_T2: begin
                    a_mul    <= t2;
                    b_mul    <= t2;
                    start_mul<= 1;    
                    state    <= WAIT_SQ_T2;
                end

                WAIT_SQ_T2: begin
                    start_mul<= 0;  
                    if (mul_valid) begin  
                        t7    <= mul_res;
                        state <= SUB_T6_T7;
                    end
                end

                SUB_T6_T7: begin
                    a_sub <= t6;
                    b_sub <= t7;
                    state <= WAIT_SUB_T6_T7;
                end

                WAIT_SUB_T6_T7: begin
                    if (sub_valid) begin  
                        t5 <= sub_res;
                        state <= MUL_T4_T1;
                    end
                end

                MUL_T4_T1: begin
                    a_mul <= t4;
                    b_mul <= t1;
                    start_mul<= 1;    
                    state <= WAIT_MUL_T4_T1;
                end

                WAIT_MUL_T4_T1: begin
                    start_mul<= 0;    
                    if (mul_valid) begin  
                        t8 <= mul_res;
                        state <= MUL_T3_T2;
                    end
                end

                MUL_T3_T2: begin
                    a_mul <= t3;
                    b_mul <= t2;
                    start_mul<= 1;    
                    state <= WAIT_MUL_T3_T2;
                end

                WAIT_MUL_T3_T2: begin
                    start_mul<= 0;    
                    if (mul_valid) begin  
                        t9 <= mul_res;
                        state <= DONE;
                    end
                end

                DONE: begin
                        add <= t9;
                        sub <= t8;
                        state <= OUT;
                end

                OUT: begin
                        done<=1;
                        state <= OUT;
                end
            endcase
        end
    end



endmodule;