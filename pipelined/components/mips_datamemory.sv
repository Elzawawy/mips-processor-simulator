module dmem(input  logic clk, we,worb,
            input  logic [31:0] a, wd,
            output logic [31:0] rd);
// instantiate RAM object.
  logic [31:0] RAM[63:0];
// assign read data output port from data address input port.
  assign rd = RAM[a[31:2]]; // word aligned
// write to memory if enable input is logic one.
  always @(posedge clk)
    if (we) begin
		if(worb)
			RAM[a[31:2]] [7:0] <= wd[7:0];
		else
      		RAM[a[31:2]] <= wd;
	end
endmodule
