module mips(input logic  clk, reset, 
		output logic [31:0] pc, 
		input logic [31:0]instr, 
		output logic memwrite, 
		output logic [31:0] aluout, writedata, 
		input logic [31:0] readdata); 
logic memtoreg, alusrc, regdst, regwrite, jump, pcsrc,pcsrc1, zero,zeroextend; 
logic [2:0] alucontrol; 
controller c(instr[31:26], instr[5:0], zero, memtoreg, memwrite, pcsrc,pcsrc1, alusrc,zeroextend,regdst, regwrite, jump, alucontrol); 
datapath dp(clk, reset, memtoreg, pcsrc,pcsrc1, alusrc, regdst,zeroextend,regwrite, jump, alucontrol, zero, pc, instr, aluout, writedata, readdata); 
endmodule