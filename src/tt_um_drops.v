`default_nettype none
`ifndef __DROPS__
`define __DROPS__

`include "get_input.v"
`include "action.v"
`include "display.v"


module tt_um_drops 
#( 
parameter useless = 1
) (
    input  wire [7:0] ui_in,    // Dedicated inputs - connected to the input switches
    output wire [7:0] uo_out,   // Dedicated outputs - connected to the 7 segment display
    //input  wire [7:0] uio_in,   // IOs: Bidirectional Input path
    output wire [7:0] uio_out,  // IOs: Bidirectional Output path
    output wire [7:0] uio_oe,   // IOs: Bidirectional Enable path (active high: 0=input, 1=output)
    input  wire       ena,      // will go high when the design is enabled
    input  wire       clk,      // clock
    input  wire       rst_n     // reset_n - low to reset
);

    

    // use bidirectionals as outputs
    assign uio_oe = 8'b11111111;
	
	parameter gs = 8; //grid size --> gs x gs display used
	parameter cr = 4; //change rate --> counts time to apply change to display
	parameter cr_but = 4; //--> no of cycles until new input valid
	//Placement of drop:
	parameter data_struct = 80'b01000000_00000100_00010000_00000001_10000000_00100000_00000010_00001000_10000000_00000100;
	
	// inputs
	reg reset;

	//input enable/disable
	reg e_inp;
	wire d_inp;
	
	//action enable/disable
	reg e_act;
	wire d_act;
	
	//display enable/disable
	reg e_disp;
	wire d_disp;


	// define connection between the blocks

	// get_input --> action
	wire left;
	wire right;

	// action --> display 
	wire [gs*gs-1:0] matrix;
	

	// Initial input block
	get_input
		#(cr_but)
		get_input_dut (
		// Input
		.clk_i (clk) ,
		.e_inp (e_inp) ,
		.rst_i (reset) ,
		.right_i(ui_in[0]),
		.left_i(ui_in[1]),
		// Output
		.right_o(right) ,
		.left_o(left) ,
		.d_inp_o(d_inp) 
		);

	
	action
		#(gs, cr, data_struct)
		action_dut (
			// Input
			.clk_i (clk),
			.right_i (right),
			.left_i (left),
			.reset_i (reset),
			.e_act_i (e_act),
			// Output
			.matrix_o (matrix),
			.d_act_o (d_act)
		);
	
	
	display
		#(gs)
		display_dut (
			// Input
			.clk_i ( clk ) ,
			.matrix_i(matrix) ,
			.e_disp(e_disp) ,
			.rst_i (reset),
			// Output
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
    		reset <= ~rst_n;
		case(State)
			e_inp_s: begin
				e_inp <= 1;
				State <= d_inp_s;
			end
			d_inp_s: begin
				if (d_inp) begin
					State <= e_act_s;
					e_inp <= 0; 
					end
			end
			e_act_s: begin
				e_act <= 1;
				State <= d_act_s;
			end
			d_act_s: begin
				if (d_act) begin
					State <= e_disp_s;
					e_act <= 0;
				end
			end
			e_disp_s: begin
				e_disp <= 1;
				State <= d_disp_s;
			end
			d_disp_s: begin
				if (d_disp)begin
				 State <= e_inp_s;
				 e_disp <= 0;
				end
			end  		
			default: State <= 3'b000;
		endcase
    end

endmodule

`endif
`default_nettype wire
