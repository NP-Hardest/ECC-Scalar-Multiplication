`timescale 1ns/1ps
module tb_ffs;

    reg         clk;
    reg         rst;
    reg         start;
    reg [254:0] a;
    reg [254:0] b;
    wire [254:0] result;
    wire        valid;

    ffs uut (
        .clk(clk),
        .rst(rst),
        .start(start),
        .a(a),
        .b(b),
        .result(result),
        .valid(valid)
    );

    initial begin
        clk = 0;
        forever #5 clk = ~clk;
    end

    initial begin
        rst   = 1;
        start = 0;
        a     = 0;
        b     = 0;
        #12;         

        rst = 0;      
        a = 44927731495623270119727621215091840270797887326986279676957494683529379806913;
        b = 45965849458578823337785628114947185621072782472466027602082789798859530730301;
        start = 1;
        #10;          
        start = 0;
        #20;        

            $display("Test completed at time %0t", $time);
    $display("Input a : %d", a);
    $display("Input b : %d", b);
    $display("Output  : %d", result);

        #20;
        $finish;
    end

    
endmodule
