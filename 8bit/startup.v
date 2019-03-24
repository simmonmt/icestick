`ifndef _8BIT_STARTUP_V
`define _8BIT_STARTUP_V

module startup(clk, reset);
   input clk;
   output reset;

   reg [1:0] counter = 0;
   wire [1:0] counter_next;

   assign reset = !counter[0] && !counter[1];

   assign counter_next = counter == 2'b11 ? 2'b11 : counter + 1;

   always @(posedge clk)
     counter <= counter_next;
endmodule // startup


`endif
