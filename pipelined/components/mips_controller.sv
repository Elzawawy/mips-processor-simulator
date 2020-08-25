module controller(input  logic clk, reset,
		  input  logic [5:0] opD, functD,
		  input  logic flushE, equalD,
		  output logic [1:0] memtoregE,memtoregM,memtoregW,
		  output logic memwriteM,
		  output logic [1:0] pcsrcD,
		  output logic branchD, alusrcE,
		  output logic [1:0] regdstE,regdstW,
		  output logic regwriteE,regwriteM,regwriteW,
		  output logic jumpD,
		  output logic [2:0] alucontrolE,
		  output logic branchneD,
		  output logic worb,
		  output logic jumppcD);
//------------------Internal Signals and Buses--------------------------------------------------
logic regwriteD ,memwriteD ,alusrcD;   //Decode Stage Signals.
logic [2:0] alucontrolD;
logic [1:0] aluopD,memtoregD,regdstD,regdstM;
logic memwriteE;					   //Execute Stage Signals.
//------------------Main Decoder module (outputs the Decode Stage Signals)-----------------------
maindec md(opD,functD,memtoregD, memwriteD, branchD , alusrcD , regdstD , regwriteD , jumpD , aluopD,branchneD,jumppcD); 
//-----------------ALU Decoder module(outputs the Decode Stage Signals)-------------------------
aludec ad(functD, aluopD, alucontrolD);
//Assign pcsrcD bus value to choose the next PC logic.
assign pcsrcD[0]=(branchD & equalD) | (branchneD & ~equalD);
assign pcsrcD[1]= jumpD;
//Assign worb bus value
assign worb=memtoregM[0] & memtoregM[1];
//-----------------Execute Stage pipeline register-------------------------------------------------
floprc #(10) regE(clk, reset, flushE,{memtoregD, memwriteD, alusrcD, regdstD, regwriteD, alucontrolD},
				    {memtoregE, memwriteE, alusrcE,regdstE, regwriteE, alucontrolE});
//-----------------Memory Stage pipeline register--------------------------------------------------
flopr #(6) regM(clk, reset,{memtoregE, memwriteE, regwriteE,regdstE},
			   {memtoregM, memwriteM, regwriteM,regdstM});
//-----------------Write-back Stage pipeline register----------------------------------------------
flopr #(5) regW(clk, reset,{memtoregM, regwriteM,regdstM},
			   {memtoregW, regwriteW,regdstW});
//-------------------------------------------------------------------------------------------------
endmodule