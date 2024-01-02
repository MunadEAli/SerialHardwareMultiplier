`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date:    17:41:45 05/30/2023 
// Design Name: 
// Module Name:    IO_w_LCD 
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
module IO_w_LCD(clk,rst,ctrl,data_in,
d,rs,rw,e,sf_e,LED
    );
input clk,rst,ctrl;
input[7:0] data_in;
output[3:0] d; 
output rs,rw,e,sf_e;
output reg[7:0] LED; 
reg [3:0] count;
reg[32:0] buffer;
reg[7:0] RAM[0:7],mem_bus;
reg[2:0] state;
wire[32:0] data_out_w;
wire set_w;
wire[4:0] mem_addr;

parameter[2:0]  IDLE=3'b001 , STORE=3'b010 , LCD=3'b100;
assign sf_e=1;
always @(posedge clk) begin
if(rst) begin
state<=IDLE;
buffer<=0;
count<=0;
end
else begin
count<=count+1;
	case(state)
	IDLE: begin
		if(set_w) begin
			buffer[32:0]<=data_out_w[32:0];
			LED<=data_out_w[7:0];
			state<=STORE;
			count<=0;
		end
		else
			state<=IDLE;
	end
	STORE: begin
		if (count<8)begin 
		buffer<={4'b0,buffer[32:4]};
		if (buffer[3:0]<10)
		RAM[7-count[2:0]]<={4'd3,buffer[3:0]};
		else
		RAM[7-count[2:0]]<={4'd4,(buffer[3:0]-4'd9)};
		end
		else state<=LCD;
	end
	LCD: begin
	if(mem_addr<8) mem_bus[7:0]<=RAM[mem_addr[2:0]];
	else if(mem_addr<16) mem_bus<=0;
	else state<=IDLE;	
	end
	endcase end
end

io_module io(data_in, ctrl,clk,rst,data_out_w[32:0],set_w);
lcd_driver display(clk,rst,rs,rw,e,d,mem_addr[4:0],mem_bus[7:0]);

endmodule
