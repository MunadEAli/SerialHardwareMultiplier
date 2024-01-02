`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date:    16:54:00 05/30/2023 
// Design Name: 
// Module Name:    lcd 
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
module lcd_driver (
	input            clk,
	input				  rst,
	output reg       lcd_rs,
	output reg       lcd_rw,
	output reg       lcd_e,
	output reg [7:4] lcd_d,
	output     [4:0] mem_addr,
	input      [7:0] mem_bus
	);
	
	parameter        n = 25;
	parameter        j = 6;           // Initialization is slow, runs at clk/2^(j+2) ~95Hz
	parameter        k = 6;           // Writing/seeking is fast, clk/2^(k_2) ~6KHz
	parameter        noop = 6'b010000; // Allows LCD to drive lcd_d, can be safely written any time
	
	reg        [n:0] count;
	reg        [5:0] lcd_state;
	reg              init;          // Start in initialization on power on
	reg              row;          // Writing to top or or bottom row
	
	assign mem_addr = {row, count[k+6:k+3]};

	always @ (posedge clk) begin
	if(rst) begin
	count<=0;
	lcd_state<=noop;
	init<=1;
	row<=0;
	lcd_rs<=0;
	lcd_rw<=0;
	lcd_e<=0;
	lcd_d<=0;
	end
	else begin
		count <= count + 1;
		if (init) begin                    // initalization
			case (count[j+7:j+2])
				1: lcd_state <= 6'b000010;    // function set
				2: lcd_state <= 6'b000010;
				3: lcd_state <= 6'b001000;
				4: lcd_state <= 6'b000000;    // display on/off control
				5: lcd_state <= 6'b001100;
				6: lcd_state <= 6'b000000;    // display clear
				7: lcd_state <= 6'b000001;
				8: lcd_state <= 6'b000000;    // entry mode set
				9: lcd_state <= 6'b000110;
				10: begin init <= ~init; count <= 0; end
			endcase
			// Write lcd_state to the LCD and turn lcd_e high for the middle half of each lcd_state
			{lcd_e,lcd_rs,lcd_rw,lcd_d[7:4]} <= {(^count[j+1:j+0] & ~lcd_rw),lcd_state}; 
		end else begin                                                              // Continuously update screen from memory
			case (count[k+7:k+2]) 
				32: lcd_state <= {3'b001,~row,2'b00};                                 // Move cursor to begining of next line
				33: lcd_state <= 6'b000000;
				34: begin count <= 0; row <= ~row; end                                // Restart and switch which row is being written
				default: lcd_state <= {2'b10, ~count[k+2] ? mem_bus[7:4] : mem_bus[3:0]}; // Pull characters from bus
			endcase
			// Write lcd_state to the LCD and turn lcd_e high for the middle half of each lcd_state
			{lcd_e,lcd_rs,lcd_rw,lcd_d[7:4]} <= {(^count[k+1:k+0] & ~lcd_rw),lcd_state};
		end
	end
	end
endmodule
