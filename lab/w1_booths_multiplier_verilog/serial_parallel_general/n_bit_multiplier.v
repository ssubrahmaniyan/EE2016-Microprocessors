module mult_4x4 #(
    parameter WIDTH = 4  // Default WIDTH is 4, you can change it when instantiating
)(
    input reset,
    input clk,
    input [WIDTH - 1:0] A,
    input [WIDTH - 1:0] B,
    output reg [2*WIDTH - 1:0] O, // Output
    output Finish,
    output reg [2*WIDTH - 1:0] count
);
    localparam NUM_STATES = 2 * WIDTH + 1; // Number of states

    reg [8:0] State; // State machine, make sure it's wide enough
    reg [2*WIDTH:0] ACC; // Accumulator

    initial begin
        count = 0;
    end

    // Finish flag
    assign Finish = (State == 0) ? 1 : 0;

    always @(posedge clk) begin
        count <= count + 1;
        if (reset) begin
            count <= 0;
            State <= 0;
            ACC <= 0;
            O <= 0;
        end else if (State == 0) begin
            ACC[2*WIDTH:WIDTH] <= 0; // Begin cycle
            ACC[WIDTH - 1:0] <= A; // Load A (one of our inputs)
            State <= 1;
        end else if (State == NUM_STATES) begin
            // End state
            O = ACC[2*WIDTH - 1:0]; // Loading data of accumulator into output
            State <= 0;

	    //end else if (State == 1 || State == 3 || State == 5 || State == 7 || State == 9 || State == 11 || State == 13 || State == 15) begin
	end else if (State % 2 == 1) begin
            // Add/shift State
            if (ACC[0] == 1'b1) begin // Add multiplicand
                ACC[2*WIDTH:WIDTH] <= {1'b0, ACC[2*WIDTH - 1:WIDTH]} + B;
                State <= State + 1;
            end else begin
                ACC <= {1'b0, ACC[2*WIDTH:1]}; // Shift right
                State <= State + 2;
            end
        //end else if (State == 2 || State == 4 || State == 6 || State == 8 || State == 10 || State == 12 || State == 14 || State == 16) begin
	end else if(State % 2 == 0) begin
            // Shift State
            ACC <= {1'b0, ACC[2*WIDTH:1]}; // Shift right
            State <= State + 1;
        end
    end
endmodule

