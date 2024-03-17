// combinational -- no clock
// sample -- change as desired
module alu(
  input[2:0] alu_cmd,    // ALU instructions
  input[7:0] inA, inB,	 // 8-bit wide data path
  input      sc_i,       // shift_carry in
  output logic[7:0] rslt,
  output logic sc_o,     // shift_carry out
               pari,     // reduction XOR (output)
			   zero      // NOR (output)
);

always_comb begin 
  rslt = 'b0;            
  sc_o = 'b0;    
  zero = !rslt;
  pari = ^rslt;
  case(alu_cmd)
    3'b000: // add increment
		begin
		if (inB[0:0] == 1'b0) begin
			//if (inA == 8'b00000000) begin
			//	rslt = 8'b00000001;
			//end
			//else begin
				rslt = inA + 8'b00000001;
			//end
		end
		else begin
			rslt = 8'b00000000;
		end
		end
	3'b001: // shift, inB has 00000[directionbit][modebit][immediate]
		if (inB[2:2] == 'b0) begin //directionbit = 'b0, shift left
			if (inB[1:1] == 'b0) begin //mode = 0, 0bit shift
				if (inB[0:0] == 'b0) begin //immediate = 0, means shift ONCE
					rslt = {inA[6:0], 1'b0};//000
				end
				else begin //immediate = 1, shift TWICE
					rslt = {inA[5:0], 2'b00};
				end
			end
			else begin //mode = 1, sigbit shift
				if (inB[0:0] == 'b0) begin //immediate = 0, means shift ONCE
					rslt = {inA[6:0], inA[7:7]};
				end
				else begin //immediate = 1, shift TWICE
					rslt = {inA[5:0], inA[7:6]};
				end
			end
		end
		else begin //directionbit = 'b1, shift right
			if (inB[1:1] == 'b0) begin //mode = 0, 0bit shift
				if (inB[0:0] == 'b0) begin //immediate = 0, means shift ONCE
					rslt = {1'b0, inA[7:1]};//100
				end
				else begin //immediate = 1, shift TWICE
					rslt = {2'b00, inA[7:2]};
				end
			end
			else begin //mode = 1, sigbit shift
				if (inB[0:0] == 'b0) begin //immediate = 0, means shift ONCE
					rslt = {inA[0:0], inA[7:1]};
				end
				else begin //immediate = 1, shift TWICE
					rslt = {inA[1:0], inA[7:2]};
				end
			end
		end
      /*begin
		rslt[7:1] = ina[6:0];
		rslt[0]   = sc_i;
		sc_o      = ina[7];
      end*/
    3'b010: // bitwise XOR
	  rslt = inA ^ inB;
    3'b011: // bne, checks if they're the same, branches if nonzero
	  zero = !(inA == inB);
	3'b100: // load
	  rslt = inB;
	  //inB has memory index to take and load into rA
	  //load inA inB,  inA=mem[inB]
	3'b101: // store
	  //rslt = inA;
	  rslt = inA;
	  //inA has memory index to store from rB
	  //store inA inB mem[inA]=inB
	3'b110: // loadreg
	  rslt = inB; //loadreg inA inB puts input from inB into inA
	3'b111: // concat, Notes: IDEALLY before calling concat, have the bits shifted in the order you want to concat them in
		begin
		if (inB[7:1] == 7'b0000000) begin //left 7 bits are 0, concatenate only the last bit
			rslt = {inA[6:0], inB[0:0]};
		end
		else if (inB[7:2] == 6'b000000) begin
			rslt = {inA[5:0], inB[1:0]};
		end
		else if (inB[7:3] == 5'b00000) begin
			rslt = {inA[4:0], inB[2:0]};
		end
		else if (inB[7:4] == 4'b0000) begin
			rslt = {inA[3:0], inB[3:0]};
		end
		else if (inB[7:5] == 3'b000) begin
			rslt = {inA[2:0], inB[4:0]};
		end
		else if (inB[7:6] == 3'b00) begin
			rslt = {inA[1:0], inB[5:0]};
		end
		else if (inB[7:7] == 3'b0) begin
			rslt = {inA[0:0], inB[6:0]};
		end
		else begin
			rslt = inB;
		end
		end
  endcase
end
   
endmodule