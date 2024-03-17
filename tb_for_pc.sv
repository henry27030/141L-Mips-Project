module tb_for_pc();

bit   clk    ,                   // clock source -- drives DUT input of same name
	  req  ;	                 // req -- start program -- drives DUT input
wire  done;		    	         // ack -- from DUT -- done w/ program

// program 1-specific variables
bit  [11:1] d1_in[15];           // original messages
bit         p0, p8, p4, p2, p1;  // Hamming block parity bits
bit  [15:0] d1_out[15];          // orig messages w/ parity inserted
bit  [15:0] score1, case1;

// your device goes here
// change "top_level" if you called your device something different
// explicitly list ports if your names differ from test bench's
// if you used any parameters, override them here
top_level DUT(.clk(clk), .req(req), .done(done), .reset(req));            // replace "proc" with the name of your top level module last one was .ack, .clk, .start, .done

initial begin
  for(int i=0;i<15;i++)	begin
    d1_in[i] = $random>>4;        // create 15 messages	   '1    '0
// copy 15 original messages into first 30 bytes of memory 
// rename "dm1" and/or "core" if you used different names for these
    DUT.dm1.core[i+1]  = {5'b0,d1_in[i][11:9]};
    DUT.dm1.core[i]    =       d1_in[i][ 8:1];
  end
  #10ns req   = 1'b1;          // pulse request to DUT
  #10ns req   = 1'b0;
  $display(" starting!");
  wait(done);
  $display("going through 30 instructions on PC, incrementing the index to write to mem, write 8'b00000001 to mem[30]");
  $display("increment again, write same 1 bit to mem[31]");
  $displayb({8'b00000001, 8'b00000001});//[31] is r1, [30] is r1 (which was added once)
  $writeb  (DUT.dm1.core[31]);
  $displayb(DUT.dm1.core[30]);
    if({DUT.dm1.core[31],DUT.dm1.core[30]} == {8'b00000001, 8'b00000001}) begin
      $display("we have a match, PC can iterate through simple instructions and change memory accordingly");
    end
  $display("incrementing r8 by 10 to check bne, branch until r1 == r8");
  $displayb(8'b00001010);
  $displayb  (DUT.dm1.core[32]);
    if(DUT.dm1.core[32] == 8'b00001010) begin
      $display("we have a match, PC behaves correctly during branching with absolute jumps");
    end
  #10ns $stop;
end

always begin
  #5ns clk = 1;            // tic
  #5ns clk = 0;			   // toc
end										

endmodule