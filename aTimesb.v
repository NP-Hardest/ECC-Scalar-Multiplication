///////////////////////////////////////////////////
// 264x256 sequential multiplier using 24 * 16 multipliers
///////////////////////////////////////////////////

module mult256_seq (
    input              clk,
    input              rst,    // synchronous reset (active high)
    input              start,  // start signal (should be pulsed high)
    input      [263:0] a,      // 264-bit operand A (11 segments of 24 bits)
    input      [255:0] b,      // 256-bit operand B (16 segments of 16 bits)
    output reg         valid,  // asserted when multiplication is complete
    output reg [519:0] product // 520-bit product (264+256)
);

  localparam IDLE    = 2'd0,
             COMPUTE = 2'd1,
             DONE    = 2'd2;

  reg [1:0] state;

  // Counters for selecting slices.
  // i corresponds to the segment of 'a' (24-bit segments),
  // j corresponds to the segment of 'b' (16-bit segments).
  // i will run from 0 to 10 and j from 0 to 15.
  reg [3:0] i;
  reg [3:0] j;

  // Extract the segments.
  wire [23:0] a_seg = a[24*i +: 24];
  wire [15:0] b_seg = b[16*j +: 16];

  // 24x16 multiplication gives a 40-bit result.
  wire [39:0] mult_result = a_seg * b_seg;

  // Each partial product must be shifted left by (24*i + 16*j) bits.
  // Since product width is 520 bits and mult_result is 40 bits,
  // we pad it with 480 zeros on the left before shifting.
  wire [519:0] shifted_partial =
        ({ {480{1'b0}}, mult_result } << (24*i + 16*j) );

  // Sequential logic: state machine and accumulation.
  always @(posedge clk) begin
    if (rst) begin
      state   <= IDLE;
      i       <= 0;
      j       <= 0;
      product <= 0;
      valid   <= 0;
    end else begin
      case (state)
        IDLE: begin
          valid <= 0;
          if (start) begin
            state   <= COMPUTE;
            i       <= 0;
            j       <= 0;
            product <= 0;
          end
        end

        COMPUTE: begin
          product <= product + shifted_partial;  // Accumulate the partial product.
          if (j == 15) begin                      // Once all segments of 'b' are processed...
            if (i == 10)                        // ...and if the last segment of 'a' has been processed...
              state <= DONE;
            else begin
              i <= i + 1;                       // Move to the next 24-bit segment of 'a'.
              j <= 0;
            end
          end else begin
            j <= j + 1;                         // Next segment of 'b'.
          end
        end

        DONE: begin
          valid <= 1;

          if (!start)                           // Wait for 'start' to go low before returning to IDLE.
            state <= IDLE;
        end

        default: state <= IDLE;
      endcase
    end
  end

endmodule
