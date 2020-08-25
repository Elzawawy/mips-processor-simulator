//Full adder Building Block
module adder(input logic [31:0] a, b, 
			 output logic [31:0] y); 
	assign y=a+b; 
endmodule

//Left Shifter by 2 (Multiply by 4) Building Block
module sl2(input logic [31:0] a, 
		   output logic [31:0] y); 
    assign y={a[29:0], 2'b00}; 
endmodule

//Sign extender Building Block
module signext(input logic [15:0] a, 
			   output logic [31:0] y); 
	assign y={{16{a[15]}}, a}; 
endmodule

//zero extend Building Block
module zeroext(input logic [15:0] a,
			   output logic [31:0] y);
	assign y= {{16{0}},a};
endmodule

//Register File Flipflop
module flopr #(parameter WIDTH=8) (input logic clk, reset, 
								   input logic [WIDTH-1:0] d, 
								   output logic [WIDTH-1:0] q);
always_ff @(posedge clk, posedge reset) 
	if (reset) q <= 0; 
	else q <= d; 
endmodule

//Multiplexer Building Block
module mux2 #(parameter WIDTH=8) (input logic [WIDTH-1:0] d0, d1, 
								  input logic s, 
								  output logic [WIDTH-1:0] y);
	assign y=s ? d1 : d0; 
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