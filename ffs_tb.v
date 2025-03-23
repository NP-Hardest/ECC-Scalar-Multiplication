`timescale 1ns/1ps

module tb_ff_sub_255();
            localparam [254:0] P = {1'b1, 255'b0} - 19;
    // Clock and reset signals.
    reg clk;
    reg rst;

    // 255-bit inputs.
    reg [254:0] a;
    reg [254:0] b;

    // Output from the subtractor.
    wire [254:0] result;
    wire         valid;
    
    // Expected result (for comparison).
    reg [254:0] expected;

    // Instantiate the finite field subtractor.
    ff_sub_255 sub_inst (
        .clk(clk),
        .rst(rst),
        .a(a),
        .b(b),
        .result(result),
        .valid(valid)
    );
    
    // Clock generation: period = 10 ns.
    initial begin
        clk = 0;
        forever #5 clk = ~clk;
    end

    // Test sequence.
    initial begin
        // Assert reset.
        rst = 1;
        a = 0;
        b = 0;
        #10;
        rst = 0;
        #10;
        
        // ----------------------------------------------------
        // Test Vector 1: a = 20, b = 10, expected = 10 mod P.
        a = 255'd20;
        b = 255'd10;
        expected = 255'd10;
        #10;
        wait(valid);
        if (result !== expected) begin
            $display("Subtractor Test 1 FAILED: a=%d, b=%d, expected=%d, got=%d", a, b, expected, result);
            $stop;
        end else begin
            $display("Subtractor Test 1 PASSED.");
        end
        
        // ----------------------------------------------------
        // Test Vector 2: a = 1, b = 2. Since a < b, expected = (a + P - b) mod P = P - 1.

        a = 255'd1;
        b = 255'd2;
        expected = P - 1;
        #10;
        wait(valid);
        if (result !== expected) begin
            $display("Subtractor Test 2 FAILED: a=%d, b=%d, expected=%h, got=%h", a, b, expected, result);
            $stop;
        end else begin
            $display("Subtractor Test 2 PASSED.");
        end
        
        // ----------------------------------------------------
        // Test Vector 3: a = 2^254, b = 1. Expected: a - 1.
        a = 0;
        a[254] = 1'b1;  // a = 2^254.
        b = 255'd1;
        expected = a - 255'd1;
        #10;
        wait(valid);
        if (result !== expected) begin
            $display("Subtractor Test 3 FAILED: a=%h, b=%d, expected=%h, got=%h", a, b, expected, result);
            $stop;
        end else begin
            $display("Subtractor Test 3 PASSED.");
        end
        
        $display("All finite field subtractor tests PASSED.");
        $finish;
    end

endmodule
