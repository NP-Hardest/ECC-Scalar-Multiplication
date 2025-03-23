`timescale 1ns/1ps
module tb_ff_inv_seq_255;

    reg         clk;
    reg         rst;
    reg [254:0] a;
    wire [254:0] inv;
    wire        valid;
    reg [509:0] prod;
    reg [255:0] rem;
    
    ff_inv_seq_255 uut (
        .clk(clk),
        .rst(rst),
        .a(a),
        .inv(inv),
        .valid(valid)
    );
    
    parameter [254:0] P_255 = ({1'b1, 255'b0} - 19);
    parameter [255:0] P     = {1'b0, P_255};  

    initial begin
        clk = 0;
        forever #5 clk = ~clk;
    end

    initial begin
        rst = 1;
        a   = 0;
        #20;
        rst = 0;
        #10;
        
        a = 255'd18271;
        $display("Test 1: Applying a = %d", a);
        
        wait(valid == 1);
        #5;  // Ensure outputs are stable.
        
        $display("Test 1 Results:");
        $display("  Input a          = %d", a);
        $display("  Computed inverse = %d", inv);
        
        prod = a * inv;   // Direct multiplication for verification.
        rem = prod % P;
        $display("  a * inv mod P  = %h", rem);
        if (rem == 256'd1)
            $display("  Inversion correct: PASSED!\n");
        else
            $display("  Inversion incorrect: FAILED!\n");
        
        #20;
        
        a = 255'd0;
        #10;
        
        a = 255'd54321;
        $display("Test 2: Changing input to a = %d", a);
        
        wait(valid == 1);
        #5; // Small delay
        
        $display("Test 2 Results:");
        $display("  Input a          = %d", a);
        $display("  Computed inverse = %d", inv);
        
        prod = a * inv;
        rem = prod % P;
        $display("  a * inv mod P  = %h", rem);
        if (rem == 256'd1)
            $display("  Inversion correct: PASSED!\n");
        else
            $display("  Inversion incorrect: FAILED!\n");
        
        #20;
        $finish;
    end

endmodule
