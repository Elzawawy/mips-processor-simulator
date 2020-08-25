module hazardunit(input logic branchD,
				  input logic [4:0] RsD,RtD,RsE,RtE,
				  input logic [4:0] writeregE,
				  input logic [1:0] memtoregE,
				  input logic regwriteE,
				  input logic [4:0] writeregM,
				  input logic [1:0] memtoregM,
				  input logic regwriteM,
				  input logic [4:0] writeregW,
				  input logic regwriteW,
				  output logic stallF,stallD,
				  output logic forwardAD,forwardBD,
				  output logic flushE,
				  output logic [1:0] forwardAE,forwardBE,
				  input logic branchneD,jumppcD);

logic lwstallD, branchstallD;
//forwarding sources to Decode Stage.
assign forwardAD = (RsD != 0) & (RsD == writeregM) & regwriteM; 
assign forwardBD = (RtD != 0) & (RtD == writeregM) & regwriteM;

// forwarding sources to Execute stage.
always_comb begin
	forwardAE = 2'b00; 
	forwardBE = 2'b00;
	//SrcA Logic
	if (RsE != 0)
		if ((RsE == writeregM )& regwriteM)
			forwardAE = 2'b10;
		else if ((RsE == writeregW) & regwriteW)
			forwardAE = 2'b01;
	//SrcB Logic
	if (RtE != 0)
		if ((RtE == writeregM )& regwriteM)
			forwardBE = 2'b10;
	else if ((RtE == writeregW) & regwriteW)
			forwardBE = 2'b01;
end

// Stalling 
assign #1 lwstallD = memtoregE[0] & (RtE == RsD | RtE == RtD);
assign #1 lbstallD = memtoregE[0] & (RtE == RsD | RtE == RtD);
assign #1 branchstallD = (branchD | branchneD | jumppcD) & (regwriteE & (writeregE == RsD | writeregE == RtD) |
									memtoregM[0] &(writeregM == RsD | writeregM == RtD));
assign #1 stallD = lwstallD | branchstallD | lbstallD;
assign #1 stallF = stallD;

// stalling D stalls all previous stages
assign #1 flushE = stallD;
endmodule

