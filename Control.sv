// control decoder
module Control #(parameter opwidth = 3, mcodebits = 3)(//mcodebits originally = 4
  input [mcodebits-1:0] instr,    // subset of machine code (any width you need)
  output logic RegDst, Branch, 
     MemtoReg, MemWrite, ALUSrc, RegWrite, isBranch, isShift, isAdd,
  output logic[opwidth-1:0] ALUOp);	   // for up to 8 ALU operations

always_comb begin
// defaults
  RegDst 	=   'b0;   // 1: not in place  just leave 0
  Branch 	=   'b0;   // 1: branch (jump)
  MemWrite  =	'b0;   // 1: store to memory
  ALUSrc 	=	'b0;   // 1: immediate  0: second reg file output
  RegWrite  =	'b1;   // 0: for store or no op  1: most other operations 
  MemtoReg  =	'b0;   // 1: load -- route memory instead of ALU to reg_file data in
  ALUOp	    =   'b111; // y = a+0;
//section below is added in
  isBranch = 'b0;	// set to 'b1 when you want to enable branching
  isShift = 'b0;	//set to 'b1 when you want to enable shifts
  isAdd = 'b0; //set to 'b1 when you want to do an Add
// sample values only -- use what you need
case(instr)    // override defaults with exceptions
/*
  'b0000:  begin					// store operation
               MemWrite = 'b1;      // write to data mem
               RegWrite = 'b0;      // typically don't also load reg_file
			 end
  'b00001:  ALUOp      = 'b000;  // add:  y = a+b
  'b00010:  begin				  // load
			   MemtoReg = 'b1;    // 
             end
*/
	'b000: begin //add
				ALUOp = 'b000;
				isAdd = 'b1;
			end
	'b001: begin //shift
				ALUOp = 'b001; //shift operation
				isShift = 'b1; //enable shifting
			end
	'b010: begin //XOR
				ALUOp = 'b010; //XOR
			end
	'b011: begin //branching
				ALUOp = 'b011;//branching
				isBranch = 'b1; //enable branching
				RegWrite = 'b0; //disable the regwrite -- GJ
			end
	'b100: begin //load
				ALUOp = 'b100;
				MemtoReg = 'b1;
			end
	'b101: begin //store
				ALUOp = 'b101;
				MemWrite = 'b1;
				RegWrite = 'b0;
				isAdd = 'b0;
			end
	'b110: begin //loadreg
				ALUOp = 'b110;
			end
	'b111: begin //concat
				ALUOp = 'b111; //concat
			end
				
// ...
endcase

end
	
endmodule