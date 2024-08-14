module mult_4x4(
input reset,clk,
input [3:0] A,B,
output [7:0] O, // 8-bits output
output Finish, output[7:0] count);
reg [7:0] O;
wire Finish;
reg [3:0] State; // state machine
reg [8:0] ACC; // Accumulator
reg [7:0] count;

initial
begin
	count = 0;
end

// logic to create 2 phase clocking when starting
assign Finish = (State === 0)? 1 : 0; // Finish Flag
always@(posedge clk, A,B)
	begin
		count <= count + 1;
		if(reset)
			begin
				count <= 0;
				State <= 0;
				ACC <= 0;
				O <= 0;
			end
		else if (State==0)
			begin
				ACC[8:4] <= 8'b0; // begin cycle
				ACC[3:0] <= A; // Load A (one of our inputs)
				State <= 1;
			end
		else if (State==1 || State == 3 || State == 5 || State == 7)
			// add/shift State
			begin
				if(ACC[0] == 1'b1)
					begin // add multiplicand
						ACC[8:4] <= {1'b0,ACC[7:4]} + B;
						State <= State + 1;
					end
				else
					begin
						ACC <= {1'b0, ACC[8:1]}; // shift right
						State <= State + 2;
					end
				end
				
				else if(State == 2 || State == 2 || State == 6 || State == 8)
					// shift State
					begin
						ACC <= {1'b0,ACC[8:1]}; // shift right
						State <= State + 1;
					end
				else if(State == 9 ) // What state for end?
					begin
					//State <= 0;
					O = ACC[7:0]; // loading data of accumulator in output
					State = 0;
					end
			end
endmodule

module stimulus;

reg [3:0] Multiplier, Multiplicand;
wire [7:0] Output;
reg clk;
reg reset;
wire Finish;
wire [7:0] count;

mult_4x4 multiplier(reset, clk, Multiplier, Multiplicand, Output, Finish, count);

initial
begin
	clk = 1'b0;
end

always@(*)
	#1 clk <= ~clk;
initial
begin
	$dumpfile("mult_4x4.vcd");
	$dumpvars(0, stimulus);
end

initial
begin
	$monitor($time, "	Inputs A: %d, B = %d, Product = %d\n", Multiplier, Multiplicand, Output);
end

initial
begin
	reset = 1;
	wait(Finish);
	reset = 0; Multiplicand = 4'b0000; Multiplier = 4'b0000;
	wait(Finish);

	#2 reset = 1;
	#2 reset = 0; Multiplicand = 4'b0011; Multiplier = 4'b0101;
	#2;
	wait(Finish) #2 $display("The number of clock cycles is: %d \n", count); $finish;
end
endmodule
