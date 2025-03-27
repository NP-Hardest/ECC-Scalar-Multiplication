////////////////////////////////////////////  Finite Field Subtractor based on 64 bit adder, subtractor ///////////////////////////////////////////////////

module ffs(clk, rst, start, a_i, b_i, out, done);

    input clk, rst, start;
    input [254:0] a_i, b_i;
    output [254:0] out;
    output reg done;


    wire [255:0] a = {1'b0, a_i}; 
    wire [255:0] b = {1'b0, b_i}; 
    parameter [255:0] p = {1'b1, 255'b0} - 19;

    parameter INIT = 0, CYCLE_1 = 1, CYCLE_2 = 2, CYCLE_3 = 3, CYCLE_4 = 4, CYCLE_5 = 5;

    reg bo_in, c_in;
    wire bo_out, c_out;

    reg [63:0] a_in, b_in, p_in, diff_in;

    reg [255:0] d, s;

    wire [63:0] sub_out, add_out;

    reg [2:0] state;

    simple_subtractor uut(a_in, b_in, bo_in, sub_out, bo_out);


    simple_adder uuts(diff_in, p_in, c_in, add_out, c_out);

    always@(posedge clk or posedge rst) begin
        if(rst) begin
            state <= INIT;
            done <= 0;
            s <= 256'b0;
            d <= 256'b0;
            a_in <= 64'b0; 
            b_in <= 64'b0;
            p_in <= 64'b0;
            diff_in <= 64'b0;
            c_in <= 0;
            bo_in <= 0;
        end
        else begin
            case(state)
                INIT: begin
                    done <= 0;
                    if(start) begin
                        a_in <= a[63:0];
                        b_in <= b[63:0];
                        bo_in <= 0;  // no borrow initially
                        state <= CYCLE_1;
                    end
                end

                CYCLE_1: begin
                    d[63:0] <= sub_out;
                    diff_in <= sub_out;
                    p_in <= p[63:0];
                    c_in <= 0;
                    a_in <= a[127:64];
                    b_in <= b[127:64];
                    bo_in <= bo_out;
                    state <= CYCLE_2;
                end

                CYCLE_2: begin
                    d[127:64] <= sub_out;
                    s[63:0] <= add_out;
                    diff_in <= sub_out;
                    p_in <= p[127:64];
                    c_in <= c_out;
                    a_in <= a[191:128];
                    b_in <= b[191:128];
                    bo_in <= bo_out;
                    state <= CYCLE_3;
                end

                CYCLE_3: begin
                    d[191:128] <= sub_out;
                    s[127:64] <= add_out;
                    diff_in <= sub_out;
                    p_in <= p[191:128];
                    c_in <= c_out;
                    a_in <= a[255:192];
                    b_in <= b[255:192];
                    bo_in <= bo_out;
                    state <= CYCLE_4;
                end

                CYCLE_4: begin
                    d[255:192] <= sub_out;
                    s[191:128] <= add_out;
                    diff_in <= sub_out;
                    p_in <= p[255:192];
                    c_in <= c_out;
                    bo_in <= bo_out;
                    state <= CYCLE_5;
                end

                CYCLE_5: begin
                    s[255:192] <= add_out;
                    state <= INIT;
                    done <= 1;
                end
        
                default: state <=INIT;

            endcase
        end
    end

    assign out = (bo_out) ? s[254:0] : d[254:0];

endmodule
