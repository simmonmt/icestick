`include "8bit/abs_pong_logic.v"
`include "8bit/hvsync_generator.v"
`include "8bit/startup.v"

module abs_pong_top(clk, out, led);
   input clk;
   output [1:0] out;
   output [4:0] led;

   localparam DISPLAY_WIDTH = 256;
   localparam DISPLAY_HEIGHT = 240;
   localparam BALL_SIZE = 8;

   localparam SYNC = 0;
   localparam BLACK = 1;
   localparam GRAY = 2;
   localparam WHITE = 3;

   reg 	  clk2;
   always @(posedge clk) begin
      clk2 <= !clk2;
   end

   assign led = 0;

   wire reset;
   startup startup (.clk(clk2),
		    .reset(reset));

   wire       hsync, vsync;
   wire       display_on;
   wire [8:0] hpos;
   wire [8:0] vpos;

   hvsync_generator #(DISPLAY_WIDTH, 60, 40, 25,  // h display, back, front, sync
                      DISPLAY_HEIGHT, 18, 14, 4)    // v display, top, bottom, sync
         hvsync_gen (.clk(clk2),
		     .reset(reset),
		     .hsync(hsync),
		     .vsync(vsync),
		     .display_on(display_on),
		     .hpos(hpos),
		     .vpos(vpos));

   wire [8:0] ball_hpos;
   wire [8:0] ball_vpos;

   ball_logic #(DISPLAY_WIDTH, DISPLAY_HEIGHT, BALL_SIZE)
         ball_logic (.clk(vsync),
		     .reset(reset),
		     .ball_hpos(ball_hpos),
		     .ball_vpos(ball_vpos));

   wire [8:0] ball_hdiff = hpos - ball_hpos;
   wire [8:0] ball_vdiff = vpos - ball_vpos;

   wire       ball_hon = ball_hdiff < BALL_SIZE;
   wire       ball_von = ball_vdiff < BALL_SIZE;
   wire       ball_on = display_on && ball_hon && ball_von;

   wire       centering_on = display_on && ((ball_hon && !ball_von) || (ball_von && !ball_hon));

   assign out = (hsync||vsync) ? SYNC : (ball_on ? WHITE : (centering_on ? GRAY : BLACK));

   //wire       pixel_on = display_on && (ball_gfx || vpos == 0 || hpos == 0 || vpos == DISPLAY_HEIGHT-1 || hpos == DISPLAY_WIDTH-1) && vpos != ball_vpos && hpos != ball_hpos;

   //assign out = (hsync||vsync) ? SYNC : (pixel_on ? WHITE : BLACK);

endmodule // abs_pong_top
