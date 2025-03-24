module four_to_one_mux(a, b, c, d, out, sel);               //4x1 mux for adder, subtractor

    input [254:0] a, b , c, d;
    output reg [254:0] out;
    input [1:0] sel;
    always@(*) begin
        case(sel) 
            2'b00: out <= a;
            2'b01: out <= b;
            2'b10: out <= c;
            2'b11: out <= d;
            default: out <= 255'b0;
        endcase
    end
endmodule

module eleven_to_one_mux(a1, a2, a3, a4, a5, a6, a7, a8, a9, a10, a11, out, sel);   

    input [254:0] a1, a2, a3, a4, a5, a6, a7, a8, a9, a10, a11;         //11x1 mux for multiplier
    output reg [254:0] out;
    input [3:0] sel;
    always@(*) begin
        case(sel) 
            4'b0000: out <= a1;
            4'b0001: out <= a2;
            4'b0010: out <= a3;
            4'b0011: out <= a4;
            4'b0100: out <= a5;
            4'b0101: out <= a6;
            4'b0110: out <= a7;
            4'b0111: out <= a8;
            4'b1000: out <= a9;
            4'b1001: out <= a10;
            4'b1010: out <= a11;
            default: out <= 255'b0;
        endcase
    end
endmodule



