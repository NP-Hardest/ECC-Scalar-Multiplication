`timescale 1ns/1ps

module tb_ffaa;


  reg         clk, rst, start;
  reg [255:0] a, b;
  wire [255:0] out;
  wire        done;
  integer count; 



  ffss uut (
    .clk   (clk),
    .rst   (rst),
    .start (start),
    .a     (a),
    .b     (b),
    .out   (out),
    .done  (done)
  );


  initial begin
    clk = 0;
    forever #5 clk = ~clk;
  end


  initial begin

    rst   = 1;
    start = 0;
    a     = 256'h0;
    b     = 256'h0;
    count = 0;  
    
    #15;
    rst = 0;
    #10;
    
    a = 45965849458578823337285628114947185621072782472466027602082789798859530730302;
    b = 45965849458578823337785628114947185621072782472466027602082789798859530730301;
    
    start = 1;
    #10;
    start = 0;

    count = 0;
    while (done == 0) begin
      @(posedge clk);
      count = count + 1;
    end
    
        $display("Test completed at time %0t", $time);
    $display("Clock cycles taken: %d", count);
    $display("Input a : %d", a);
    $display("Input b : %d", b);
    $display("Output  : %d", out);
    
        #50;
    $finish;
  end

endmodule
