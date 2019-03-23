module binary_counter(input clk,
		      output D5,
		      output D4,
		      output D3,
		      output D2,
		      output D1);
   reg [23:0] counter;
   
   assign {D5,D4,D3,D2,D1} = counter[23:19];

   always @(posedge clk)
     begin
	counter <= counter + 1;
     end
endmodule

   
		     
