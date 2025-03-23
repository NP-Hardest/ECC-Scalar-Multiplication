module tb_scalar_multiplication;

    // Inputs
    reg [254:0] k;
    reg [254:0] x_p;
    reg clk;
    reg rst;

    // Outputs
    wire [254:0] x_q;
    wire done;

    // Instantiate the scalar_multiplication module
    scalar_multiplication uut (
        .k(k),
        .x_p(x_p),
        .clk(clk),
        .rst(rst),
        .x_q(x_q),
        .done(done)
    );

    // Clock generation: 10ns period (50 MHz)
    always begin
        #5 clk = ~clk;
    end

    // Cycle counter: counts clock cycles after reset is deasserted
    reg [31:0] cycle_count;

    // Count clock cycles on every rising edge
    always @(posedge clk) begin
        if (rst)
            cycle_count <= 0;
        else
            cycle_count <= cycle_count + 1;
    end

    // Test procedure
    initial begin
        // Initialize inputs
        clk = 0;
        rst = 0;
        x_p = 255'd51787047396206507371575496351547757668573928710407442995900366718792724607247;
        k = 255'd45965849458578823337285628114947185621072782472466027602082789798859530730302;
        
        // Apply reset
        rst = 1;
        #100;
        rst = 0;

        // Wait for the done signal to be asserted
        wait(done);
        $display("Add Result: %d", x_q);
        $display("Total clock cycles from reset deassertion to done: %d", cycle_count);
        
        // Finish simulation
        $finish;
    end

endmodule
