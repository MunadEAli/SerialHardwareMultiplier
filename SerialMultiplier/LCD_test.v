`timescale 1ns / 1ps

////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer:
//
// Create Date:   19:13:37 05/30/2023
// Design Name:   IO_w_LCD
// Module Name:   C:/Users/Mani/Desktop/LABS and PROJECTS/Sem 6/FPGA LAB/Multiplier/LCD_test.v
// Project Name:  Multiplier
// Target Device:  
// Tool versions:  
// Description: 
//
// Verilog Test Fixture created by ISE for module: IO_w_LCD
//
// Dependencies:
// 
// Revision:
// Revision 0.01 - File Created
// Additional Comments:
// 
////////////////////////////////////////////////////////////////////////////////

module LCD_test;

	// Inputs
	reg clk;
	reg rst;
	reg ctrl;
	reg [7:0] data_in;

	// Outputs
	wire [3:0] d;
	wire rs;
	wire rw;
	wire e;
	wire sf_e;

	// Instantiate the Unit Under Test (UUT)
	IO_w_LCD uut (
		.clk(clk), 
		.rst(rst), 
		.ctrl(ctrl), 
		.data_in(data_in), 
		.d(d), 
		.rs(rs), 
		.rw(rw), 
		.e(e), 
		.sf_e(sf_e)
	);
	reg[31:0] data=32'b00000000010101010_1000101011_00001010;
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
		#30 ctrl=1;
		#30 ctrl=0;
		data=data>>8;
		end
	end
	always #10 clk=~clk;
      
endmodule

