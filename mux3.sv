module mux3 (
  input[7:0] fromALU,
  input[7:0] fromdat_mem,  
  input      MemtoReg, 
  output logic[7:0] toReg);


always_comb begin
  if (MemtoReg) begin 
    toReg = fromdat_mem;
  end
  else begin
    toReg = fromALU;
  end
end
 endmodule