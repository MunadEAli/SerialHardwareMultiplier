`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date:    23:55:00 05/28/2023 
// Design Name: 
// Module Name:    data_module 
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
module io_module(
data_in, ctrl,clk,rst,data_out,set);
input ctrl,clk,rst;
input[7:0] data_in;
output [32:0] data_out;
output reg set;


reg rdy;
reg[31:0] shift,buffer;
reg[5:0] shift_count;
reg[2:0] press_count,state;

parameter [3:0] IDLE=4'b0001,READY=4'b0010,SHIFT=4'b0100;


always@(posedge ctrl or posedge rst) begin
if (rst) begin  
press_count<=0;
shift<=0;
//press_count<=4;
//shift<={4'd3,4'd5,8'd4};
end
else if (press_count<4) begin
shift[31:24]<=data_in;
shift[23:16]<=shift[31:24];
shift[15:8]<=shift[23:16];
shift[7:0]<=shift[15:8];
press_count<=press_count+1'b1;
end

end
always @(posedge clk) begin
 if (rst) begin
	state<=IDLE;
	shift_count<=0;
	rdy<=0;
	buffer<=32'b0;
	set<=0;
	end
 else begin
	 case (state)
		 IDLE: begin
			 if (press_count==4) begin
			 state<=READY;
			 rdy<=1'b1;
			 end
			 else state<=IDLE;
			 end
		READY: begin
			if (rdy) begin
			state<=SHIFT;
			set<=0;
			rdy<=0;
			buffer<=shift;
			end
			else state<=IDLE;
			end
		SHIFT: begin
			if (shift_count<33)begin
			state<=SHIFT;
			buffer<=buffer>>1'b1;
			shift_count<=shift_count+1;
			end
			else begin
			state<=IDLE;
			shift_count<=0;
			set<=1;
			end
			end
	
		endcase
		end
end

	mult multiplier(clk,buffer[0],rdy,rst, data_out);

//lcd_driver lcd(clk,rs,rw,e,d,memaddr,membus);
endmodule



 
//	LCD: begin
//			memaddr_buff1<=memaddr;
//			if(memaddr==5'd18) begin
//			state<=IDLE;
//			end
//			else if(memaddr==(memaddr_buff1+1))begin
//			membus<={4'd3,data_buff[32:29]};
//			data_buff<=data_buff<<3'd4;
//			end
//			end


