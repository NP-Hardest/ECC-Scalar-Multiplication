module ffa (
    input  wire clk,
    input  wire rst,
    input  wire start,         // Start signal to trigger addition
    input  wire [254:0] a,     // 255-bit input a
    input  wire [254:0] b,     // 255-bit input b
    output reg  [254:0] result,// 255-bit output (a+b mod P)
    output reg  valid          // Indicates when result is valid
);

    // P = 2^255 - 19
    parameter [255:0] P = {1'b1, 255'b0} - 19;

    // Use a 256-bit register for the sum in case of overflow.
    reg [255:0] sum;

    always @(posedge clk or posedge rst) begin
        if (rst) begin
            result <= 0;
            valid  <= 0;
            sum    <= 0; // Ensure sum is also initialized
        end else if (start) begin
            sum = a + b; // Perform addition
            // If the sum is at least P, perform a subtraction to reduce modulo P.
            if (sum >= P)
                result = sum - P;
            else
                result = sum[254:0];
            valid <= 1; // Set valid after the result is ready
        end else begin
            valid <= 0; // Ensure valid is low when no operation is performed
        end
    end

endmodule
