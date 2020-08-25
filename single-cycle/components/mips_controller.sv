module controller(input logic [5:0] op, funct, 
				  input logic zero, 
				  output logic memtoreg, memwrite, 
				  output logic pcsrc,pcsrc1,alusrc,
				  output logic zeroextend,
				  output logic regdst, regwrite, 
				  output logic jump, 
				  output logic [2:0] alucontrol);
logic [1:0] aluop; 
logic branch;
logic branchne;
maindec md(op, memtoreg, memwrite, branch,branchne,alusrc,zeroextend,regdst, regwrite, jump, aluop); 
aludec ad(funct, aluop, alucontrol);
assign pcsrc=branch & zero; 
assign pcsrc1 = branchne & (~zero);
endmodule