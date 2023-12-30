/*
 Simple counter with generic bitwidth .
*/

`default_nettype none
`ifndef __ACTION__
`define __ACTION__



module action
#(
 parameter gs = 8, // optional parameter
 parameter cr = 2,  //change rate
 parameter data_struct = 80'b01000000_00000100_00010000_00000001_10000000_00100000_00000010_00001000_10000000_00000100

) (
 // define I /O ’ s of the module

	input clk_i ,
	input right_i,
	input left_i,
	input reset_i,
	input e_act_i,
	
	output [gs*gs-1:0] matrix_o, //flattende matrix
	output d_act_o,
	output dead_o
 	
);
	
	reg [(gs*gs-1):0] matrix; //Matrix to store values
	
	reg [(gs-1):0] bar_pos ; //Player input
	reg [(gs-1):0] bar_height;
	
	
	reg [(gs-1):0] drop_pos ; //Position of the drop
	reg [(gs-1):0] drop_height ; //Actual height of the drop
	
	reg d_act; //used to disbale 

	reg [gs-1:0] life_counter = 0;
	
	reg [4:0] pos_counter = 0;
	reg [cr-1:0] change_counter = 0;
	
	reg dead = 1'b1;
	
	
	assign dead_o = dead;
	assign d_act_o = d_act;
	assign matrix_o = matrix;
	
	
	always @ (posedge clk_i) begin
		
		if(reset_i == 1'b1) begin
			bar_pos <= {1'b1 , {( gs-1) {1'b0}}};
			drop_pos <= 8'b0;			
			drop_height <= 8'b0;//{1'b1 , {( gs-1) {1'b0}}};
			life_counter <= 5;
			change_counter <= 0;
			bar_height <= {{( gs-1) {1'b0}} , 1'b1};
			dead <= 1'b0;
			d_act <= 1'b0;
			matrix <= {(gs*gs) {1'b0}};
			
			for (integer i = 0; i < gs; i= i+1) begin
					for (integer j = 0; j < gs; j= j+1) begin
						if( i == j) matrix[i*cr + j] <= 1'b1;
						else matrix[i*cr + j] <= 1'b1;
					end
			end
			
			
		end else begin
			if (dead == 1'b1) begin
				//sum it all up in one matrix
				for (integer i = 0; i < gs; i= i+1) begin
					for (integer j = 0; j < gs; j= j+1) begin
						matrix[i*cr + j] <= 1'b1;
					end
				end
			end else begin
				if (e_act_i == 1'b1) begin
				
					//compute change of bar pos
					if(right_i && (bar_pos[0] != 1'b1 )) begin
						bar_pos <= bar_pos >> 1;
						
						if(pos_counter == 9) pos_counter <= 0;
						else pos_counter <= pos_counter + 1; 
						
					end
				
					if(left_i && (bar_pos[gs-1] != 1'b1)) begin
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
						
					end else begin
						if (change_counter == 0) begin
							drop_height <= drop_height >> 1;
						end
						
						change_counter <= change_counter + 1;
					end
					
					// check if ball and player meet
					if (change_counter ==0 && drop_height == 1) begin
						if(drop_pos != bar_pos) life_counter <= life_counter - 1;
						//else life_counter <= life_counter - 1;
					end
					
					//end game if dead
					if (life_counter == 0) begin
						dead <= 1'b1;
					end
					
					//sum it all up in one matrix
					for (integer i = 0; i < gs; i= i+1) begin
						for (integer j = 0; j < gs; j= j+1) begin
							matrix[i*cr + j] <= ((drop_pos[i] && drop_height[j]) || (bar_pos[i] && bar_height[j]));
						end
					end
					
					d_act <= 1'b1;
			end else begin
				if(pos_counter == 9) pos_counter <= 0;
				else pos_counter <= pos_counter + 1; 
			end
			
		end
	end
	end

endmodule // display

`endif
`default_nettype wire
