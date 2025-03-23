`timescale 1ns / 1ps

module montgomery_mult_seq_tb;

    reg clk;
    reg rst;
    reg [254:0] a, b;  // 255-bit test inputs
    wire [254:0] result;  // 255-bit output
    wire valid;

    // Instantiate the module
    montgomery_mult_seq uut (
        .clk(clk),
        .rst(rst),
        .a(a),
        .b(b),
        .result(result),
        .valid(valid)
    );

    // Clock generation: 10 ns period (toggle every 5 ns)
    initial begin
        clk = 0;
        forever #5 clk = ~clk;
    end

    initial begin
        // Initialize reset
        rst = 1;
        #10;
        rst = 0;

        // Test Case 2: a = b = 255'h7FFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFEC
        a = 255'h7FFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFEB;
        b = 255'h7FFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFEC;

        // Wait until the module asserts 'valid'
        wait(valid);
        #10;
        $display("Test: a * b mod P = %h", result);
        $finish;
    end

endmodule
