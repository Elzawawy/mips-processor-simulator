module testbench();
	logic clk;
	logic reset;
	logic [31:0] writedata, adr;
	logic memwrite;
	// instantiate device to be tested
	top dut (clk, reset, writedata, adr, memwrite);
	// initialize test
	initial	begin
		reset <= 1; # 22; reset <= 0;
	end
	// generate clock to sequence tests
	always begin
		clk <= 1; # 5; clk <= 0; # 5;
	end
	// check results
	always @(negedge clk) begin
		if (memwrite) begin
			if (adr===84 & writedata===7) begin
				$display("Simulation succeeded");
				$stop;
			end else if (adr !==80) begin
				$display("Simulation failed");
				$stop;
			end
		end
	end
endmodule 
