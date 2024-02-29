/*
	Module to control output to an 8x8 segment display
*/

`default_nettype none
`ifndef __DISPLAY__
`define __DISPLAY__



module display
#(
	parameter gs = 8 // optional parameter
) (
	input clk_i ,
	input [(gs*gs-1):0] matrix_i,
	input e_disp ,
	input rst_i,

	output [gs-1:0] col_val_o,
	output [gs-1:0] row_val_o,	
	output d_disp_o
);
	
	reg [gs-1:0] col_val;
	reg [gs-1:0] row_val;
	reg d_disp;
	reg [gs-1:0] row_d;
	
	reg i0; reg i1; reg i2; reg i3;	
	reg i4; reg i5; reg i6;	reg i7;
	
	assign col_val_o = col_val;
	assign row_val_o = ~row_val;
	assign d_disp_o = d_disp;
	
	always @ (posedge clk_i) begin
		if (rst_i) begin
			col_val <= {{(gs) {1'b0}}};
			row_val <= {{(gs) {1'b0}}};
			row_d <= 0;
			d_disp <= 0;	
			
		end else begin
		if (e_disp) begin
			d_disp <= 0;	

			for(integer i =0; i < gs; i = i+1) begin
				col_val[i] <= matrix_i[gs*row_d + i];
			end
						
			if(row_d == 0) row_val <= {{( gs-1) {1'b0}} , 1'b1 };
			else row_val <= row_val << 1;
			
			if(row_d == 7) d_disp <= 1;
			row_d <= row_d + 1;
			
			//for debugging purposes
			i0 <= matrix_i[gs*row_d + 0]; i1 <= matrix_i[gs*row_d + 1];
			i2 <= matrix_i[gs*row_d + 2]; i3 <= matrix_i[gs*row_d + 3];
			i4 <= matrix_i[gs*row_d + 4]; i5 <= matrix_i[gs*row_d + 5];
			i6 <= matrix_i[gs*row_d + 6]; i7 <= matrix_i[gs*row_d + 7];
			
		end else begin
			col_val <= {{( gs) {1'b0}}};
			row_val <= {{( gs) {1'b0}}};
			row_d <= 0;
			
			//for debugging purposes
			i0 <= 1; i1 <= 1;
			i2 <= 1; i3 <= 1;
			i4 <= 1; i5 <= 1;
			i6 <= 1; i7 <= 1;
			
		end
		end
	end

endmodule // display

`endif
`default_nettype wire
