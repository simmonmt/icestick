`include "8bit/startup.v"

`define assert(signal, value) \
        if (signal !== value) begin \
            $display("ASSERTION FAILED in %m: signal != value"); \
            $display("time is %t", $time); \
            $finish_and_return(1); \
        end

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


