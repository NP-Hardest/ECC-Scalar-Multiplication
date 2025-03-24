/////////////////////////////////////////////////// 264x256 sequential multiplier using 24 * 16 multipliers ///////////////////////////////////////////////////

module multiplier_256bit (clk, rst, start, a, b, valid, product);
    input              clk;
    input              rst;    
    input              start;  
    input      [263:0] a;      // 264-bit operand a (11 segments of 24 bits)
    input      [255:0] b;    
    output reg         valid;  
    output reg [519:0] product; //520 bit product - > note that only 512 LSBs are relevant for 256 bit multiplication

    parameter IDLE = 2'd0;
    parameter COMPUTE = 2'd1;
    parameter DONE = 2'd2;

    reg [1:0] state;


    reg [3:0] i;
    reg [3:0] j;

    wire [23:0] a_seg = a[24*i +: 24];                     //current operands
    wire [15:0] b_seg = b[16*j +: 16];

    wire [39:0] mult_result = a_seg * b_seg;      //simple 24*16 bit continuous multiplication -> output is 40 bits wide


    wire [519:0] shifted_partial = ({{480{1'b0}}, mult_result} << (24*i + 16*j));        //placing the calculated 40 bit product in the right place


    always @(posedge clk) begin
      if(rst) begin
        state <= IDLE;
        i <= 0;
        j <= 0;
        product <= 0;
        valid <= 0;
      end 
      else begin
        case (state)
          IDLE: begin
            valid <= 0;
            if(start) begin
              state <= COMPUTE;
              i <= 0;
              j <= 0;
              product <= 0;
            end
          end

          COMPUTE: begin
            product <= product + shifted_partial; 
            if (j==15) begin                    
              if (i==10)                    //all 11 segments of a are also done, so we stop
                state <= DONE;
              else begin
                i <= i + 1;                       // next seg of a if j is 15 i.e. j is at the MSB
                j <= 0;
              end
            end else begin
              j <= j + 1;                         // next segment of 'b'.
            end
          end

          DONE: begin
            valid <= 1;       //assert valid when done
            if(!start) state <= IDLE;
          end

          default: state <= IDLE;
        endcase
      end
    end

endmodule
