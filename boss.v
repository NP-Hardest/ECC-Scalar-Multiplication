////////////////////////////////////////////////Scalar multiplication for curve 25519 using Montgomery Ladder////////////////////////////////////////////////

module scalar_multiplication(clk, rst, k, x_p, x_q, done);

    input [254:0] k, x_p;
    input clk, rst;
    output reg [254:0] x_q;
    output reg done;

    wire [255:0] k_padded = {1'b0, k};              //set k_255 = 0

    reg start_mul;                                  //start signals for arithmetic
    reg start_add;
    reg start_sub;
    

    reg [254:0] X1, X2, X3, Z2, Z3;                             //store registers
    reg [254:0] t1, t2, t3, t4, t5, t6, t7, t8, t9, t10, t11, t12, t13, t14;            //temporary register


    wire [254:0] a_add, b_add;              //inputs to arithmetic modules
    wire [254:0] a_sub, b_sub;
    wire [254:0] a_mul, b_mul;
    reg [254:0] a_inv;

    wire [254:0] add_res, sub_res, mul_res, inv_res;            //results of arithmetic operations
    wire add_valid, sub_valid, mul_valid, inv_valid;            //valid signals from arithmetic modules to jump to next cycles


    reg [1:0] sel_add, sel_sub;                                 //select signals for all multiplexors
    reg [3:0] sel_mul;

    four_to_one_mux muxa_add(X2, X3, t8, t7, a_add, sel_add);       //1st input to adder from mux
    four_to_one_mux muxb_add(Z2, Z3, t9, t13, b_add, sel_add);      //2nd input to adder from mux

    four_to_one_mux muxa_sub(X2, X3, t6, t8, a_sub, sel_sub);       //1st input to subtractor from mux
    four_to_one_mux muxb_sub(Z2, Z3, t7, t9, b_sub, sel_sub);       //2nd input to subtractor from mux

    eleven_to_one_mux muxa_mul(t1, t2, t4, t3, t6, 255'd121666, t10, t11, X1, t5, X2, a_mul, sel_mul);      //1st input to multiplier from mux
    eleven_to_one_mux muxb_mul(t1, t2, t1, t2, t7, t5, t10, t11, t12, t14, Z2, b_mul, sel_mul);             //2nd input to multiplier from mux
    
    ffm multiplier(clk, rst, start_mul, a_mul, b_mul, mul_res, mul_valid);          //arithmetic modules
    ffa adder(clk, rst, start_add, a_add, b_add, add_res, add_valid);
    ffs subtractor(clk, rst, start_sub, a_sub, b_sub, sub_res, sub_valid);
    ffi inversion(clk, rst, a_inv, inv_res, inv_valid);

    parameter INIT = 0;                                         //FSM state declarations
    parameter STEP_1 = 1;
    parameter WAIT_STEP_1 = 2;
    parameter STEP_2 = 3;
    parameter WAIT_STEP_2 = 4;
    parameter STEP_3 = 5;
    parameter WAIT_STEP_3 = 6;
    parameter STEP_4 = 7;
    parameter WAIT_STEP_4 =8;
    parameter STEP_5 = 9;
    parameter WAIT_STEP_5 = 10; 
    parameter STEP_6 = 11;
    parameter WAIT_STEP_6 = 12; 
    parameter STEP_7 = 13;
    parameter WAIT_STEP_7  = 14; 
    parameter STEP_8 = 15;
    parameter WAIT_STEP_8  = 16; 
    parameter STEP_9 = 17;
    parameter WAIT_STEP_9  = 18; 
    parameter STEP_10= 19;
    parameter WAIT_STEP_10 = 20; 
    parameter STEP_11 = 21;
    parameter WAIT_STEP_11 = 22;
    parameter STEP_12 = 23;
    parameter WAIT_STEP_12 = 24;
    parameter STEP_13 = 25;
    parameter WAIT_STEP_13 = 26;
    parameter STEP_14 = 27;
    parameter WAIT_STEP_14 = 28;
    parameter STEP_15 = 29;
    parameter WAIT_STEP_15 = 30;
    parameter OUT = 31;

    reg [5:0] state;                
    reg [7:0] i;                //iteration variable
    reg c;                      //c variable for cswap

    always @ (posedge clk or posedge rst) begin
        if(rst) begin
            sel_add <= 0; sel_mul<= 0; sel_sub <=0;
            state <= INIT;
            X1 <= x_p;
            X2 <= 1;
            Z2 <= 0;
            X3 <= x_p;
            Z3 <= 1;
            done <= 0; 
            x_q <= 0; 
            t1 <= 0; t2 <= 0; t3 <= 0; t4 <= 0; t5 <= 0; t6 <= 0; t7 <= 0; t8 <= 0; t9 <= 0; t10 <= 0; t11 <= 0; t12 <= 0; t13 <= 0; t14 <= 0;
            i <= 8'd254;
        end

        else begin
            case (state) 
                INIT: begin
                    $display("%d", i);
                    done <= 0;
                    c <= k_padded[i+1]^k_padded[i];
                    state <= STEP_1;
                end

                STEP_1: begin
                    if(c) begin             //cswap
                        X2 <= X3;
                        X3 <= X2;
                        Z2 <= Z3;
                        Z3 <= Z2;
                    end
                    state <= STEP_2;
                end

                STEP_2: begin
                    sel_add <= 2'b00;
                    sel_sub <= 2'b00;
                    start_add<= 1;   
                    start_sub<= 1; 
                    state <= WAIT_STEP_2;
                end

                WAIT_STEP_2: begin
                    start_add <= 0;   
                    start_sub <= 0;   
                    if (add_valid) begin            //addition and subtraction take equal time so choose either
                        t1 <= add_res;
                        t2 <= sub_res;
                        state <= STEP_3;
                    end
                end
                
                STEP_3: begin
                    sel_add <= 2'b01;
                    sel_sub <= 2'b01;
                    sel_mul <= 4'b0000;
                    start_add<= 1; 
                    start_mul <= 1;
                    start_sub<= 1;    
                    state <= WAIT_STEP_3;
                end

                WAIT_STEP_3: begin
                    start_add <= 0; 
                    start_sub <= 0;  
                    start_mul <= 0; 
                    if (mul_valid) begin  
                        t3 <= add_res;
                        t4 <= sub_res;
                        t6 <= mul_res;
                        state <= STEP_4;
                    end
                end

                STEP_4: begin
                    sel_mul <= 4'b0001;
                    start_mul<= 1;    
                    state    <= WAIT_STEP_4;
                end

                WAIT_STEP_4: begin
                    start_mul<= 0;  
                    if (mul_valid) begin  
                        t7 <= mul_res;
                        state <= STEP_5;
                    end
                end

                STEP_5: begin
                    sel_sub <= 2'b10;
                    start_sub<= 1; 
                    sel_mul <= 4'b0010;
                    start_mul<= 1;      
                    state <= WAIT_STEP_5;
                end

                WAIT_STEP_5: begin
                    start_sub<= 0;   
                    start_mul<= 0;   
                    if (mul_valid) begin        //multiplication always faster than subtraction
                        t5 <= sub_res;
                        t8 <= mul_res;
                        state <= STEP_6;
                    end
                end

                STEP_6: begin
                    sel_mul <= 4'b0011;
                    start_mul<= 1; 
                    state <= WAIT_STEP_6;
                end

                WAIT_STEP_6: begin
                    start_mul<= 0;   
                    if (mul_valid) begin  
                        t9 <= mul_res;
                        state <= STEP_7;
                    end
                end

                STEP_7: begin
                    sel_add <= 2'b10;
                    sel_sub <= 2'b11;          
                    start_add<= 1;     
                    start_sub<= 1;     
                    start_mul<= 1;     
                    sel_mul <= 4'b0100;
                    state <= WAIT_STEP_7;
                end

                WAIT_STEP_7: begin
                    start_add<= 0; 
                    start_sub<= 0; 
                    start_mul<= 0; 
                    if (mul_valid) begin  
                        t10 <= add_res;
                        t11 <= sub_res;
                        X2 <= mul_res;
                        state <= STEP_8;
                    end
                end

                STEP_8: begin
                    start_mul<= 1;    
                    sel_mul <= 4'b0101;
                    state <= WAIT_STEP_8;
                end

                WAIT_STEP_8: begin
                    start_mul<= 0;     
                    if (mul_valid) begin  
                        t13 <= mul_res;
                        state <= STEP_9;
                    end
                end

                STEP_9: begin
                    sel_mul <= 4'b0110;
                    sel_add <= 2'b11;
                    start_add<= 1;
                    start_mul <= 1;     
                    state <= WAIT_STEP_9;
                end

                WAIT_STEP_9: begin
                    start_mul<= 0; 
                    start_add <= 0;   
                    if (mul_valid) begin  
                        X3 <= mul_res;
                        t14 <= add_res;
                        state <= STEP_10;
                    end
                end

                STEP_10: begin
                    sel_mul <= 4'b0111;
                    start_mul<= 1;      
                    state <= WAIT_STEP_10;
                end

                WAIT_STEP_10: begin
                    start_mul<= 0;  
                    if (mul_valid) begin  
                        t12 <= mul_res;
                        state <= STEP_11;
                    end
                end

                STEP_11: begin
                    sel_mul <= 4'b1000;
                    start_mul<= 1;    
                    state <= WAIT_STEP_11;
                end

                WAIT_STEP_11: begin
                    start_mul<= 0;    
                    if (mul_valid) begin  
                        Z3 <= mul_res;
                        state <= STEP_12;
                    end
                end

                STEP_12: begin
                    sel_mul <= 4'b1001;
                    start_mul<= 1;    
                    state <= WAIT_STEP_12;
                end

                WAIT_STEP_12: begin
                    start_mul<= 0;    
                    if (mul_valid) begin  
                        Z2 <= mul_res;
                        state <= STEP_13;
                    end
                end

                STEP_13: begin 
                    if(i == 0) begin                //exit if all 255 iterations done
                        if(k[0]) begin          //cswap
                            X2 <= X3;
                            X3 <= X2;
                            Z2 <= Z3;
                            Z3 <= Z2;
                        end
                        state <= STEP_14;
                    end
                    else begin 
                        i = i - 1;
                        state <= INIT;
                    end
                end

                STEP_14: begin              
                    a_inv <= Z2;
                    state <= WAIT_STEP_14;
                end

                WAIT_STEP_14: begin
                    if(inv_valid) begin             //inversion
                    Z2 <= inv_res;
                    state <= STEP_15;
                    end
                end

                STEP_15: begin
                    sel_mul <= 4'b1010;
                    start_mul<= 1;    
                    state <= WAIT_STEP_15;
                end

                WAIT_STEP_15: begin
                    start_mul<= 0;    
                    if (mul_valid) begin  
                        x_q <= mul_res;
                        state <= OUT;
                    end
                end

                OUT: begin 
                    done <= 1;
                    state <= OUT;
                end
            endcase
        end
    end

endmodule;