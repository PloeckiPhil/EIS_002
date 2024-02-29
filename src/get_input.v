/*
	Module to catch left right input and prevent button bounce
*/

`default_nettype none
`ifndef __GETINPUT__
`define __GETINPUT__

module get_input
#(
 parameter cr_but = 4 // counter range to prevent button bounce
) (
 // define I /O ’ s of the module
 	input clk_i , // clock
	input e_inp ,
 	input rst_i , // reset
 	input right_i ,
 	input left_i ,

	output wire right_o,
	output wire left_o,
	output wire d_inp_o
);

 	reg left;
 	reg right;
 	reg d_inp;
	
	// counter till next input is used
	reg [cr_but-1:0] left_cr;
	reg [cr_but-1:0] right_cr;
	
	// assign the counter value to the output
	assign left_o = left;
	assign right_o = right;
	assign d_inp_o = d_inp;

	
	always @ (posedge clk_i) begin		
		if(rst_i) begin
			left <= 1'b0;
			right <= 1'b0;
			left_cr <= 0;
			right_cr <= 0;
		end else begin
			if (e_inp) begin
				if(left_cr == 0) begin
					if(left_i) begin
						left <= 1'b1;
						left_cr <= 1;
					end else left <= 1'b0;
				end else begin
					left <= 1'b0;
					left_cr <= left_cr + 1;
				end
			
				if(right_cr == 0) begin
					if(right_i) begin
						right <= 1'b1;
						right_cr <= 1;
					end else right <= 1'b0;
				end else begin
					right_cr <= right_cr + 1;
					right <= 1'b0;
				end				
			end
		end
		d_inp <= 1'b1; //always reset to prevent 2nd run
	end

				

endmodule // input

`endif
`default_nettype wire
