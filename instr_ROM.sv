// lookup table
// deep 
// 9 bits wide; as deep as you wish
module instr_ROM #(parameter D=12)(
  input       [D-1:0] prog_ctr,    // prog_ctr	  address pointer
  output logic[ 8:0] mach_code);

  logic[8:0] core[2**D];
//comment/uncomment as needed

  initial							    // load the program for program 1
    //$readmemb("mach_code.txt",core);
							    // for alu testing
    //$readmemb("mach_code_for_alu.txt",core);
									//for PC testing
	 //$readmemb("mach_code_for_pc.txt",core);
										//for program 2
	 $readmemb("mach_code_prog_3.txt",core);

  always_comb  mach_code = core[prog_ctr];

endmodule


/*
sample mach_code.txt:

001111110		 // ADD r0 r1 r0
001100110
001111010
111011110
101111110
001101110
001000010
111011110
*/