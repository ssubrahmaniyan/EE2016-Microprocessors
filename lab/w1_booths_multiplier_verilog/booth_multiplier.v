module alu(output [3:0] out, input [3:0] a, b, input cin);
assign out = a + b + cin;
endmodule

module booth_multiplier(output wire [7:0] product, input [3:0] Multiplier, Multiplicand, input clk, start, output finish, output [7:0] clock_count);

reg [3:0] A;
reg [3:0] M;
reg [3:0] Q;
reg Q1;
integer count;
wire [3:0] sum, diff;
reg [7:0] clock_count;
always@(posedge clk)
begin
	if(start)
	begin
        	A <= 4'b0;
        	Q1 <= 1'b0;
        	M <= Multiplicand;
        	Q <= Multiplier;
		clock_count <= 8'b0;
		count = 4;
	end
	else if(!finish)
	//else
	begin
		clock_count <= clock_count + 1;
		case({Q[0], Q1})
			2'b01: {A, Q, Q1} <= {sum[3], sum[3:0], Q[3:0]};
			2'b10: {A, Q, Q1} <= {diff[3], diff[3:0], Q[3:0]};
			default: {A, Q, Q1} <= {A[3], A, Q};
		endcase
		count = count - 1;
	end
end

alu adder(sum, A, M, 1'b0);
alu subtractor(diff, A, ~M, 1'b1);

assign product = {A, Q};
assign finish = (count == 0) ? 1 : 0;

endmodule

module stimulus;

reg [3:0] mc, mp;
wire [7:0] prod;
reg clk, start;
wire finish;
wire [3:0] A, M, Q, sum, diff;
wire [7:0] clock;
initial
begin
	clk <= 1'b0;
end

always@(*)
	#1 clk <= ~clk;

booth_multiplier mult(prod, mp, mc, clk, start, finish, clock);

initial
begin
	$monitor($time, "Multiplier, Multiplicand, Product: %b %b %b \n", mp, mc, prod);
end

initial
begin
	mc = 4'b1010; mp = 4'b0110;
	#2
	start = 1;
	#2 start = 0;
	wait(finish) #2 $display("Finished in%d clock cycles\n", clock);

	mc = 4'b1000; mp = 4'b0001;
	#2
	start = 1;
	#2 start = 0;
        wait(finish) #2 $display("Finished in%d clock cycles\n", clock); $finish; 
end
endmodule
