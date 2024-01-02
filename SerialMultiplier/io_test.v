`timescale 1ns / 1ps

////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer:
//
// Create Date:   17:19:48 05/30/2023
// Design Name:   io_module
// Module Name:   C:/Users/Mani/Desktop/LABS and PROJECTS/Sem 6/FPGA LAB/Multiplier/io_test.v
// Project Name:  Multiplier
// Target Device:  
// Tool versions:  
// Description: 
//
// Verilog Test Fixture created by ISE for module: io_module
//
// Dependencies:
// 
// Revision:
// Revision 0.01 - File Created
// Additional Comments:
// 
////////////////////////////////////////////////////////////////////////////////

module io_test;

	// Inputs
	reg [7:0] data_in;
	reg ctrl;
	reg clk;
	reg rst;
	reg[31:0] data=32'b00000000010101010_1000101011_00001010;
	// Outputs
	wire [32:0] data_out;

	// Instantiate the Unit Under Test (UUT)
	io_module uut (
		.data_in(data_in), 
		.ctrl(ctrl), 
		.clk(clk), 
		.rst(rst), 
		.data_out(data_out)
	);
integer i=0;
	initial begin
		// Initialize Inputs
		data_in = 0;
		ctrl = 0;
		clk = 0;
		rst = 1;
		
		// Wait 100 ns for global reset to finish
		#40;
      rst=0; 
		// Add stimulus here
		for (i=0;i<32;i=i+8) begin
		data_in=data[7:0];
		#100 ctrl=1;
		#30 ctrl=0;
		data=data>>8;
		end
	end
	always #10 clk=~clk;
      
endmodule

