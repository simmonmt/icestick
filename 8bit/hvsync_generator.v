`ifndef HVSYNC_GENERATOR_V
`define HVSYNC_GENERATOR_V

module hvsync_generator(clk, reset, hsync, vsync, display_on, hpos, vpos);
   input clk;
   input reset;
   output reg hsync, vsync;  // hsync and vsync outptus
   output display_on;    // current pixel is in a displayable area
   output reg [8:0] hpos;
   output reg [8:0] vpos;
   
   parameter H_DISPLAY = 256; // horizontal display width
   parameter H_BACK    =  23; // left border (back porch)
   parameter H_FRONT   =   7; // right border (front porch)
   parameter H_SYNC    =  23; // horizontal sync width

   parameter V_DISPLAY = 240; // vertical display height
   parameter V_TOP     =   4; // vertical top border
   parameter V_BOTTOM  =  14; // vertical bottom border
   parameter V_SYNC    =   4; // vertical sync num lines

   localparam H_SYNC_START = H_DISPLAY + H_FRONT;
   localparam H_SYNC_END   = H_DISPLAY + H_FRONT + H_SYNC - 1;
   localparam H_MAX        = H_DISPLAY + H_BACK + H_FRONT + H_SYNC - 1;
   
   localparam V_SYNC_START = V_DISPLAY + V_BOTTOM;
   localparam V_SYNC_END   = V_DISPLAY + V_BOTTOM + V_SYNC - 1;
   localparam V_MAX        = V_DISPLAY + V_TOP + V_BOTTOM + V_SYNC - 1;

   wire hmaxxed = (hpos == H_MAX) || reset;
   wire vmaxxed = (vpos == V_MAX) || reset;

   // horizontal position counter (hpos)
   always @(posedge clk)
     begin
	hsync <= (hpos >= H_SYNC_START && hpos <= H_SYNC_END);
	if (hmaxxed)
	  hpos <= 0;
	else
	  hpos <= hpos + 1;
     end

   // vertical position counter (vpos)
   always @(posedge clk)
     begin
	vsync <= (vpos >= V_SYNC_START && vpos <= V_SYNC_END);
	if (hmaxxed)
	  if (vmaxxed)
	    vpos <= 0;
	  else
	    vpos <= vpos + 1;
     end

   assign display_on = (hpos < H_DISPLAY) && (vpos < V_DISPLAY);
endmodule // hvsync_generator

`endif    
