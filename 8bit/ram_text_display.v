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

   // RAM to hold 32x32 array of bytes
   ram_sync ram(.clk(clk),
		.dout(ram_read),
		.din(ram_write),
		.addr(ram_addr),
		.we(ram_writeenable));

   wire [4:0] 	row = vpos[7:3];       // 5-bit row, vpos / 8
   wire [4:0] 	col = hpos[7:3];       // 5-bit col, hpos / 8
   wire [2:0] 	rom_yoff = vpos[2:0];  // scanline of cell
   wire [4:0] 	rom_bits;              // 5 pixels per scanline

   assign ram_addr = {row, col};

   wire [3:0] 	digit = ram_read[3:0];
   wire [2:0] 	xoff = hpos[2:0];

   digits16_array numbers(.digit(digit),
			  .yoff(rom_yoff),
			  .bits(rom_bits));

   reg [3:0] 	frame = 0;
   always @(posedge vsync)
     frame <= frame + 1;

   // increment the current RAM cell so we get some animation
   always @(posedge clk)
     case (xoff)
       6: begin  // on 7th pixel of cell
	  ram_write <= (ram_read + 1);
	  ram_writeenable <= (rom_yoff == 7 && frame == 0);  // only on last scanline of cell
       end
       7: begin  // on 8th pixel of cell
	  ram_writeenable <= 0;
       end
     endcase // case (xoff)

   wire 	pixel_on = display_on && xoff < 5 && rom_bits[xoff];
   assign out = (hsync||vsync) ? SYNC : (pixel_on ? WHITE : BLACK);
endmodule  // ram_text_display
