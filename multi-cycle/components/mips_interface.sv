module top(	input logic clk, reset,
			output logic [31:0] writedata, adr,
			output logic memwrite);
	logic [31:0] readdata;
	// instantiate processor and memories
	mips mips(clk, reset,readdata, adr, writedata, memwrite);
	mem mem(clk, reset, memwrite, adr, writedata, readdata);
endmodule

