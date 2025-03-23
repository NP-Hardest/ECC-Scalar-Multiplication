module tb_scalar_multiplication;

    reg [254:0] k;
    reg [254:0] x_p;
    reg clk;
    reg rst;

    wire [254:0] x_q;
    wire done;

    scalar_multiplication uut (
        .k(k),
        .x_p(x_p),
        .clk(clk),
        .rst(rst),
        .x_q(x_q),
        .done(done)
    );

    always begin
        #5 clk = ~clk;
    end

    reg [31:0] cycle_count;

    always @(posedge clk) begin
        if (rst)
            cycle_count <= 0;
        else
            cycle_count <= cycle_count + 1;
    end

    initial begin
        clk = 0;
        rst = 0;
        x_p = 255'd44927731495623270119727621215091840270797887326986279676957494683529379806913;
        k = 255'd45965849458578823337285628114947185621072782472466027602082789798859530730302;
        
        rst = 1;
        #100;
        rst = 0;

        wait(done);
        $display("Add Result: %d", x_q);
        $display("Total clock cycles from reset deassertion to done: %d", cycle_count);
        
        $finish;
    end

endmodule
