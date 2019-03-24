`include "8bit/hvsync_generator.v"

module abs_pong_top(clk, out, led1, led2);
   input clk;
   output [1:0] out;
   output 	led1, led2;

   localparam DISPLAY_WIDTH = 256;
   localparam DISPLAY_HEIGHT = 240;

   localparam SYNC = 0;
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

   hvsync_generator #(DISPLAY_WIDTH, 60, 40, 25,  // h display, back, front, sync
                      DISPLAY_HEIGHT, 18, 14, 4)    // v display, top, bottom, sync
         hvsync_gen (.clk(clk2),
		     .reset(reset),
		     .hsync(hsync),
		     .vsync(vsync),
		     .display_on(display_on),
		     .hpos(hpos),
		     .vpos(vpos)
		     );

   localparam BALL_SIZE = 4;
   localparam BALL_HORIZ_INITIAL = DISPLAY_WIDTH / 2;
   localparam BALL_VERT_INITIAL = DISPLAY_HEIGHT / 2;
   
   reg [8:0]  ball_hpos;
   reg [8:0]  ball_vpos;

   reg [8:0]  ball_horiz_move = -2;	// ball current X velocity
   reg [8:0]  ball_vert_move = 2;	// ball current Y velocity

   always @(posedge vsync or posedge reset)
     begin
	if (reset) begin
	   ball_hpos <= BALL_HORIZ_INITIAL;
	   ball_vpos <= BALL_VERT_INITIAL;
	end else begin
	   ball_hpos <= ball_hpos + ball_horiz_move;
	   ball_vpos <= ball_vpos + ball_vert_move;
	end
     end

   always @(posedge ball_horiz_collide)
     ball_horiz_move <= -ball_horiz_move;

   always @(posedge ball_vert_collide)
     ball_vert_move <= -ball_vert_move;

   wire [8:0] ball_hdiff = hpos - ball_hpos;
   wire [8:0] ball_vdiff = vpos - ball_vpos;

   wire ball_horiz_collide = ball_hpos >= (DISPLAY_WIDTH - BALL_SIZE);
   wire ball_vert_collide = ball_vpos >= (DISPLAY_HEIGHT - BALL_SIZE);

   assign led1 = ball_vert_collide;
   assign led2 = ball_horiz_collide;

   wire       ball_hgfx = ball_hdiff < BALL_SIZE;
   wire       ball_vgfx = ball_vdiff < BALL_SIZE;
   wire       ball_gfx = ball_hgfx && ball_vgfx;

   wire       pixel_on = display_on && (ball_gfx || vpos == 0 || hpos == 0 || vpos == DISPLAY_HEIGHT-1 || hpos == DISPLAY_WIDTH-1) && vpos != ball_vpos && hpos != ball_hpos;

   assign out = (hsync||vsync) ? SYNC : (pixel_on ? WHITE : BLACK);

endmodule // abs_pong_top
