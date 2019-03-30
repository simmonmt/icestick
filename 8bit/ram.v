`ifndef _8BIT_RAM_SYNC_V
`define _8BIT_RAM_SYNC_V

module ram_sync(clk, addr, din, dout, we);
   parameter A = 10;  // number of address bits
   parameter D = 8;   // number of data bits

   input              clk;   // clock
   input      [A-1:0] addr;  // address
   input      [D-1:0] din;   // data input
   output reg [D-1:0] dout;  // data output
   input 	      we;    // write enable

   reg [D-1:0] 	  mem [0:(1<<A)-1];  // (1<<A)xD-bit memory

   always @(posedge clk) begin
      if (we)
	mem[addr] <= din;
      dout <= mem[addr];
   end
endmodule // ram_sync


module ram_async(clk, addr, din, dout, we);
  
  parameter A = 10; // # of address bits
  parameter D = 8;  // # of data bits
  
  input  clk;		// clock
  input  [A-1:0] addr;	// address
  input  [D-1:0] din;	// data input
  output [D-1:0] dout;	// data output
  input  we;		// write enable
  
  reg [D-1:0] mem [0:(1<<A)-1]; // (1<<A)xD bit memory
  
  always @(posedge clk) begin
    if (we)		// if write enabled
      mem[addr] <= din;	// write memory from din
  end

  assign dout = mem[addr]; // read memory to dout (async)

endmodule

/* -----\/----- EXCLUDED -----\/-----
module ram_async_tristate(clk, addr, data, we);
  
  parameter A = 10; // # of address bits
  parameter D = 8;  // # of data bits
  
  input  clk;		// clock
  input  [A-1:0] addr;	// address
  inout  [D-1:0] data;	// data in/out
  input  we;		// write enable
  
  reg [D-1:0] mem [0:(1<<A)-1]; // (1<<A)xD bit memory
  
  always @(posedge clk) begin
    if (we)		 // if write enabled
      mem[addr] <= data; // write memory from data
  end

  assign data = !we ? mem[addr] : {D{1'bz}}; // read memory to data (async)

endmodule
 -----/\----- EXCLUDED -----/\----- */

`endif // _8BIT_RAM_SYNC_V
