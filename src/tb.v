`default_nettype none
`timescale 1ns/1ps

`include "tt_um_drops.v"

/*
this testbench just instantiates the module and makes some convenient wires
that can be driven / tested by the cocotb test.py
*/

// testbench is controlled by test.py
module tb ();

    // this part dumps the trace to a vcd file that can be viewed with GTKWave


    // wire up the inputs and outputs
    reg  clk;
    reg  rst_n;
    reg  ena;
    reg  [7:0] ui_in;
    //reg  [7:0] uio_in;

    wire [6:0] segments = uo_out[6:0];
    wire [7:0] uo_out;
    wire [7:0] uio_out;
    wire [7:0] uio_oe;

    tt_um_drops tt_um_drops (
    // include power ports for the Gate Level test
    `ifdef GL_TEST
        .VPWR( 1'b1),
        .VGND( 1'b0),
    `endif
        .ui_in      (ui_in),    // Dedicated inputs
        .uo_out     (uo_out),   // Dedicated outputs
        //.uio_in     (uio_in),   // IOs: Input path
        .uio_out    (uio_out),  // IOs: Output path
        .uio_oe     (uio_oe),   // IOs: Enable path (active high: 0=input, 1=output)
        .ena        (ena),      // enable - goes high when design is selected
        .clk        (clk),      // clock
        .rst_n      (rst_n)     // not reset
        );

    always begin
		#5 clk = ~clk;	
	end

    initial begin
        $dumpfile ("tb.vcd");
        $dumpvars (0, tb);
        
        #0 rst_n = 0;
        #0 clk = 0;
        
        #0  clk = 1'b0;
    	#0  ena = 1'b1;
    	#0  ui_in = {{(8) {1'b0}}};
        
        #15 rst_n = 1;
        
        #2000 ui_in= { {( 8-2) {1'b0}}, 1'b1 ,1'b0}; 
        #2000 ui_in = { {( 8-2) {1'b0}}, 1'b0 ,1'b1};
        #2000 ui_in= { {( 8-2) {1'b0}}, 1'b1 ,1'b0}; 
        #2000 ui_in = { {( 8-2) {1'b0}}, 1'b0 ,1'b1};
        
	#800000 $finish ; // finish
    end

endmodule
