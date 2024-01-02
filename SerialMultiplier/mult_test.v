`timescale 1ns / 1ps

////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer:
//
// Create Date:   21:32:28 05/13/2023
// Design Name:   mult
// Module Name:   C:/Users/Mani/Desktop/LABS and PROJECTS/Sem 6/FPGA LAB/Multiplier/mult_test.v
// Project Name:  Multiplier
// Target Device:  
// Tool versions:  
// Description: 
//
// Verilog Test Fixture created by ISE for module: mult
//
// Dependencies:
// 
// Revision:
// Revision 0.01 - File Created
// Additional Comments:
// 
////////////////////////////////////////////////////////////////////////////////

module mult_test;

	// Inputs
	reg clk;
	reg in;
	reg ctrl;
	reg rst;
	reg[31:0] data;
	// Outputs
	wire[32:0] prod;
	integer i;
	// Instantiate the Unit Under Test (UUT)
	mult uut (
		.clk(clk), 
		.in(in), 
		.ctrl(ctrl), 
		.rst(rst), 
		.prod(prod)
	);

	initial begin
		// Initialize Inputs
		clk = 0;
		in = 0;
		ctrl = 0;
		rst = 1;
		data=32'b00000000010101010_1000101011_00001010;
		//										170*555_10bits=94350
		// Wait 100 ns for global reset to finish
		#100;
      rst=0;
		ctrl=1;
		#100 ctrl=0;
	end
	initial begin
		#100
		for (i=0;i<32;i=i+1) begin
		@(posedge clk) in=data[i];
		end
	end
   always #10 clk=~clk; 
endmodule

