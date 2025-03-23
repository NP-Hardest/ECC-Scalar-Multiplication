module ffs (
    input  wire clk,
    input  wire rst,
    input  wire start,          // Start signal to enable computation
    input  wire [254:0] a,      // 255-bit input a
    input  wire [254:0] b,      // 255-bit input b
    output reg  [254:0] result, // 255-bit output (a-b mod P)
    output reg  valid           // Indicates when result is valid
);

    // P = 2^255 - 19
    parameter [254:0] P = {1'b1, 255'b0} - 19;

    // Use a 256-bit register to handle the subtraction and potential borrow.
    reg [255:0] diff;

    always @(posedge clk or posedge rst) begin
        if (rst) begin
            result <= 0;
            valid  <= 0;
            diff   <= 0;
        end else if (start) begin
            // If a is greater than or equal to b, the difference is non-negative.
            // Otherwise, add P to keep the result in [0, P-1].
            if (a >= b)
                diff = a - b;
            else
                diff = a + P - b;

            result <= diff[254:0];
            valid  <= 1;
        end else begin
            valid <= 0; // Keep valid low if no computation is performed
        end
    end

endmodule
