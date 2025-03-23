`timescale 1ns / 1ps

module ffm_tb;

    reg clk;
    reg rst;
    reg [254:0] a, b;   // 255-bit test inputs
    wire [254:0] result; 
    wire valid;
    reg start;

    ffm uut(clk, rst, start, a, b, result, valid);

    reg [31:0] cycle_count;

    initial begin
        clk = 0;
        forever #5 clk = ~clk;  
    end

    // Test Sequence
    initial begin
        rst = 1;
        cycle_count = 0;
        #10;
        rst = 0;
        start = 1;

        a = 255'd33;
        b = 255'd33;
      //   a = 255'h7FFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFEB;
      //   b = 255'h7FFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFEC;
      
        wait(valid);
        // #10;
        $display("Test: a * b mod P = %d", result);
        // $display("Total clock cycles from start to valid: %d", cycle_count);
        // #20
        //         a = 255'h7FFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFEB;
        // b = 255'h7FFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFEC;

        //         wait(valid);
        // // #10;
        // $display("Test: a * b mod P = %h", result);

        // #10000;
        $finish;
    end

    // Clock Cycle Counter
    // always @(posedge clk) begin
    //     if (!rst) begin
    //         cycle_count <= cycle_count + 1;
    //     end
    // end



endmodule
