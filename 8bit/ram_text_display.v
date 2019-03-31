`include "8bit/digits16_array.v"
`include "8bit/hvsync_generator_adafruit.v"
`include "8bit/ram.v"
`include "8bit/startup.v"

module ram_text_display_top(clk, out, led);
   input clk;
   output [1:0] out;
   output [4:0] led;

   reg 	  clk2;
   always @(posedge clk) begin
      clk2 <= !clk2;
   end

   assign led = 0;  // otherwise they'll flicker

   ram_text_display display(clk2, out);
endmodule // ram_text_display_top

module ram_text_display(clk, out);
   input clk;
   output [1:0] out;

   localparam SYNC =0;
   localparam BLACK = 1;
   localparam GRAY = 2;
   localparam WHITE = 3;

   wire reset;
   startup startup (.clk(clk),
		    .reset(reset));

   wire       hsync, vsync;
   wire       display_on;
   wire [8:0] hpos;
   wire [8:0] vpos;

   hvsync_generator_adafruit_911
         hvsync_gen (.clk(clk),
		     .reset(reset),
		     .hsync(hsync),
		     .vsync(vsync),
		     .display_on(display_on),
		     .hpos(hpos),
		     .vpos(vpos));

   wire [9:0] 	ram_addr;
   wire [7:0] 	ram_read;   // Value read from RAM
   reg [7:0] 	ram_write;  // Value to write to RAM
   reg 		ram_writeenable = 0;

   // RAM to hold 32x32 array of bytes.
   //
   // The book uses a synchronous RAM, but that doesn't work in practice on the
   // icestick (it seems to work on the 8bitworkshop IDE though). The
   // synchronous RAM can't read the new value fast enough -- it needs an extra
   // clock cycle. A synchronous RAM would work if we prefetched, but we don't
   // do in this example.
   ram_async ram(.clk(clk),
		.dout(ram_read),
		.din(ram_write),
		.addr(ram_addr),
		.we(ram_writeenable));

   localparam CHAR_MULT = 3;

   wire [4:0] 	row = vpos[7:CHAR_MULT+2];       // 4-bit row, vpos / 8
   wire [4:0] 	col = hpos[7:CHAR_MULT+2];       // 4-bit col, hpos / 8
   wire [2:0] 	rom_yoff = vpos[CHAR_MULT+1:CHAR_MULT-1]; // scanline of cell
   wire [4:0] 	rom_bits;              // 5 pixels per scanline

   assign ram_addr = {row, col};

   wire [3:0] 	digit = ram_read[3:0];
   wire [2:0] 	rom_xoff = hpos[CHAR_MULT+1:CHAR_MULT-1];

   // True if this is the first pixel for a given value of rom_xoff in the
   // current digit. CHAR_MULT means there can be multiple pixels used for each
   // value of rom_xoff.
   wire 	rom_xoff_start = (CHAR_MULT == 1) ? 1 : (hpos[CHAR_MULT-2:0] == 0);

   digits16_array numbers(.digit(digit),
			  .yoff(rom_yoff),
			  .bits(rom_bits));

   // Used to throttle the value updates. If we don't, it'll update every frame.
   reg [4:0] 	frame;
   always @(posedge vsync)
     frame <= frame + 1;

   // update_trigger is true if we should be evaluating for animation. It will
   // be true one scanline per digit (which isn't the same as one rom_yoff value
   // per digit due to CHAR_MULT), and on that scanline, for one pixel for each
   // distinct value of xoff.
   wire 	vertical_update_trigger = vpos[CHAR_MULT+1:0] == 7 << (CHAR_MULT-1);
   wire 	horiz_update_trigger = rom_xoff_start;
   wire 	update_trigger = vertical_update_trigger && horiz_update_trigger;

   // Increment the current RAM cell so we get some animation.
   always @(posedge clk)
     if (display_on && frame == 0 && update_trigger)
       case (rom_xoff)
	 6: begin
	    // update_trigger is especially important for this increment because
	    // it ensures that we only hit this case once per digit. If we
	    // didn't have it, we'd update the value more than once per digit.
	    ram_write <= ram_read + 1;
	    ram_writeenable <= 1;
	 end
	 7: ram_writeenable <= 0;
       endcase

   wire 	pixel_on = display_on && rom_xoff < 5 && rom_bits[rom_xoff];
   assign out = (hsync||vsync) ? SYNC : (pixel_on ? WHITE : BLACK);

endmodule  // ram_text_display
