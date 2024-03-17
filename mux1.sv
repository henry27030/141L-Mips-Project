module mux1 (
  input[8:0] mach_code, 
  input      isBranch, 
  input      isAdd,
  input      isShift, 
  output logic[3:0] InRegA, // read data
  output logic[3:0] InRegB);


always_comb begin
    InRegA = {1'b0, mach_code[5:3]};
	 InRegB = {1'b0, mach_code[2:0]};
    if(isBranch) begin //branch case
      InRegA = 4'b1000; //check r8
      InRegB = {3'b000, mach_code[0:0]};//B contains 1bit reg to check
    end
	 else begin //not branch
      if (!isShift) begin
		  if (!isAdd) begin //regular case
		    InRegA = {1'b0, mach_code[5:3]};
			 InRegB = {1'b0, mach_code[2:0]};
		  end
		  else begin //add
          InRegA = mach_code[5:2]; //4 bit reg
			 InRegB = {1'b0, mach_code[5:3]}; //unused in add, change the output instead
        end
		end
		else begin //shift
		  InRegA = {1'b0, mach_code[3:1]}; //register
		  InRegB = {1'b0, mach_code[5:3]}; //unused in shift, change the output instead
		end
    end
  end
 endmodule