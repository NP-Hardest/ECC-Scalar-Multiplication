`timescale 1ns/1ps

module tb_ffaa;


  reg         clk, rst, start;
  reg [254:0] a, b;
  wire [254:0] out;
  wire        done;
  integer count; 

  ffs uut (clk, rst, start, a, b, out, done);


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
    
    a <= 44927731495623270119727621215091840270797887326986279676957494683529379806913;
    b <= 45965849458578823337785628114947185621072782472466027602082789798859530730301;
    
    start <= 1;
    #10;
    start <= 0;

    count = 0;
    while (done == 0) begin
      @(posedge clk);
      count <= count + 1;
    end
    
    $display("Clock cycles : %d", count);
    $display("a : %d", a);
    $display("b : %d", b);
    $display("Output : %d", out);
    
        #50;
    $finish;
  end

endmodule
