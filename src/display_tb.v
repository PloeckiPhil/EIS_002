/*
Simple testbench for the counter .
*/

`timescale 10ns/10ns

`include "display.v"

module display_tb;

	parameter gs = 8;
	
	wire [ gs-1:0] col_val_o; // column value
 	wire [ gs-1:0] row_val_o; // row value

	// inputs
	reg clk_i = 1'b0 ;
		
	reg [gs*gs-1:0] my_disp;
	
	reg e_disp = 1'b0;
	wire d_disp;
	wire i0_o; wire i1_o; wire i2_o; wire i3_o; 
	wire i4_o;wire i5_o; wire i6_o; wire i7_o;
	
	
	// DUT
	display
		#(gs)
		display_dut (
		.clk_i ( clk_i ) ,
		.matrix_i(my_disp) ,
		.e_disp(e_disp) ,
		.col_val_o(col_val_o) ,
		.row_val_o(row_val_o) ,
		.d_disp_o(d_disp),
		.i0_o(i0_o),
		.i1_o(i1_o),
		.i2_o(i2_o),
		.i3_o(i3_o),
		.i4_o(i4_o),
		.i5_o(i5_o),
		.i6_o(i6_o),
		.i7_o(i7_o)
		);

	// Generate clock
	/* verilator lint_off STMTDLY */
	always begin
		#5 clk_i = ~clk_i;
		
		
	end
	
	always @ (negedge clk_i) begin
		if (d_disp == 1'b1)  e_disp = 1'b0;
	end
	
	/* verilator lint_on STMTDLY */

	initial begin
	
		for (integer i = 0; i < gs*gs; i = i + 1) begin
        	my_disp[i] <= 1'b0;
		end
		
		my_disp[0] <= 1'b1;
		//my_disp[7] <= 1'b1;
		my_disp[9] <= 1'b1;
		//my_disp[14] <= 1'b1;
		my_disp[18] <= 1'b1;
		//my_disp[21] <= 1'b1;
		my_disp[27] <= 1'b1;
		//my_disp[28] <= 1'b1;
		//my_disp[35] <= 1'b1;
		my_disp[36] <= 1'b1;
		//my_disp[42] <= 1'b1;
		my_disp[45] <= 1'b1;
		//my_disp[49] <= 1'b1;
		my_disp[54] <= 1'b1;
		//my_disp[56] <= 1'b1;
		my_disp[63] <= 1'b1;
		
	
		$dumpfile("display_tb.vcd");
		$dumpvars;

		/* verilator lint_off STMTDLY */
		#50 e_disp = 1'b1 ; // deassert reset
		#200 $finish ; // finish
		/* verilator lint_on STMTDLY */
	end

endmodule // counter_tb

