module coprocessor (input logic [31:0] srca,srcb, 		// rs --> srca , rt --> srcb
					input logic [5:0] functD,
					output logic [31:0] hilo);
logic [31:0] hi,lo;
always_comb 
	case(functD)
		6'b011000: {hi,lo} <= srca*srcb;  	//MULT
		6'b011010: begin lo <= srca / srcb; //DIV
						 hi <= srca % srcb;
				   end
		6'b010000: hilo <= hi;
		6'b010010: hilo <= lo;
	endcase
endmodule