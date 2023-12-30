/*
Simple testbench for the counter .
*/

`timescale 1ns/1ns

`include "get_input.v"

module get_input_tb;

	parameter cr = 2;
	 
 	// define I /O ’ s of the module
 	reg clk_i =1'b0; // clock
 	reg rst_i =1'b0; // reset
 	reg e_inp =1'b0; // enable input
 	
 	reg right_i = 1'b0 ;
 	reg left_i = 1'b0;

 	wire right_o;
 	wire left_o;
 	
 	wire rst_o;	
 	wire d_inp_o;



	// DUT
	get_input
		#(cr)
		get_input_dut (
		.clk_i ( clk_i ) ,
		.rst_i ( rst_i ) ,
		.e_inp (e_inp) ,
		
		.right_i(right_i),
		.left_i(left_i),
		.right_o(right_o) ,
		.left_o(left_o) ,
		.rst_o(rst_o) ,
		.d_inp_o(d_inp_o) 
		);

	// Generate clock
	/* verilator lint_off STMTDLY */
	always begin
	#5 clk_i = ~clk_i;
	end
	
	always begin
	#3 right_i = ~right_i;
	end 
	
	always begin
	#20 e_inp = 1'b1;
	end
	/* verilator lint_on STMTDLY */

	always @ (negedge clk_i) begin
		if (d_inp_o == 1'b1)  e_inp = 1'b0;
	end

	initial begin
		$dumpfile("get_input_tb.vcd");
		$dumpvars;

		/* verilator lint_off STMTDLY */
		#20 e_inp = 1'b1;
		#20 rst_i = 1'b1 ; // deassert reset
		#0 left_i = 1'b1 ;
		#20 rst_i = 1'b0 ;
		//#01 e_inp = 1'b1;
		#02 rst_i = 1'b0 ;
		//#20 e_inp = 1'b1;
		
		#200 $finish ; // finish
		/* verilator lint_on STMTDLY */
	end

endmodule // counter_tb

