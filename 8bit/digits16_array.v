`ifndef _8BIT_DIGITS16_ARRAY_V
`define _8BIT_DIGITS16_ARRAY_V

// A character generator for digits 0-9A-F.
module digits16_array(digit, yoff, bits);
   input  [3:0] digit;  // digit 0-15
   input  [2:0] yoff;   // vertical offset 0-4
   output [4:0] bits;   // output, oriented for LSB-first reading

   reg [4:0] 	bitarray[0:15][0:4]; // ROM array (16 x 5 x 5 bits)

   initial begin
      $readmemb("8bit/digits5x5.txt", bitarray);
   end

   assign bits = (yoff < 5 && digit < 16) ? bitarray[digit][yoff] : 0;
endmodule

`endif
