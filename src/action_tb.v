/*
Simple testbench for the counter .
*/

`timescale 1ns/1ns

`include "action.v"

module action_tb;

	parameter gs = 8;
	parameter cr = 2;
	parameter data_struct = 80'b01000000_00000100_00010000_00000001_10000000_00100000_00000010_00001000_10000000_00000100;

	// inputs
	reg clk_i = 1'b0 ;
	
	reg left_i = 1'b0;
	reg right_i = 1'b0;
	reg reset_i = 1'b0;


	reg e_act_i = 1'b0;
	
	wire [gs*gs-1:0] matrix_o;
	wire d_act_o;
	wire dead_o;
	
	
	// DUT
	action
		#(gs, cr, data_struct)
		action_dut (
			.clk_i (clk_i),
			.right_i (right_i),
			.left_i (left_i),
			.reset_i (reset_i),
			.e_act_i (e_act_i),
			.matrix_o (matrix_o),
			.d_act_o (d_act_o),
			.dead_o (dead_o)
		);
		
	// Generate clock
	/* verilator lint_off STMTDLY */
	always begin
		#5 clk_i = ~clk_i;

	end
	
	always @ (negedge clk_i) begin
		if (d_act_o == 1'b1)  e_act_i = 1'b0;
	end
	
	always begin
		#15 e_act_i <= 1'b1;

	end
	
	
	
	/* verilator lint_on STMTDLY */

	initial begin
		$dumpfile("action_tb.vcd");
		$dumpvars;

		/* verilator lint_off STMTDLY */
		#0 reset_i = 1'b1 ; // deassert reset
		#10 reset_i = 1'b0 ;
		#500 left_i  = 1'b1 ; // finish
		#5 left_i  = 1'b0; 
		#500 right_i = 1'b1;
		#8000 $finish ; // finish
		/* verilator lint_on STMTDLY */
	end

endmodule // counter_tb

