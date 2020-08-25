module datapath(input logic clk, reset,
		input logic [1:0] memtoregE, memtoregM, memtoregW,
		input logic [1:0] pcsrcD, 
		input logic branchD,
		input logic alusrcE,
		input logic [1:0] regdstE,regdstW,
		input logic regwriteE, regwriteM, regwriteW,
		input logic jumpD,
		input logic [2:0] alucontrolE,
		output logic equalD,
		output logic [31:0] pcF,
		input logic [31:0] instrF,
		output logic [31:0] aluoutM, writedataM,
		input logic [31:0] readdataM,
		output logic [5:0] opD, functD,
		output logic flushE,
		input logic branchneD,jumppcD);
//---------------------------Internal Signals and Buses-------------------------------------------
	logic forwardAD, forwardBD;
	logic [1:0] forwardAE, forwardBE;
	logic stallF;
	logic [4:0] RsD, RtD, RdD, RsE, RtE, RdE;
	logic [4:0] shamtD,shamtE;
	logic [5:0] functE;
	logic [4:0] writeregE, writeregM, writeregW;
	logic flushD;
	logic [31:0] pcnextF, pcbranchD;
	logic [31:0] signimmD, signimmE, signimmshD;
	logic [31:0] srcaD, srca2D, srcaE, srca2E;
	logic [31:0] srcbD, srcb2D, srcbE, srcb2E, srcb3E;
	logic [31:0] pcplus4F, pcplus4D,pcplus4E,pcplus4M,pcplus4W,instrD;
	logic [31:0] aluoutE, aluoutW;
	logic [31:0] readdataW, resultW,bytedataW;
	logic [31:0] hiloE,hiloM,hiloW;
	logic [31:0] jumpaddress;
	logic [31:0] aluorjalW;
//---------------------------Hazard Unit---------------------------------------------------------
hazardunit h(branchD , RsD, RtD, RsE, RtE, writeregE, memtoregE,regwriteE,
			 		   writeregM,memtoregM,regwriteM,
			 		   writeregW,regwriteW,
			 		   stallF,stallD,forwardAD,forwardBD,
			 		   flushE,forwardAE,forwardBE,branchneD,jumppcD);
//---------------------------Next PC Logic (Fetch and Decode Stage)------------------------------
mux2 #(32) pcmux1({pcplus4D[31:28],instrD[25:0],2'b00},srca2D,jumppcD,jumpaddress);
mux3 #(32) pcmux2(pcplus4F, pcbranchD,jumpaddress, pcsrcD,pcnextF);
//register file
regfile rf(clk, regwriteW, RsD, RtD, writeregW,resultW, srcaD, srcbD);
//Fetch Stage Logic
flopenr #(32) pcreg(clk, reset,~stallF,pcnextF, pcF); 
adder pcadd(pcF, 32'b100, pcplus4F); 
//--------------------------Register File logic (Decode Stage)-----------------------------------
//pipeline registers 
flopenrc #(32) reg1D(clk, reset, ~stallD,flushD, pcplus4F,pcplus4D);
flopenrc #(32) reg2D(clk, reset, ~stallD, flushD, instrF,instrD);
//Immediate Handling
signext #(16) se(instrD[15:0], signimmD);
sl2 immsh(signimmD, signimmshD);
adder pcadd2(pcplus4D, signimmshD, pcbranchD);
//Branch Forwarding Handling 
mux2 #(32) rd1mux(srcaD, aluoutM, forwardAD,srca2D);
mux2 #(32) rd2mux(srcbD, aluoutM, forwardBD,srcb2D);
eqcmp #(32) comp(srca2D, srcb2D, equalD);
//Declaration of Buses.
assign opD = instrD[31:26];
assign functD = instrD[5:0];
assign RsD = instrD[25:21];
assign RtD = instrD[20:16];
assign RdD = instrD[15:11];
assign shamtD= instrD[10:6];
assign flushD = pcsrcD[0] | pcsrcD[1] ;
//--------------------------Execute Stage--------------------------------------------------------
//pipeline registers
floprc #(32) reg1E(clk, reset, flushE, srcaD, srcaE);
floprc #(32) reg2E(clk, reset, flushE, srcbD, srcbE);
floprc #(5)  reg3E(clk, reset, flushE, RsD, RsE);
floprc #(5)  reg4E(clk, reset, flushE, RtD, RtE);
floprc #(5)  reg5E(clk, reset, flushE, RdD, RdE);
floprc #(32) reg6E(clk, reset, flushE, signimmD, signimmE);
floprc #(5)  reg7E(clk, reset, flushE, shamtD, shamtE);
floprc #(32) reg8E(clk, reset, flushE, pcplus4D,pcplus4E);
floprc #(6) reg9E(clk, reset, flushE, functD, functE);
//Data Forwarding Handling
mux3 #(32) forwardmux1(srcaE, resultW, aluoutM,forwardAE, srca2E);
mux3 #(32) forwardmux2(srcbE, resultW, aluoutM,forwardBE, srcb2E);
//ALU Logic 
mux2 #(32) srcbmux(srcb2E, signimmE, alusrcE,srcb3E);
alu alu(srca2E, srcb3E, alucontrolE, aluoutE,shamtE);
coprocessor copo(srca2E,srcb2E,functE,hiloE);
mux3 #(5)  wrmux(RtE, RdE,5'b11111,regdstE, writeregE);
//-------------------------Memory Stage-----------------------------------------------------------
//pipeline registers
//srcb2E == writedataE
flopr #(32) reg1M(clk, reset, srcb2E, writedataM);
flopr #(32) reg2M(clk, reset, aluoutE, aluoutM);
flopr #(5)  reg3M(clk, reset, writeregE, writeregM);
flopr #(32) reg4M(clk, reset, hiloE, hiloM);
flopr #(32) reg5M(clk, reset, pcplus4E, pcplus4M);
//-----------------------Write-back Stage----------------------------------------------------------
//pipeline registers
flopr #(32) reg1W(clk, reset, aluoutM, aluoutW);
flopr #(32) reg2W(clk, reset, readdataM, readdataW);
flopr #(5)  reg3W(clk, reset, writeregM, writeregW);
flopr #(32) reg4W(clk, reset, hiloM, hiloW);
flopr #(32) reg5W(clk, reset, pcplus4M, pcplus4W);
//Write-back address logic
signext #(8) worbse(readdataW[7:0],bytedataW);
mux2 #(32) jalmux(aluoutW,pcplus4W,regdstW[1],aluorjalW);
mux4 #(32) resmux(aluorjalW, readdataW,hiloW,bytedataW,memtoregW,resultW);
endmodule