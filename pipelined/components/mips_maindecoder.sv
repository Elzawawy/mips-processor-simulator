module maindec(input logic [5:0] opD,functD,
			   output logic [1:0] memtoregD, 
			   output logic memwriteD, 
			   output logic branchD,alusrcD,
			   output logic [1:0] regdstD, 
			   output logic regwriteD, 
			   output logic jumpD, 
			   output logic [1:0] aluopD,
			   output logic branchneD,
			   output logic  jumppcD);
logic [12:0] controls;
assign {regwriteD, regdstD, alusrcD, branchD, memwriteD, memtoregD, jumpD, aluopD,branchneD,jumppcD}=controls;
always_comb 
	case(opD) 
		6'b000000: 
			case(functD)
				6'b011000: controls <= 13'b0000000000000;  //MULT
				6'b011010: controls <= 13'b0000000000000;  //DIV
				6'b010000: controls <= 13'b1010001000000;  //MFHI
				6'b010010: controls <= 13'b1010001000000;  //MFLO
				6'b010000: controls <= 13'b0000000100001;  //JR
				default :  controls <= 13'b1010000001000;  // ALL OTHER RTYPE
			endcase
		6'b100011: controls <= 13'b1001000100000; 	// LW 
		6'b101011: controls <= 13'b0001010000000; 	// SW 
		6'b000100: controls <= 13'b0000100000100; 	// BEQ 
		6'b000101: controls <= 13'b0000000000110;	// BNE
		6'b001000: controls <= 13'b1001000000000; 	// ADDI 
		6'b001010: controls <= 13'b1001000001100;  	// SLTI
		6'b000010: controls <= 13'b0000000010000; 	// J
		6'b000011: controls <= 13'b1100000010000;   //JAL
		6'b100000: controls <= 13'b1001001100000;   //LB
		6'b101000: controls <= 13'b0001011100000;	//SB
		
		default:   controls <= 13'bxxxxxxxxxxxxx; // illegal op 
	endcase 
endmodule



