`timescale 1ns / 1ps

module montgomery_mult_seq (
    input  wire clk,
    input  wire rst,
    input  wire [254:0] a,      // 255-bit input a
    input  wire [254:0] b,      // 255-bit input b
    output reg  [254:0] result, // 255-bit output (a*b mod P)
    output reg  valid          // Indicates when result is valid
);
   
    parameter P = 255'h7FFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFED;         // Define the prime P = 2^255 - 19


    wire [509:0] product;                           // 510-bit product: 255+255 bits
    assign product = a * b;


    wire [254:0] X_L, X_H;                                  // Split product into lower and higher 255 bits
    assign X_L = product[254:0];
    assign X_H = product[509:255];

    
    wire [259:0] X_H_ext = {5'b0, X_H};  // 255-bit X_H extended to 260 bits
    wire [259:0] X_L_ext = {5'b0, X_L};  // 255-bit X_L extended to 260 bits

    // Multiply X_H by 19 using addition and shift.
    // 19 = 16 + 2 + 1, so:
    // 19 * X_H = (X_H << 4) + (X_H << 1) + X_H.
    wire [259:0] X_H_times_19 = (X_H_ext << 4) + (X_H_ext << 1) + X_H_ext;
    wire [259:0] initial_sum = X_L_ext + X_H_times_19;                        // Compute initial sum: note that multiplication by 19 is a small constant multiply.


    reg [259:0] temp;                                   // FSM for iterative reduction: subtract P until the value is less than P.
    reg [1:0] state;
    localparam IDLE = 2'd0, SUBTRACT = 2'd1, DONE = 2'd2;

    always @(posedge clk or posedge rst) begin
        if (rst) begin
            state  <= IDLE;
            temp   <= 0;
            result <= 0;
            valid  <= 0;
        end 
        else begin
            case (state)
                IDLE: begin
                    temp  <= initial_sum;
                    valid <= 0;
                    state <= SUBTRACT;
                end
                SUBTRACT: begin
                    if (temp >= P)
                        temp <= temp - P;
                    else
                        state <= DONE;
                end
                DONE: begin
                    result <= temp[254:0];  // Final result reduced to 255 bits
                    valid  <= 1;
                    state  <= IDLE;  // Return to IDLE for next operation (or hold if desired)
                end
                default: state <= IDLE;
            endcase
        end
    end
endmodule
