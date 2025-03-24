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
        clk <= 0;
        forever #5 clk <= ~clk;  
    end

    initial begin
        rst <= 1;
        cycle_count <= 0;
        #10;
        rst <= 0;
        start <= 1;

        a <= 255'd33;
        b <= 255'd33;
      
        wait(valid);

        $display("a * b % P : %d", result);

        $finish;
    end

endmodule
