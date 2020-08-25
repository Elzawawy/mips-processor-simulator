//Processor Module "mips" 
//Inputs are the outputs from the memory module.
//Outputs are the inputs to the memory module.
//Since there are 2 memory systems we are dealing with 2 Stages signals and buses : Fetch Stage and Memory Stage.
//Signals and buses sent internally to the controller and data-path are either Decode Stage or Execute Stage.
module mips(
		input logic  clk, reset,
	    output logic [31:0] pcF,
       	input logic  [31:0] instrF,
	    output logic memwriteM,
	    output logic [31:0] aluoutM, writedataM,
	    input logic  [31:0] readdataM,
		output logic worb);
//--------------------------------Internal Signals and Buses--------------------------------------------------		
logic [5:0] opD, functD;
logic alusrcE,regwriteE, regwriteM, regwriteW;
logic [1:0] memtoregE, memtoregM, memtoregW;
logic [1:0] pcsrcD,regdstE,regdstW;
logic [2:0] alucontrolE;
logic flushE, equalD;
//------------------------------------Controller--------------------------------------------------------------
controller c(clk, reset, opD, functD, flushE,
	     equalD,memtoregE, memtoregM,
	     memtoregW, memwriteM, pcsrcD,
         branchD,alusrcE, regdstE,regdstW,regwriteE,
	     regwriteM, regwriteW, jumpD,
	     alucontrolE,branchneD,worb,jumppcD);											
//---------------------------------Data-path------------------------------------------------------------------	
datapath dp(clk, reset, memtoregE, memtoregM,
	    memtoregW, pcsrcD, branchD,
         alusrcE, regdstE,regdstW,regwriteE,
	    regwriteM, regwriteW, jumpD,
	    alucontrolE,equalD, pcF, instrF,
	    aluoutM, writedataM, readdataM,
	    opD, functD, flushE,branchneD,jumppcD);	 
//-------------------------------------------------------------------------------------------------------------			
endmodule