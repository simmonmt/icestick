`include "8bit/digits16_array.v"
`include "8bit/hvsync_generator.v"

module test_digits_top(clk, out);
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

   wire [3:0] digit = hpos[7:4];
   wire [2:0] digit_yoff = vpos[3:1];  // 2x size
   wire [2:0] digit_xoff = hpos[3:1];  // 2x size
   wire [4:0] digit_bits;

   digits16_array digits(.digit(digit),
			 .yoff(digit_yoff),
			 .bits(digit_bits)
			 );

   wire       pixel_on = display_on && digit_xoff < 5 && digit_bits[digit_xoff];

   assign out = (hsync||vsync) ? SYNC : (pixel_on ? WHITE : BLACK);

endmodule // test_digits_top

