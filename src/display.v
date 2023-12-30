/*
 Simple counter with generic bitwidth .
*/

`default_nettype none
`ifndef __DISPLAY__
`define __DISPLAY__



module display
#(
 parameter gs = 8 // optional parameter
) (
 // define I /O ’ s of the module

	input clk_i ,
	input [(gs*gs-1):0] matrix_i,
	input wire e_disp ,

	output [gs-1:0] col_val_o,
	output [gs-1:0] row_val_o,	
	output d_disp_o
);
	
	//output d_disp_o;
	
	//wire i0_o; wire i1_o; wire i2_o; wire i3_o;
	//wire i4_o; wire i5_o; wire i6_o; wire i7_o;
	
	
	reg [gs-1:0] col_val = {{(gs) {1'b0}}};
	reg [gs-1:0] row_val = {{(gs) {1'b0}}};
	//reg [gs-1:0] temp_col;
	//reg [gs-1:0] temp_row;
	reg d_disp;
	//reg i0; reg i1; reg i2; reg i3;	
	//reg i4; reg i5; reg i6;	reg i7;
	reg [gs-1:0] row_d;
	
	
	
	// assign the counter value to the output
	assign col_val_o = col_val;
	assign row_val_o = row_val;
	assign d_disp_o = d_disp;
	
	//assign i0_o = i0; assign i1_o = i1;
	//assign i2_o = i2; assign i3_o = i3;
	//assign i4_o = i4; assign i5_o = i5;
	//assign i6_o = i6; assign i7_o = i7;
	
	
	always @ (posedge clk_i) begin
		if (e_disp) begin
			d_disp <= 0;	

			//for(integer i =0; i < gs; i = i+1) begin
			//	col_val[i] <= matrix_i[gs*row_d + i];
			//end

			
			col_val[0] <= matrix_i[gs*row_d + 0];
			col_val[1] <= matrix_i[gs*row_d + 1];
			col_val[2] <= matrix_i[gs*row_d + 2];
			col_val[3] <= matrix_i[gs*row_d + 3];
			col_val[4] <= matrix_i[gs*row_d + 4];
			col_val[5] <= matrix_i[gs*row_d + 5];
			col_val[6] <= matrix_i[gs*row_d + 6];
			col_val[7] <= matrix_i[gs*row_d + 7];
			
			
			//for debugging purposes
			//i0 <= matrix_i[gs*row_d + 0]; i1 <= matrix_i[gs*row_d + 1];
			//i2 <= matrix_i[gs*row_d + 2]; i3 <= matrix_i[gs*row_d + 3];
			//i4 <= matrix_i[gs*row_d + 4]; i5 <= matrix_i[gs*row_d + 5];
			//i6 <= matrix_i[gs*row_d + 6]; i7 <= matrix_i[gs*row_d + 7];
						
			if(row_d == 0) row_val <= {{( gs-1) {1'b0}} , 1'b1 };
			else row_val <= row_val << 1;
			
			if(row_d == 7) d_disp <= 1;
			
			row_d <= row_d + 1;
			
		end else begin
			col_val <= {{( gs) {1'b0}}};
			row_val <= {{( gs) {1'b0}}};
			//temp_col <= {{( gs) {1'b0}}};
			row_d <= 0;
			
			//i0 <= 0; i1 <= 0; i2 <= 0; i3 <= 0;
			//i4 <= 0; i5 <= 0; i6 <= 0; i7 <= 0;
		end

	end
	


endmodule // display

`endif
`default_nettype wire
