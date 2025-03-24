////////////////////////////////////////////////////simple 64 bit adder, subtractor modules////////////////////////////////////////////////////////

module simple_adder(a, b, cin, sum, cout);

    input [63:0] a,b;
    input cin;                          
    output [63:0] sum;
    output cout;

    assign {cout, sum} = a + b + cin;
endmodule

module simple_subtractor(a, b, bin, diff, bout);

    input [63:0] a,b;
    input bin;
    output [63:0] diff;
    output bout;

    assign {bout, diff} = a - b - bin;               
    
endmodule