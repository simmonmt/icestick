`include "8bit/hvsync_generator.v"

module test_hvsync_top(clk, out);
   input clk;
   output [1:0] out;

   localparam SYNC =0;
   localparam BLACK = 1;
   localparam GRAY = 2;
   localparam WHITE = 3;

   reg 	  clk2;
   always @(posedge clk) begin
      clk2 <= !clk2;
   end

   wire reset = 0;

   wire       hsync, vsync;
   wire       display_on;
   wire [8:0] hpos;
   wire [8:0] vpos;

   hvsync_generator #(256, 60, 40, 25,  // h display, back, front, sync
                      240, 18, 14, 4)    // v display, top, bottom, sync
         hvsync_gen (.clk(clk2),
		     .reset(reset),
		     .hsync(hsync),
		     .vsync(vsync),
		     .display_on(display_on),
		     .hpos(hpos),
		     .vpos(vpos)
		     );

   wire       r = display_on && (((hpos&7) == 0) || ((vpos&7) == 0));
   wire       g = display_on & vpos[4];
   wire       b = display_on & hpos[4];

   // Plaid
   assign out = (hsync||vsync) ? SYNC : (1+g+(r+b));

   // Three colors
   //assign out = (hsync||vsync) ? SYNC : (display_on ? ((vpos < 75) ? GRAY : (vpos < 150 ? WHITE : BLACK)) : BLACK);

//   assign out = (hsync||vsync) ? SYNC : ((display_on && (hpos == 0 || hpos == 255 || vpos == 16 || vpos == 249)) ? WHITE : BLACK);

   // Box on bounds
   //assign out = (hsync||vsync) ? SYNC : ((display_on && (hpos == 0 || vpos == 0 || hpos == 255 || vpos == 239)) ? WHITE : BLACK);
endmodule // test_hvsync_top

