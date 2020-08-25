module top(input  logic        clk, reset, 
           output logic [31:0] writedata, dataadr, 
           output logic        memwrite);
//Internal Signals and Buses
logic [31:0] pc, instr, readdata;
logic worb;
//instantiate processor
mips mips(clk, reset, pc, instr, memwrite, dataadr, writedata, readdata,worb);
//instantiate instruction memory
imem imem(pc[7:2], instr);
//instantiate data memory
dmem dmem(clk, memwrite,worb ,dataadr, writedata, readdata);
endmodule
