`include "8bit/abs_pong_logic.v"
`include "8bit/testutil.v"

module test;
   reg reset = 0;

   initial begin
      #   0 reset = 1;
      #   5 reset = 0;
      #  35 `assert(ball_hpos, 18);
      #  10 `assert(ball_hpos, 16);
      # 100 $stop;
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
     $monitor("time %4t / clk %d / hpos %d mv %x c %d / hpos %d mv %x c %d",
	      $time, clk,
	      ball_hpos, uut.ball_horiz_move, uut.ball_horiz_collide,
	      ball_vpos, uut.ball_vert_move, uut.ball_vert_collide);


endmodule // test

				     

   
