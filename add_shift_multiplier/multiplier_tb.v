//Description: Multiplier testbench


module multiplier_tb ();

//input
reg start, reset, clk;
reg [7:0] a_in;
reg [7:0] b_in;

//output
wire [15:0] r_out;
wire ready;

//instantiating the DUT
add_shift_multiplier DUT (.start(start), .reset(reset), .clock(clk), .a_in(a_in), .b_in(b_in), .r(r_out), .ready(ready));

//generate clock
initial
    clk = 1'b0;

always 
    #10 clk = ~clk;

//initial block 1//
/*
dumpfile
dumpvar
monitor
*/
initial 
begin
    $dumpfile ("data.vcd");
    $dumpvars (0, multiplier_tb);
    $monitor("output = %h",r_out);
end

//initial block2//
/*
giving general stimulus
*/
initial
begin
    a_in = 8'h03;
    b_in = 8'h04;

    reset = 1'b0;
    start = 1'b0;

    #12
    reset = 1'b1;
    start = 1'b1;

    #20
    start = 1'b0;

    #250
    a_in = 8'h34;
    b_in = 8'h04;
    start = 1'b1;
    #30
    start = 1'b0;

end
initial
#1550 $finish;

endmodule
