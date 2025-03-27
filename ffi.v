////////////////////////////////////////////////FINITE FIELD INVERSION MODULE USING EEA as given in slides////////////////////////////////////////////////////////////////////////
module ffi(clk, rst, start, a, inv, valid);
    input clk;
    input rst;
    input start;
    input [254:0] a;
    output reg [254:0] inv;   
    output reg valid;

    parameter [254:0] P_255 = ({1'b1, 255'b0} - 19);
    parameter [255:0] P = {1'b0, P_255}; 

    parameter IDLE = 2'd0, PROCESS = 2'd1, DONE = 2'd2;

    reg [1:0] state;

    reg [255:0] u, v, x_1, x2;
    
    always @(posedge clk or posedge rst) begin
        if (rst) begin
            state  <= IDLE;
            valid  <= 1'b0;
            inv <= {255{1'b0}};
            u <= 256'd0;
            v <= 256'd0;
            x_1 <= 256'd0;
            x2 <= 256'd0;
        end 
        else begin
            case (state)
                IDLE: begin
                    if (start) begin
                        valid <= 1'b0;
                        u <= {1'b0, a};
                        v <= P;
                        x_1 <= 256'd1;
                        x2 <= 256'd0;
                        state <= PROCESS;
                    end
                end

                PROCESS: begin

                    //at any step we can write u = aA  + PB, v = aC + PD  (choosing B=D=0).
                    // so when one of them becomes one, the corresponding dummy variable is the modular inverse.
                    if ((u == 256'd1)||(v == 256'd1)) begin
                        state <= DONE;
                    end 
                    else begin
                        if (~u[0]) begin            // while u is even (LSB zero)
                            u <= u >> 1;
                            if (x_1[0] == 1'b0)
                                x_1 <= x_1 >> 1;
                            else
                                x_1 <= (x_1 + P) >> 1;
                        end
                        else if (~v[0]) begin               // while v is even (LSB zero)
                            v <= v >> 1;
                            if (x2[0] == 1'b0)
                                x2 <= x2 >> 1;
                            else
                                x2 <= (x2 + P) >> 1;
                        end
                        else if (u >= v) begin
                            u <= u - v;
                            if (x_1 >= x2)
                                x_1 <= x_1 - x2;
                            else
                                x_1 <= x_1 + P - x2;
                        end 
                        else begin // v > u
                            v <= v - u;
                            if (x2 >= x_1)
                                x2 <= x2 - x_1;
                            else
                                x2 <= x2 + P - x_1;
                        end
                    end
                end

                DONE: begin
                    if (u == 256'd1) inv <= x_1[254:0];  
                    else inv <= x2[254:0];
                    valid <= 1'b1;
                    state <= IDLE;  
                end

            endcase
        end
    end

endmodule
