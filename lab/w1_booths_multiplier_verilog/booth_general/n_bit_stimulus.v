module stimulus;

parameter WIDTH = 16;

reg [WIDTH - 1:0] mc, mp;
wire [2*WIDTH - 1:0] prod;
reg clk, start;
wire finish;
wire [WIDTH - 1:0] A, M, Q, sum, diff;
wire [2*WIDTH - 1:0] clock;
initial
begin
	clk <= 1'b1;
end

always@(*)
	#1 clk <= ~clk;

booth_multiplier #(.WIDTH(WIDTH)) mult(prod, mp, mc, clk, start, finish, clock);

initial
begin
	$monitor($time, "Multiplier, Multiplicand, Product: %d %d %d \n", mp, mc, prod);
end

initial
begin
	mc = {(WIDTH/2){2'b01}}; mp = {(WIDTH/2){2'b01}};
	#2
	start = 1;
	#2 start = 0;
	wait(finish) #2 $display("Finished in%d clock cycles\n", clock - 1);

	mc = {(WIDTH/2){2'b01}}; mp = {(WIDTH/2){2'b01}};
	#2
	start = 1;
	#2 start = 0;
        wait(finish) #2 $display("Finished in%d clock cycles\n", clock); $finish; 
end
endmodule
