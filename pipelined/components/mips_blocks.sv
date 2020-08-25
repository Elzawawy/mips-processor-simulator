//Register File Flipflop
module flopr #(parameter WIDTH = 8)
              (input  logic  clk, reset,
               input  logic [WIDTH-1:0] d, 
               output logic [WIDTH-1:0] q);

  always_ff @(posedge clk, posedge reset)
    if (reset) q <= 0;
    else       q <= d;
endmodule

//REGISTER WITH CLEAR ADDED 
module floprc #(parameter WIDTH = 8) (input  logic clk, reset,
                 input  logic clear,
                 input  logic [WIDTH-1:0] d, 
                 output logic [WIDTH-1:0] q);
 
  always_ff @(posedge clk, posedge reset)
    if      (reset) q <= 0;
    else if (clear) q <= 0;
    else    q <= d;
endmodule
//REGISTER WITH ENABLE 
module flopenr #(parameter WIDTH = 8)
                (input  logic  clk, reset,
                 input  logic  en,
                 input  logic [WIDTH-1:0] d, 
                 output logic [WIDTH-1:0] q);
 
  always_ff @(posedge clk, posedge reset)
    if      (reset) q <= 0;
    else if (en)    q <= d;
endmodule

//REGISTER WITH CLEAR AND ENABLE
module flopenrc #(parameter WIDTH = 8)
                 (input  logic clk, reset,
                  input  logic en,clear,
                  input  logic [WIDTH-1:0] d, 
                  output logic [WIDTH-1:0] q);
 
  always_ff @(posedge clk, posedge reset)
    if      (reset) q <= 0;
    else if (clear) q <= 0;
    else if (en)    q <= d;
endmodule


//2 input MUX
module mux2 #(parameter WIDTH=8)
			(input logic [WIDTH-1:0] d0,d1,
			 input logic select,
			 output logic [WIDTH-1:0] result);

assign result=select ? d1 : d0;
endmodule

//3 input MUX
module mux3 #(parameter WIDTH=8)

			(input logic [WIDTH-1:0] d0,d1,d2,
			 input logic [1:0] select,
			 output logic [WIDTH-1:0] result);
assign #1 result = select[1] ? d2 : (select[0] ? d1 : d0 );
			 
endmodule

// 4 input MUX
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
//REGISTER FILE
module regfile(input  logic        clk, 
               input  logic        we3, 
               input  logic [4:0]  ra1, ra2, wa3, 
               input  logic [31:0] wd3, 
               output logic [31:0] rd1, rd2);

  logic [31:0] rf[31:0];

  // for pipelined processor, write third port
  // on falling edge of clk

  always_ff @(negedge clk)
    if (we3) rf[wa3] <= wd3;	
    assign rd1 = (ra1 != 0) ? rf[ra1] : 0;
    assign rd2 = (ra2 != 0) ? rf[ra2] : 0;
endmodule

module sl2(input logic [31:0] a, 
		   output logic [31:0] y); 
// shift left by 2 
assign y={a[29:0], 2'b00}; 
endmodule
//Generic sign extender
module signext #(parameter WIDTH = 8)
				(input logic [WIDTH-1:0] a, 
			   output logic [31:0] y); 
			   
assign y={{32-WIDTH{a[WIDTH-1]}}, a}; 
endmodule
//Dedicated Equality Comparator
module eqcmp #(parameter WIDTH = 8)
             (input  logic [WIDTH-1:0] d0, d1, 
              output logic  y);

  assign #1 y = (d0 === d1) ? 1 : 0;
endmodule

//ADDER Building Block
module adder(input logic [31:0] a, b, 
			 output logic [31:0] y); 
	assign y=a+b; 
endmodule
//ALU Building Block
module alu(input logic [31:0] a, b, //ALU_inputs. 
input logic [2:0] f,		        //ALU_control_bit to control ALU operation.
output logic [31:0] y,
input logic [4:0] shamt);		        //ALU_output          

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
	//SLL_operation
	4: y <= b << shamt;
	//SRL_operation
	5: y <= b >> shamt;	
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

endmodule
