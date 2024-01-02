`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date:    21:31:36 05/13/2023 
// Design Name: 
// Module Name:    mult 
// Project Name: 
// Target Devices: 
// Tool versions: 
// Description: 
//
// Dependencies: 
//
// Revision: 
// Revision 0.01 - File Created
// Additional Comments: 
//
//////////////////////////////////////////////////////////////////////////////////
module mult(input clk,in,ctrl,rst, output reg[32:0] prod);

reg[7:0] length;
wire[5:0] shift_count;
reg[31:0] mult1;
reg[32:0] prod_reg;
wire length_bit,multiplier_bit,multiplicand_bit;
reg inbuff;

always @(posedge clk) begin
	if (rst) begin
		length<=0;
		mult1<=0;
		prod_reg<=0;
		prod<=0;
		inbuff<=0;
	end
	else begin
		inbuff<=in;
		case ({length_bit,multiplier_bit,multiplicand_bit})
		3'b100: begin length[7:0]<={inbuff,length[7:1]}; end
		3'b010: begin	
			if(shift_count==(length+8))
			mult1<={inbuff,mult1[31:1]}>>(32-length);
			else
			mult1<={inbuff,mult1[31:1]};
			end
		3'b001: begin
			prod_reg<=prod_reg+ inbuff*(mult1);
			mult1<=mult1<<1;
			if (shift_count==32)begin
			prod<=prod_reg;
			prod_reg<=0;
			end
			end
		endcase
	end
end

mult_sm sm(length,clk,rst,ctrl,shift_count,length_bit,multiplier_bit,multiplicand_bit);
endmodule
