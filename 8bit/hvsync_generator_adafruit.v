`ifndef _8BIT_HVSYNC_GENERATOR_ADAFRUIT
`define _8BIT_HVSYNC_GENERATOR_ADAFRUIT

`include "8bit/hvsync_generator.v"

// Tuned for an http://adafru.it/911 display driven by an icestick
// with a 6MHz clock.
module hvsync_generator_adafruit_911(clk, reset, hsync, vsync, display_on, 
                                     hpos, vpos);
   input clk;
   input reset;
   output hsync, vsync;  // hsync and vsync outptus
   output display_on;    // current pixel is in a displayable area
   output [8:0] hpos;
   output [8:0] vpos;

   hvsync_generator #(256, 60, 40, 25,  // h display, back, front, sync
                      240, 18, 14, 4)    // v display, top, bottom, sync
         hvsync_gen (.clk(clk),
		     .reset(reset),
		     .hsync(hsync),
		     .vsync(vsync),
		     .display_on(display_on),
		     .hpos(hpos),
		     .vpos(vpos)
		     );
endmodule

`endif // _8BIT_HVSYNC_GENERATOR_ADAFRUIT
