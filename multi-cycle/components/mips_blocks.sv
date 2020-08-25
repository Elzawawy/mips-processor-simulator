module flopenr #(parameter WIDTH=8)
			(input logic clk,reset,
			 input logic enable,
			 input logic [WIDTH-1:0] d,
			 output logic [WIDTH-1:0] q);
			 
always_ff @(posedge clk,posedge reset)
	if(reset) q <= 0;
	else begin 
		if(enable) q <= d;
	end
endmodule


module mux2 #(parameter WIDTH=8)
			(input logic [WIDTH-1:0] d0,d1,
			 input logic select,
			 output logic [WIDTH-1:0] result);

assign result=select ? d1 : d0;
endmodule

module mux3 #(parameter WIDTH=8)

			(input logic [WIDTH-1:0] d0,d1,d2,
			 input logic [1:0] select,
			 output logic [WIDTH-1:0] result);
assign #1 result = select[1] ? d2 : (select[0] ? d1 : d0 );
			 
endmodule

module mux4 #(parameter WIDTH=8)
			(input logic [WIDTH-1:0] d0,d1,d2,d3,
			 input logic [1:0] select,
			 output logic [WIDTH-1:0] result);
always_comb
	case(select) 	
		2'b00: result <= d0;
		2'b01: result <= d1;
		2'b10: result <= d2;
		2'b11: result <= d3;
	endcase
			 
endmodule			 
module regfile (input logic clk,
				input logic we3,
				input logic [4:0] a1,a2,a3,
				input logic [31:0] wd3,
				output logic [31:0] rd1,rd2);
logic [31:0] rf[31:0];
always_ff @(posedge clk)
	if(we3) rf[a3] <= wd3;
	
assign rd1 = (a1 !=0) ? rf[a1] :0;
assign rd2 = (a2 !=0) ? rf[a2] :0;
endmodule

module sl2(input logic [31:0] a, 
		   output logic [31:0] y); 
// shift left by 2 
assign y={a[29:0], 2'b00}; 
endmodule

module signext(input logic [15:0] a, 
			   output logic [31:0] y); 
			   
assign y={{16{a[15]}}, a}; 
endmodule

//ALU Building Block
module alu(input logic [31:0] a, b, //ALU_inputs. 
input logic [2:0] f,		        //ALU_control_bit to control ALU operation.
output logic [31:0] y,		        //ALU_output.
output logic zero);                 //Zero_indicator_bit to indicate zero value output.

//This is switch case on the control bits that control the operation of the ALU.
always @(f,a,b)
	begin
	case(f)
	//AND_operation
	0: y <= a & b;
	//OR_operation
	1: y <= a | b;
	//ADD_operation
	2: y <= a + b;                                           
	//SUB_operation
	6: y <= a +(~b+1);
	//SLT_operation
	7: begin 
		if (a[31] != b[31]) begin
					if (a[31] > b[31]) begin
						y <= 1;
					end else begin
						y <= 0;
					end
				end else begin
					if (a < b)
					begin
						y <= 1;
					end
					else
					begin
						y <= 0;
					end
				end
           end
	endcase
	end

//Checking the zero flag bit that indicate the zero value output
always @(y) 
	begin
	if (y == 0) begin
			zero <= 1;
	end else begin
			zero <= 0;
	end
	
	end
endmodule
