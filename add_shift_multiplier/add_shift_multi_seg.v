//Description: Add and Shift Multiplier
//Multi Segment Architecture
//Active low reset
//Negedge triggered

module add_shift_multiplier(r, ready, clock, reset, a_in, b_in, start);

//input 
input clock;            //system clock
input reset;            //Active low reset
input [7:0] a_in;       //Multiplicand
input [7:0] b_in;       //Multiplier
input start;            //Signal to start operation

//output 
output [15:0] r;        //product
output ready;           //multiplier is idle

//parameters
parameter idle= 2'b00;
parameter shift= 2'b01;
parameter add = 2'b10;

//*control path*//

//state register
reg [1:0] state;
reg [1:0] state_next;

always @(negedge clock, negedge reset)
begin
    if(~reset)
        state <= idle;
    else
        state <= state_next;
end

//next state logic

always @(state, start, b, n_next, b_next)//update the sensitivity list
begin
    case (state)
    idle: begin
        if(start)
        begin
            if(b_in[0])
                state_next <= add;
            else
                state_next <= shift;
        end
    end
    add: state_next <= shift;
    shift: begin
        if(n_next)
        begin
            if(b_next[0])
                state_next <= add;
            else
                state_next <= shift;
        end
        else
            state_next <= idle;
    end
    default: state_next <= state;
    endcase
end

//output logic
assign ready = ~|state;

//*data path*//

//data register

reg [15:0] a;
reg [7:0] b;
reg [3:0] n;            //Number of bits in multiplier and multiplicand
reg [15:0] r;
reg [15:0] a_next;
reg [7:0] b_next;
reg [3:0] n_next;            //Number of bits in multiplier and multiplicand
reg [15:0] r_next;

always @(negedge clock, negedge reset)
begin
    if(~reset)
    begin
        a <= 16'h0000;
        b <= 8'h00;
        n <= 4'h8;
        r <= 16'h0000;
    end
    else
    begin
        a <= a_next;
        b <= b_next;
        n <= n_next;
        r <= r_next;
    end
end

//routing and multiplexing circuit and functional units

always @(state, start, a, b, r, n) // update the sensitivity list
begin
    case (state)
    idle:begin
        if(start)
        begin
            a_next <= a_in;
            b_next <= b_in;
            n_next <= 4'h8;
            r_next <= 16'h0000;
        end

    end
    add: begin
        a_next <=a;
        b_next <= b;
        n_next <= n;
        r_next <= r+a;
    end
    shift: begin
        a_next <= a<<1;
        b_next <= b>>1;
        n_next <= n-1;
        r_next <= r;
    end
    default: begin
        a_next <= a;
        b_next <= b;
        n_next <= n;
        r_next <= r; 
    end 
    endcase
end


endmodule