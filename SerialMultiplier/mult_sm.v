`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date:    20:15:46 05/13/2023 
// Design Name: 
// Module Name:    mult_sm 
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



module mult_sm(input[7:0] mult_length,input clk,rst,ctrl,output reg[5:0] shift_count, output length_bit,multiplier_bit,multiplicand_bit);
parameter [3:0] IDLE          = 4'b0001 ;
parameter [3:0] LENGTH_BIT_ST  = 4'b0010 ;
parameter [3:0] MULT1_BIT_ST  = 4'b0100 ;
parameter [3:0] MULT2_BIT_ST   = 4'b1000 ;


reg [3:0] state ;
reg [2:0] out;
always @(posedge clk) begin
	if (rst) begin
	state<=IDLE;
	out<=3'b000;
	shift_count<=0;
	end
	else begin

		case(state)
		IDLE :begin
		shift_count<=0;
			if (ctrl) begin
			state<=LENGTH_BIT_ST; 
			out<=3'b100; 
			end
			else state<=IDLE;
		end
		LENGTH_BIT_ST :begin
			shift_count<=shift_count+1;
			if (shift_count==8) begin
					if(shift_count>=(8+mult_length)) begin
					state<=MULT2_BIT_ST;
					out<=3'b001;
					end
					else begin
					state<=MULT1_BIT_ST; 
					out<=3'b010; 
					end
					end
			else state<=LENGTH_BIT_ST;
		end
		MULT1_BIT_ST :begin
			shift_count<=shift_count+1;
			if (shift_count==(8+mult_length)) begin 
			state<=MULT2_BIT_ST; 
			out<=3'b001; 
			end
			else state<=MULT1_BIT_ST;
		end
		MULT2_BIT_ST :begin
			shift_count<=shift_count+1;
		   if (shift_count==32) begin 
			state<=IDLE;

			out<=3'b000; 
			end
			else state<=MULT2_BIT_ST;
		end
		endcase
	end
end

		assign {length_bit,multiplier_bit,multiplicand_bit}=out[2:0];

endmodule
