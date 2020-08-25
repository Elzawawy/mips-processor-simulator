module datapath( 
			  input logic clk, reset, pcen,
			  input logic iord, irwrite, regdst,
			  input logic memtoreg, regwrite, alusrca,
		      input logic [1:0] alusrcb,
		      input logic [2:0] alucontrol,
		      input logic [1:0] pcsrc,
		      input logic [31:0] readdata,
		      output logic [5:0] op, funct,
              output logic zero,
		      output logic [31:0] adr,
		      output logic [31:0] writedata );
logic [31:0] pc,pcnext;
logic [31:0] address,aluout;
logic [31:0] instr,data;
logic [4:0] writereg;
logic [31:0] wd3,rd1,rd2;
logic [31:0] avalue;
logic [31:0] srca,srcb;
logic [31:0] signimm,shiftimm;
logic [31:0] aluresult,jumpadr;
assign op = instr[31:26];
assign funct = instr[5:0];
assign jumpadr = {pc[31:28],instr[25:0],2'b00};
flopenr #(32) pcreg(clk,reset,pcen,pcnext,pc);
mux2 #(32)  memmux(pc,aluout,iord,adr);
flopenr #(32) instrreg(clk,reset,irwrite,readdata,instr);
flopenr #(32) datareg(clk,reset,1'b1,readdata,data);
mux2 #(5) a3mux(instr[20:16],instr[15:11],regdst,writereg);
mux2 #(32) wd3mux(aluout,data,memtoreg,wd3);
regfile rf(clk,regwrite,instr[25:21],instr[20:16],writereg,wd3,rd1,rd2);
flopenr #(32) areg(clk,reset,1'b1,rd1,avalue);
flopenr #(32) breg(clk,reset,1'b1,rd2,writedata);
mux2 #(32) srcamux(pc,avalue,alusrca,srca);
signext se(instr[15:0],signimm);
sl2 shift(signimm,shiftimm);
mux4 #(32) srcbmux(writedata,32'b100,signimm,shiftimm,alusrcb,srcb);
alu alu(srca,srcb,alucontrol,aluresult,zero);
flopenr #(32) alureg(clk,reset,1'b1,aluresult,aluout);
mux3 #(32) pcmux(aluresult,aluout, jumpadr,pcsrc,pcnext);



endmodule