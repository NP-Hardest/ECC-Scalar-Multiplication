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
        x_p = 255'd27217333943943358250627699745851211085341687489113481307182141596657422383470;
        k = 255'd7187934484075914689806751868628530730776826202169948535253281198454376860578;
        
        rst = 1;
        #100;
        rst = 0;

        wait(done);
        $display("x_q: %d", x_q);
        $display("Total clock cycles from reset deassertion to done: %d", cycle_count);
        
        $finish;
    end

endmodule
