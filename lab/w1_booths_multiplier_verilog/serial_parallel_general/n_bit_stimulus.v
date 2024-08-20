module stimulus;

    parameter WIDTH = 64; // Set WIDTH parameter here

    reg [WIDTH - 1:0] Multiplier, Multiplicand;
    wire [2*WIDTH - 1:0] Output;
    reg clk;
    reg reset;
    wire Finish;
    wire [2*WIDTH - 1:0] count;

    // Instantiate the mult_4x4 module with WIDTH parameter
    mult_4x4 #(
        .WIDTH(WIDTH)
    ) multiplier (
        .reset(reset),
        .clk(clk),
        .A(Multiplier),
        .B(Multiplicand),
        .O(Output),
        .Finish(Finish),
        .count(count)
    );

    initial begin
        clk = 1'b1;
    end

    always #1 clk = ~clk;

    initial begin
        $dumpfile("mult_4x4.vcd");
        $dumpvars(0, stimulus);
    end

    initial begin
        $monitor($time, " Inputs A: %d, B = %d, Product = %d\n", Multiplier, Multiplicand, Output);
    end

    initial begin
        reset = 1;
        wait(Finish);
        reset = 0; 
        Multiplicand = 0; 
        Multiplier = 0;
        wait(Finish);

        #2 reset = 1;
        #2 reset = 0; 
        Multiplicand = {(WIDTH/2){2'b01}}; 
        Multiplier = {(WIDTH/2){2'b01}};
	//Multiplicand = 4'b0110;
	//Multiplier = 4'b0011;
        #2;
        wait(Finish) 
        #2 $display("The number of clock cycles (including loading cycle) is: %d \n", count); 
        $finish;
    end
endmodule

