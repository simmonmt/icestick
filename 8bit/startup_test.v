`include "8bit/startup.v"
`include "8bit/testutil.v"

module test;
   initial begin
      # 0 `assert(reset, 1)
      # 1 `assert(reset, 1)
      # 10 `assert(reset, 0)
      # 100 $stop;
   end

   reg clk = 0;
   always #10 clk = !clk;

   wire reset;

   startup startup(.clk(clk),
		   .reset(reset));

   initial
     $monitor("At time %t, clk is %h, reset is %v", $time, clk, reset);

endmodule // test


