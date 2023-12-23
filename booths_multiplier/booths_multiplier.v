//Description: Booths Multiplier
//Negedge triggered
//Active low reset
//Multi segment coding style

module booths_multiplier(

//input 
input clk,              //clock
input reset,            //active low reset (use reset_n next time for active low reset)
input start,           // command to start the multiplication operation
input [7:0] a_in,       //Multiplicand/ Multiplier
input [7:0] b_in,      //Multiplicand/ Multiplier

//output
output [15:0] r_out,    //Product   
output ready        //Asserted when the multiplier is ready for new request
);
//parameters
parameter idle = 2'b00;
parameter shift = 2'b01;
parameter add = 2'b10;

//*control_path*//

//state register
reg [1:0] state;
reg [1:0] state_next;

always @ (negedge clk, negedge reset)
begin
    if(~reset)
        state<= idle;
    else    
        state <= state_next;
end


//next state logic
//data registers
reg [7:0] Q;    //Multiplicand
reg [7:0] A;    //Accumalator
reg q;          //Q[-1]    
reg [3:0] n;    //Bit width (no of iterations, need to be rechecked)
reg [7:0] Q_next;    
reg [7:0] A_next;    
reg q_next;          
reg [3:0] n_next;    
reg [7:0] M;    //Multiplier

always @(state, start, Q, Q_next, q_next, q)//update the sensitivity list
begin
    case (state)
    idle: begin
        if(start)
        begin
            if(a_in[0]^1'b0)
                state_next <= add;
            else    
                state_next <= shift;
        end
    end
    shift: begin
        if(n_next == 4'b0)
            state_next <= idle;
        else
        begin
            if(Q_next[0]^q_next)
                state_next <= add;
            else    
                state_next <= shift;
        end 
    end
    add: 
        state_next <= shift;
    default:
        state_next <= idle;
    endcase
end

//output logic
assign ready = ~|state;

//*data path*//

//data registers

always @(negedge clk, negedge reset)
begin
    if(~reset)
    begin
        Q <= 8'bx;
        A <= 8'b0;
        q <= 1'bx;
        n <= 4'd8;

        // Q <= 8'bz;
        // A <= 8'b0;
        // q <= 1'b0;
        // n <= 4'd8;

    end
    else
    begin
        Q <= Q_next;
        A <= A_next;
        q <= q_next;
        n <= n_next;
    end
end

//routing and multiplexing circuit and functional units

always @(state, start, A, Q, q, n) // update the sensitivity list
begin
    case (state)
    idle:begin
        if(start)
        begin
            Q_next <= a_in;
            M <= b_in;
            A_next <= 8'b0;
            q_next <= 1'b0;
            n_next <= 4'd8;
        end
    end
    add: begin
        if({Q[0],q} == 2'b10)
            A_next <= A-M;
        else 
            A_next <= A+M;
    end
    shift: begin
        {A_next,Q_next,q_next} <= {A[7], A, Q};
        n_next <= n -1;
    
    end
    endcase
end

//Assign Output

assign r_out = {A,Q};


endmodule