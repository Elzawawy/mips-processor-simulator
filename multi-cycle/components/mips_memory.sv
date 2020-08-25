module mem( input logic clk, reset, memwrite, 
	        input logic [31:0] adr,
			input logic [31:0] writedata, 
			output logic [31:0] readdata);

	logic [31:0] RAM[63:0];
	initial begin
		$readmemh("memfile.dat", RAM);
	end
	assign readdata = RAM[adr[31:2]]; 
	always @(posedge clk)
		if (memwrite)
			RAM[adr[31:2]] <= writedata;
endmodule 