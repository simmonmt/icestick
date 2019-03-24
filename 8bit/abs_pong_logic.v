module ball_logic(clk, reset, ball_hpos, ball_vpos);
   input clk, reset;
   output reg [8:0] ball_hpos;
   output reg [8:0] ball_vpos;

   parameter DISPLAY_WIDTH = 256;
   parameter DISPLAY_HEIGHT = 240;
   parameter BALL_SIZE = 4;

   localparam BALL_HORIZ_INITIAL = DISPLAY_WIDTH / 2;
   localparam BALL_VERT_INITIAL = DISPLAY_HEIGHT / 2;

   reg [8:0] 	    ball_horiz_move;
   reg [8:0] 	    ball_vert_move;

   always @(posedge clk or posedge reset) begin
	if (reset) begin
	   ball_hpos <= BALL_HORIZ_INITIAL;
	   ball_vpos <= BALL_VERT_INITIAL;
	   ball_horiz_move <= 2;
	   ball_vert_move <= -2;
	end else begin
	   ball_hpos <= ball_hpos_next;
	   ball_vpos <= ball_vpos_next;
	   ball_horiz_move <= ball_horiz_move_next;
	   ball_vert_move <= ball_vert_move_next;
	end
   end

   wire ball_horiz_collide = (ball_hpos == 0 || ball_hpos >= DISPLAY_WIDTH - BALL_SIZE);
   wire ball_vert_collide = (ball_vpos == 0 || ball_vpos >= DISPLAY_HEIGHT - BALL_SIZE);

   wire [8:0] ball_horiz_move_next = ball_horiz_collide ? -ball_horiz_move : ball_horiz_move;
   wire [8:0] ball_vert_move_next = ball_vert_collide ? -ball_vert_move : ball_vert_move;

   wire [8:0] ball_hpos_next = ball_hpos + ball_horiz_move_next;
   wire [8:0] ball_vpos_next = ball_vpos + ball_vert_move_next;
endmodule // ball_logic

