/*
 Module to implement the drop action
 - Move bar left (Left input)
 - Move bar right (Right input)
 - create drop (random position in data_struct)
 - sink drop every cr iterations
 - count life if caught/ missed 
 - set to kill screen if dead
 - deliver 1D array fot display
*/

`default_nettype none
`ifndef __ACTION__
`define __ACTION__

module action
#(
 parameter gs = 8, // grid size
 parameter cr = 2,  //change rate
 parameter data_struct = 80'b01000000_00000100_00010000_00000001_10000000_00100000_00000010_00001000_10000000_00000100
) (
 	// input
	input clk_i ,
	input right_i,
	input left_i,
	input reset_i,
	input e_act_i,
	
	// output
	output [gs*gs-1:0] matrix_o,
	output d_act_o
);
	
	reg [(gs*gs-1):0] matrix; //Matrix to store values
	
	//Current bar position
	reg [(gs-1):0] bar_pos ; 
	reg [(gs-1):0] bar_height;
	
	// Current drop position
	reg [(gs-1):0] drop_pos ;
	reg [(gs-1):0] drop_height ;
	
	reg [gs-1:0] life_counter; //count remaining lifes
	reg [4:0] pos_counter; //next drop pos
	reg [cr-1:0] change_counter; //sinking rate of drop (the smaller the faster)
	
	reg dead; //if true -> game over

	reg d_act; //used to disbale 
	
	
	//assign outputs to storages
	assign d_act_o = d_act;
	assign matrix_o = matrix;
	
	
	always @ (posedge clk_i) begin
	// 1st case: reset
		if(reset_i == 1'b1) begin //Initialize
			bar_pos <= {1'b1 , {( gs-1) {1'b0}}}; //--> bar set to left corner
			drop_pos <= 8'b0; //--> No drop			
			drop_height <= 8'b0; //--> No drop
			life_counter <= 5; // --> by default 5 lifes
			change_counter <= 0; // --> set to 0 --> First drop -> next run
			bar_height <= {{( gs-1) {1'b0}} , 1'b1}; // always set bar to base 
			pos_counter <= {{( 3) {1'b0}} , 1'b1};
			dead <= 1'b0;
			d_act <= 1'b1; 

			// --> display only diagonal
			//matrix <= {(gs*gs) {1'b0}};
			for (integer i = 0; i < gs; i= i+1) begin
					for (integer j = 0; j < gs; j= j+1) begin
						if( i == j) matrix[i*gs + j] <= 1'b1;
						else matrix[i*gs + j] <= 1'b0;
					end
			end
			
		end else begin
		// 2nd case: dead
			if (dead == 1'b1) begin
				//Send a cross to the output screen
				for (integer i = 0; i < gs; i= i+1) begin
					for (integer j = 0; j < gs; j= j+1) begin
						if( i == j) matrix[i*gs + j] <= 1'b1;
						else if((gs-1-i) == j) matrix[i*gs + j] <= 1'b1;
						else matrix[i*gs + j] <= 1'b0;
					end
				end
			end else begin
		// 3rd case: enabled
				if (e_act_i == 1'b1) begin
					//compute change of bar pos
					if(left_i && (bar_pos[0] != 1'b1 )) begin
						bar_pos <= bar_pos >> 1;
						
							if(pos_counter == 9) pos_counter <= 0;
							else pos_counter <= pos_counter + 1; 
					end

					if(right_i && (bar_pos[gs-1] != 1'b1)) begin
						bar_pos <= bar_pos << 1;
						
							if(pos_counter == 9) pos_counter <= 0;
							else pos_counter <= pos_counter + 1; 
						
					end
					
				// compute drop position
					if(drop_height == 8'b0) begin//drop has left game	
						
						for(integer i=0; i < gs; i = i+1) begin
							drop_pos[i] <= data_struct[i + gs * pos_counter];
						end	
						drop_height <= {1'b1 , {( gs-1) {1'b0}}};

							if(pos_counter == 9) pos_counter <= 0;
							else pos_counter <= pos_counter + 1;  
						
					end else begin //drop still in game
						if (change_counter == 0) begin
							drop_height <= drop_height >> 1;
						end
						
						change_counter <= change_counter + 1; //always run change counter through
					end
					
					// check if drop @ player height
					if (change_counter == 0 && drop_height == 1) begin
						if(drop_pos != bar_pos) life_counter <= life_counter - 1; // no increase given
					end
					
					//end game if dead
					if (life_counter == 0) begin
						dead <= 1'b1;
					end
					
					//create output matrix
					for (integer i = 0; i < gs; i= i+1) begin
						for (integer j = 0; j < gs; j= j+1) begin
							matrix[i*gs + j] <= ((drop_pos[i] && drop_height[j]) || (bar_pos[i] && bar_height[j]));
						end
					end
					
					d_act <= 1'b1; //always disable after run
			end else begin
		// 4th case -> do nothing
				if(pos_counter == 9) pos_counter <= 0;
				else pos_counter <= pos_counter + 1; 
			end
			
		end
	end
	end

endmodule // display

`endif
`default_nettype wire
