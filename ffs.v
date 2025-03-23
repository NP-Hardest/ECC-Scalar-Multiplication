module ffs (
    input  wire clk,
    input  wire rst,
    input  wire start,          
    input  wire [254:0] a,    
    input  wire [254:0] b,     
    output reg  [254:0] result, 
    output reg  valid          
);

    parameter [254:0] P = {1'b1, 255'b0} - 19;

    reg [255:0] diff;

    always @(posedge clk or posedge rst) begin
        if (rst) begin
            result <= 0;
            valid  <= 0;
            diff   <= 0;
        end else if (start) begin
            if (a >= b)
                diff = a - b;
            else
                diff = a + P - b;

            result <= diff[254:0];
            valid  <= 1;
        end else begin
            valid <= 0; 
        end
    end

endmodule