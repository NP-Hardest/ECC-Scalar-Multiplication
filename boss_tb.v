module tb_scalar_multiplication;

    reg [254:0] k;
    reg [254:0] x_p;
    reg clk, rst;

    wire [254:0] x_q;
    wire done;

    scalar_multiplication uut (clk, rst, k, x_p, x_q, done);

    initial begin
        clk <= 0;
        forever #5 clk <= ~clk;
    end

    reg [31:0] cycle_count;

    always @(posedge clk) begin
        if (rst)
            cycle_count <= 0;
        else
            cycle_count <= cycle_count + 1;
    end

    initial begin
        clk <= 0;
        rst <= 0;
        x_p <= 255'd9;                   // x_p = 9
        k <= 255'h1000000000000000000000000000000014def9dea2f79cd65812631a5cf5d3ed + 255'd1;        
        //order +1, taken from https://neuromancer.sk/std/other/Curve25519
        
        rst <= 1;
        #100;
        rst <= 0;

        wait(done);

        $display("x_q : %d", x_q);
        $display("Total clock cycles : %d", cycle_count);
        
        $finish;
    end

endmodule
