module blinker(input clk,
	       output D0,
	       output LED1,
	       output LED2,
	       output LED3,
	       output LED4,
	       output LED5);

   reg [23:0] 		  counter;

   assign {LED5, LED4, LED3, LED2, LED1} = 0;

   assign D0 = counter[23];

   always @(posedge clk)
     begin
	counter <= counter + 1;
     end
endmodule // blinker
