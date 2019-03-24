`include "8bit/abs_pong_logic.v"
`include "8bit/testutil.v"

module test;
   reg reset = 0;

   initial begin
      #   0 reset = 1;
      #   5 reset = 0;
      #  95 $stop;
   end

   initial begin
      #   5 `assert(ball_hpos, 10);
      #  25 `assert(ball_hpos, 16);
      #  10 `assert(ball_hpos, 18);
      #  10 `assert(ball_hpos, 16);
   end

   initial begin
      #   5 `assert(ball_vpos, 10);
      #  35 `assert(ball_vpos, 2);
      #  10 `assert(ball_vpos, 0);
      #  10 `assert(ball_vpos, 2);
   end

   reg clk = 0;
   always #5 clk = !clk;

   wire [8:0] ball_hpos;
   wire [8:0] ball_vpos;

   ball_logic #(20, 20, 2) uut(.clk(clk),
			       .reset(reset),
			       .ball_hpos(ball_hpos),
			       .ball_vpos(ball_vpos));

   initial
     $monitor("time %4t / clk %d r %d / hpos %d mv %x c %d / vpos %d mv %x c %d",
	      $time, clk, reset,
	      ball_hpos, uut.ball_horiz_move, uut.ball_horiz_collide,
	      ball_vpos, uut.ball_vert_move, uut.ball_vert_collide);


endmodule // test

				     

   
