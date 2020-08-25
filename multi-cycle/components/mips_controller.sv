module controller(input logic clk, reset,
				  input logic[5:0] op, funct,
				  input logic zero,
				  output logic iord, memwrite, irwrite, regdst,
				  output logic memtoreg, regwrite, alusrca,
				  output logic [1:0] alusrcb,
		          output logic [2:0] alucontrol,
				  output logic [1:0] pcsrc,
				  output logic pcen);
	
	logic [1:0] aluop;
	logic branch, pcwrite;
	maindec md(clk, reset,op, memtoreg, memwrite, pcsrc, pcwrite, regdst,
				regwrite, iord, irwrite, branch, alusrca, alusrcb, aluop);
	aludec ad(funct, aluop, alucontrol);
	assign pcen = (branch & zero) | pcwrite;
endmodule
