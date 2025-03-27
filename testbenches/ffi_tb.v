`timescale 1ns/1ps
module tb_ff_inv_seq_255;

    reg         clk;
    reg         rst;
    reg [254:0] a;
    wire [254:0] inv;
    wire        valid;
    reg [509:0] prod;
    reg [255:0] rem;
    
    ffi uut (clk, rst, start, a, inv, valid);

    parameter [254:0] P_255 <= ({1'b1, 255'b0} - 19);
    parameter [255:0] P <= {1'b0, P_255};  

    initial begin
        clk <= 0;
        forever #5 clk <= ~clk;
    end

    initial begin
        rst <= 1;
        a <= 0;
        #20;
        rst <= 0;
        #10;
        
        a <= 255'd18271;

        wait(valid == 1);
        
        $display("a = %d", a);
        $display("inverse = %d", inv);
        
        $finish;
    end

endmodule
