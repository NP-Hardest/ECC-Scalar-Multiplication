`timescale 1ns/1ps

module tb_ffa;

  reg         clk, rst, start;
  reg [255:0] a, b;
  wire [255:0] out;
  wire        done;
  integer count;  

  ffa uut (clk, rst, start, a, b, out, done);

  initial begin
    clk <= 0;
    forever #5 clk <= ~clk;
  end

  initial begin
    rst <= 1;
    start <= 0;
    a <= 256'h0;
    b <= 256'h0;
    count <= 0; 
    
    #15;
    rst <= 0;
    #10;
    
    a <= 10;
    b <= 15;
    start <= 1;
    #10;
    start <= 0;

    count <= 0;
    while (done == 0) begin
      @(posedge clk);
      count <= count + 1;
    end
    
    $display("Clock cycles: %d", count);
    $display("a : %h", a);
    $display("b : %h", b);
    $display("Output : %h", out);
    
    #50;
    $finish;
  end

endmodule
