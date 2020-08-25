//This is the main decoder of the control unit.
//The controller is an FSM(Finite State Machine).
//The main decoder code follows FSM Verilog code example page 210 Chapter 4.
//The code is divided into 3 main code blocks.
//First block --> state register block (assign state at clock cycle).
//Second block --> next state block (assign next state value depending on current state).
//Third block --> output logic block (assign outputs to states).

module maindec(input logic clk, reset,
			   input logic [5:0] op,
               output logic memtoreg, memwrite, 
			   output logic [1:0] pcsrc, 
			   output logic pcwrite,
			   output logic regdst, regwrite,
			   output logic iord,irwrite,
			   output logic branch,
			   output logic alusrca,
			   output logic [1:0] alusrcb,
               output logic [1:0] aluop);

//S0 --> Fetch state
//S1 --> Decode state
//S2 --> MemAdr state
//S3 --> MemRead state
//S4 --> MemWriteBack state
//S5 --> MemWrite state
//S6 --> Execute state
//S7 --> ALUWriteback state
//S8 --> Branch state 
//S9 --> ADDIEexute state
//S10 --> ADDIWriteback state
//S11 --> JUMP state	   
typedef enum logic [3:0] { S0,S1,S2,S3,S4,S5,S6,S7,S8,S9,S10,S11} mipsstate;
mipsstate currentstate,nextstate;
logic [5:0] oplw,opsw,oprtype,opbeq,opaddi,opj;
logic [14:0] controls;
assign oplw = 6'b100011;
assign opsw = 6'b101011;
assign oprtype = 6'b000000;
assign opbeq = 6'b000100;
assign opaddi = 6'b001000;
assign opj = 6'b000010;
assign {pcwrite,memwrite,irwrite,regwrite,alusrca,branch,iord,memtoreg,regdst,alusrcb,pcsrc,aluop}=controls;

//state register logic 
always_ff @(posedge clk ,posedge reset) begin
	if(reset) currentstate <= S0;
	else currentstate <=nextstate;
end	

//next state logic 
always_comb begin
	case(currentstate)  
		S0 : nextstate <= S1;
		S1 : begin
				if(op == oplw | op == opsw) nextstate <= S2;
				else if(op == oprtype) nextstate <= S6;
				else if(op == opbeq) nextstate <= S8;
				else if(op == opaddi) nextstate <= S9;
				else if(op == opj) nextstate <= S11;
			end
			
		S2 : begin
			if(op == oplw) nextstate <= S3;
			else if (op == opsw) nextstate <= S5;
		end
		S3 : nextstate <= S4;
		S4 : nextstate <= S0;
		S5 : nextstate <= S0;
		S6 : nextstate <= S7;
		S7 : nextstate <= S0;
		S8 : nextstate <= S0;
		S9 : nextstate <= S10;
		S10 : nextstate <= S0;
		S11 : nextstate <= S0;
		default : nextstate <= S0;
	endcase	
end	

//output logic 
always_comb begin
	case(currentstate)
		S0 : controls <= 15'b101_0000_0001_0000;
		S1 : controls <= 15'b000_0000_0011_0000;
		S2 : controls <= 15'b000_0100_0010_0000;
		S3 : controls <= 15'b000_0001_0000_0000;
		S4 : controls <= 15'b000_1000_1000_0000;
		S5 : controls <= 15'b010_0001_0000_0000;
		S6 : controls <= 15'b000_0100_0000_0010;
		S7 : controls <= 15'b000_1000_0100_0000;
		S8 : controls <= 15'b000_0110_0000_0101;
		S9 : controls <= 15'b000_0100_0010_0000;
		S10 : controls <= 15'b000_1000_0000_0000;
		S11 : controls <= 15'b100_0000_0000_1000;
		default : controls <= 15'bxxx_xxxx_xxxx_xxxx;
	endcase
end
endmodule