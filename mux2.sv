module mux2 (
  input[8:0] mach_code,
  input[7:0] rd_addrB,  
  input      isShift,
  input      isAdd, 
  output logic[7:0] InALUB);


always_comb begin
	if (isShift) begin
		InALUB = {5'b00000, mach_code[5:4], mach_code[0]};
	end
	else begin
		if (isAdd) begin
			InALUB = {7'b0000000, mach_code[0:0]};
		end
		else begin //not add nor shift
			InALUB = rd_addrB;
		end
	end
  end
 endmodule