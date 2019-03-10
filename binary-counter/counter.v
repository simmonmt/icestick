module binary_counter(input clk,
		      output reg D5,
		      output reg D4,
		      output reg D3,
		      output reg D2,
		      output reg D1);
   reg [23:0] counter;
   
   assign {D5,D4,D3,D2,D1} = counter[23:19];

   always @(posedge clk)
     begin
	counter <= counter + 1;
     end
endmodule

   
		     
