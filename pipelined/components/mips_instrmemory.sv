module imem(input  logic [5:0]  a,
            output logic [31:0] rd);
// instantiate RAM object to hold instructions machine code.
  logic [31:0] RAM[63:0];
// load machine code file into RAM object.
  initial
    begin
      $readmemh("memfile.dat",RAM);
    end
// assignj readdata port output value from input data address port.
  assign rd = RAM[a];
endmodule
