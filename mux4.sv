module mux4 (
  input zero,
  input isBranch,   
  output logic absj);


always_comb begin
  if (zero & isBranch) begin 
    absj = 1'b1;
  end
  else begin
	 absj = 1'b0;
  end
end
 endmodule