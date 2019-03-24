`ifndef _8BIT_TESTUTIL_V
`define _8BIT_TESTUTIL_V

`define assert(signal, value) \
        if (signal !== value) begin \
            $display("ASSERTION FAILED in %m: signal != value"); \
            $display("time is %t", $time); \
            $finish_and_return(1); \
        end

// iVerilog gets upset if there's no module defined. Remove this
// module if/when we define another module in this file.
module nop();
endmodule // nop

`endif //  `ifndef _8BIT_TESTUTIL_V
