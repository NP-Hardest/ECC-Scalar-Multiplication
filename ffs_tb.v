`timescale 1ns/1ps
module tb_ffs;

    // Testbench signals
    reg         clk;
    reg         rst;
    reg         start;
    reg [254:0] a;
    reg [254:0] b;
    wire [254:0] result;
    wire        valid;

    // Instantiate the device under test (DUT)
    ffs uut (
        .clk(clk),
        .rst(rst),
        .start(start),
        .a(a),
        .b(b),
        .result(result),
        .valid(valid)
    );

    // Clock generation: 10 ns period
    initial begin
        clk = 0;
        forever #5 clk = ~clk;
    end

    // Stimulus block
    initial begin
        // Initialize inputs
        rst   = 1;
        start = 0;
        a     = 0;
        b     = 0;
        #12;            // Wait a few cycles with reset asserted

        rst = 0;       // Release reset

        // Test case 1: a >= b
        // Example: a = 10, b = 5; Expected result: 5
        a = 45965849458578823337285628114947185621072782472466027602082789798859530730302;
        b = 45965849458578823337785628114947185621072782472466027602082789798859530730301;
        start = 1;
        #10;           // Provide one clock cycle for start signal
        start = 0;
        #20;           // Wait to capture the result

            $display("Test completed at time %0t", $time);
    // $display("Clock cycles taken: %d", count);
    $display("Input a : %d", a);
    $display("Input b : %d", b);
    $display("Output  : %d", result);

        #20;
        $finish;
    end

    
endmodule
