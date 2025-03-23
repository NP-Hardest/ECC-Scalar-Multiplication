`timescale 1ns/1ps

module tb_ffaa;

  // Declare signals
  reg         clk, rst, start;
  reg [255:0] a, b;
  wire [255:0] out;
  wire        done;
  integer count;  // Cycle counter

  // Instantiate the ffaa module
  ffaa uut (
    .clk   (clk),
    .rst   (rst),
    .start (start),
    .a     (a),
    .b     (b),
    .out   (out),
    .done  (done)
  );

  // Clock generation: 10 ns period (100MHz)
  initial begin
    clk = 0;
    forever #5 clk = ~clk;
  end

  // Test sequence
  initial begin
    // Initialize signals
    rst   = 1;
    start = 0;
    a     = 256'h0;
    b     = 256'h0;
    count = 0;  // Initialize cycle counter
    
    // Hold reset for a few cycles
    #15;
    rst = 0;
    #10;
    
    // Apply test vectors
    a = 45965849458578823337285628114947185621072782472466027602082789798859530730302;
    b = 45965849458578823337785628114947185621072782472466027602082789798859530730302;
    
    // Start the operation
    start = 1;
    #10;
    start = 0;

    // Start counting cycles
    count = 0;
    while (done == 0) begin
      @(posedge clk);
      count = count + 1;
    end
    
    // Display the results
    $display("Test completed at time %0t", $time);
    $display("Clock cycles taken: %d", count);
    $display("Input a : %h", a);
    $display("Input b : %h", b);
    $display("Output  : %h", out);
    
    // End simulation after a short delay
    #50;
    $finish;
  end

endmodule
