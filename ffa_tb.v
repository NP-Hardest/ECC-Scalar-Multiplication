`timescale 1ns/1ps

module tb_ff_add_255();

    // Clock and reset signals.
            localparam [254:0] P = {1'b1, 255'b0} - 19;
    reg clk;
    reg rst;

    // 255-bit inputs.
    reg [254:0] a;
    reg [254:0] b;

    // Output from the adder.
    wire [254:0] result;
    wire         valid;
    
    // Expected result (for comparison).
    reg [254:0] expected;

    // Instantiate the finite field adder.
    ff_add_255 adder_inst (
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
        // Test Vector 1: a = 10, b = 20, expected = 30 mod P.
        a = 255'd10;
        b = 255'd20;
        expected = 255'd30;
        #10;
        // Wait for valid flag.
        wait(valid);
        if (result !== expected) begin
            $display("Adder Test 1 FAILED: a=%d, b=%d, expected=%d, got=%d", a, b, expected, result);
            $stop;
        end else begin
            $display("Adder Test 1 PASSED.");
        end
        
        // ----------------------------------------------------
        // Test Vector 2: a = 2^254, b = 1. Since P = 2^255 - 19 and 2^254+1 < P, expected = a + b.
        a = 0; 
        a[254] = 1'b1;  // a = 2^254.
        b = 255'd1;
        expected = a + b;
        #10;
        wait(valid);
        if (result !== expected) begin
            $display("Adder Test 2 FAILED: a=%h, b=%d, expected=%h, got=%h", a, b, expected, result);
            $stop;
        end else begin
            $display("Adder Test 2 PASSED.");
        end
        
        // ----------------------------------------------------
        // Test Vector 3: a = P - 1, b = 2. Expected: (P - 1 + 2) mod P = 1.

        a = P - 1;
        b = 4686;
        expected = 255'd4685;
        #10;
        wait(valid);
        if (result !== expected) begin
            $display("Adder Test 3 FAILED: a=%h, b=%d, expected=%d, got=%d", a, b, expected, result);
            $stop;
        end else begin
            $display("Adder Test 3 PASSED.");
        end

        $display("All finite field adder tests PASSED.");
        $finish;
    end

endmodule
