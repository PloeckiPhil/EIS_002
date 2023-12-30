`default_nettype none

`include "get_input.v"
`include "action.v"
`include "display.v"


module tt_um_drops 
#( ) (
    input  wire [7:0] ui_in,    // Dedicated inputs - connected to the input switches
    output wire [7:0] uo_out,   // Dedicated outputs - connected to the 7 segment display
    //input  wire [7:0] uio_in,   // IOs: Bidirectional Input path
    output wire [7:0] uio_out,  // IOs: Bidirectional Output path
    output wire [7:0] uio_oe,   // IOs: Bidirectional Enable path (active high: 0=input, 1=output)
    //input  wire       ena,      // will go high when the design is enabled
    input  wire       clk,      // clock
    input  wire       rst_n     // reset_n - low to reset
);

    reg reset = ! rst_n;

    // use bidirectionals as outputs
    assign uio_oe = 8'b11111111;
	
	parameter gs = 8;
	parameter cr = 2;
	parameter data_struct = 80'b01000000_00000100_00010000_00000001_10000000_00100000_00000010_00001000_10000000_00000100;
	
	// inputs
	reg clk_i = 1'b0 ;
	
	reg e_inp = 1'b0;
	wire d_inp;
	
	reg e_act = 1'b0;
	wire d_act;
	
	reg e_disp = 1'b0;
	wire d_disp;

	wire left_o = 1'b0;
	wire right_o = 1'b0;
	wire reset_o = 1'b0;
		
	wire [gs*gs-1:0] matrix;
	wire dead;
	

	// DUT
	get_input
		#(cr)
		get_input_dut (
		.clk_i ( clk_i ) ,
		.rst_i ( reset ) ,
		.e_inp (e_inp) ,
		
		.right_i(ui_in[0]),
		.left_i(ui_in[1]),
		.right_o(right_o) ,
		.left_o(left_o) ,
		.rst_o(reset_o) ,
		.d_inp_o(d_inp) 
		);

	// DUT
	action
		#(gs, cr, data_struct)
		action_dut (
			.clk_i (clk_i),
			.right_i (right_o),
			.left_i (left_o),
			.reset_i (reset_o),
			.e_act_i (e_act),
			.matrix_o (matrix),
			.d_act_o (d_act),
			.dead_o (dead)
		);
	
	
	display
		#(gs)
		display_dut (
			.clk_i ( clk_i ) ,
			.matrix_i(matrix) ,
			.e_disp(e_disp) ,
			.col_val_o(uio_out) ,
			.row_val_o(uo_out) ,
			.d_disp_o(d_disp)
		);
	
    reg [2:0]State;
	localparam e_inp_s  = 3'b000;
	localparam d_inp_s = 3'b001;
	localparam e_act_s = 3'b010;
	localparam d_act_s = 3'b011;
	localparam e_disp_s = 3'b100;
	localparam d_disp_s = 3'b101;
	
    always @(negedge clk) begin


	
	case(State)
		e_inp_s: begin
			e_inp <= 1;
			State <= d_inp_s;
		end
		d_inp_s: begin
			if (d_inp) State <= e_act_s;
		end
		e_act_s: begin
			e_act <= 1;
			State <= d_act_s;
		end
		d_act_s: begin
			if (d_act) State <= e_disp_s;
		end
		e_disp_s: begin
			e_disp <= 1;
			State <= d_disp_s;
		end
		d_disp_s: begin
			if (d_disp) State <= e_inp_s;
		end  		
		default:;
	endcase
    end

    
endmodule
