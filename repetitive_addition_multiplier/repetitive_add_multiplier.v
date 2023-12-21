//Description: Multisegment coding style, 
//active low reset,
//positive edge triggered,
//Multi segment coding style

module multiplier_repad(r, ready, clock, reset, start, a_in, b_in);
//inputs
input clock;            //system clock
input reset;            //active low reset
input start;            //command to start operation
input [7:0] a_in;       //Multiplicand/Multiplier
input [7:0] b_in;       //Multiplicand/Multiplier

//output
output ready;           //asserted when the system is idle
output [15:0] r;               //product of a_in and b_in

//states
parameter IDLE = 2'b00;
parameter AB0 = 2'b01;
parameter LOAD = 2'b10;
parameter OP = 2'b11;

//*control path*//

reg [1:0] state;
reg [1:0] state_next;

//state register
always @(posedge clock , negedge reset)//review the sensitivity list
begin
    if(~reset)
        state <= IDLE;
    else    
        state <= state_next;
end

//next state
always @(state, start, reset, n_next)//review the sensitivity list
begin
    if(~reset)
        state_next <= IDLE;
    else
    begin
        case (state)
        IDLE: begin
            if(start)
            begin
                if((~|a_in)|(~|b_in))
                    state_next <= AB0;
                else
                    state_next <= LOAD;
            end    
        end
        AB0: state_next <= IDLE;
        LOAD:state_next <= OP;
        OP: begin
            if(~|n_next)
                state_next<= IDLE;
        end
        default: state_next<= IDLE;
        endcase
    end
end

//ouput
assign ready = ~|state ;

//*data path*//

//registers

reg [7:0] a;    //a register
reg [7:0] n;    //counter
reg [15:0] r;  

reg [7:0] a_next;
reg [7:0] n_next;
reg [15:0] r_next;


always @(posedge clock,negedge reset)//review the sensitivity list
begin
    if(~reset)
    begin
        a <= 8'h00;
        n <= 8'h00;
        r <= 16'h0000;
    end
    else
    begin
        a <= a_next;
        n <= n_next;
        r <= r_next;
    end
end

//routing and multiplexing

always @(state, start,a,n,subtract_out, add_out)//review the sensitivity list
begin
    case (state)
    AB0: begin
        a_next <= a;
        n_next <= n;
        r_next <= 16'h0000;
    end
    LOAD: begin
        a_next <= a_in;
        n_next <= b_in;
        r_next <= 16'h0000;
    end
    OP: begin
        a_next <= a;
        n_next <= subtract_out;
        r_next <= add_out;
    end
    default: begin
        a_next <= a;
        n_next <= n;
        r_next <= r;
    end
    endcase

end

//functional block
wire [7:0] subtract_out;
assign subtract_out = n - 1;
wire [15:0] add_out;
assign add_out = r + {8'h00,a};

wire test;
assign test = ~|n_next;
endmodule


/*
//changes in code if we share the same adder for decrementing and addition
// one more state will be added

wire [15:0] adder_src1, adder_src2;

assign adder_src1 = ((!state[2])&(state[1])&(state[0]))? r:{8'h00,n};
assign adder_src2 = ((!state[2])&(state[1])&(state[0]))? {8'h00,a}:16'hFFFF ;
assign adder_out = adder_src1 + adder_src2;*/