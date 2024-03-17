module tb_for_alu();

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
  $display("testing store and both add types:");
  $displayb({8'b00000011, 8'b00000000});//[31] is add 3 times, [30] is add 0
  $writeb  (DUT.dm1.core[31]);
  $displayb(DUT.dm1.core[30]);
    if({DUT.dm1.core[31],DUT.dm1.core[30]} == {8'b00000011, 8'b00000000}) begin
      $display(" we have a match!");
      score1++;
		case1++;
    end
  $display("testing store and all shifts: left, right, logical shift, 0bit:");
  $displayb({8'b00000011, 8'b10000001}); //from [31], [33] is left shift logical, [32] is right shift logical
  $writeb  (DUT.dm1.core[33]);
  $displayb(DUT.dm1.core[32]);
    if({DUT.dm1.core[33],DUT.dm1.core[32]} == {8'b00000011, 8'b10000001}) begin
      $display(" we have a match!");
      score1++;
		case1++;
    end
  $displayb({8'b00000010, 8'b00000001}); //from [33], [35] is left shift 0bit, [34] is right shift 0bit
  $writeb  (DUT.dm1.core[35]);
  $displayb(DUT.dm1.core[34]);
    if({DUT.dm1.core[35],DUT.dm1.core[34]} == {8'b00000010, 8'b00000001}) begin
      $display(" we have a match!");
      score1++;
		case1++;
    end
  $display("testing store, XOR, loadreg, load:"); //from [35], load r2=mem[35], r2=8'b0...10, loadreg r3, r2, store r3 into [36], r3 xor r2 store into [37]
  $displayb({8'b00000000, 8'b00000010});
  $writeb  (DUT.dm1.core[37]);
  $displayb(DUT.dm1.core[36]);
    if({DUT.dm1.core[37],DUT.dm1.core[36]} == {8'b00000000, 8'b00000010}) begin
      $display(" we have a match!");
      score1++;
		case1++;
    end
  $display("alu testbench score = %d out of %d",score1,case1);
  
  

  #10ns $stop;
end





/*
  for(int i=0;i<15;i++)	begin
    d1_in[i] = $random>>4;        // create 15 messages	   '1    '0
// copy 15 original messages into first 30 bytes of memory 
// rename "dm1" and/or "core" if you used different names for these
    DUT.dm1.core[2*i+1]  = {5'b0,d1_in[i][11:9]};
    DUT.dm1.core[2*i]    =       d1_in[i][ 8:1];
  end
  #10ns req   = 1'b1;          // pulse request to DUT
  #10ns req   = 1'b0;
  $display(" starting!");
  wait(done);                   // wait for ack from DUT
  $display(" startingPart2!");
// generate parity for each message; display result and that of DUT
  $display("start program 1");
  $display();
  for(int i=0;i<15;i++) begin
    p8 = ^d1_in[i][11:5];
    p4 = (^d1_in[i][11:8])^(^d1_in[i][4:2]); 
    p2 = d1_in[i][11]^d1_in[i][10]^d1_in[i][7]^d1_in[i][6]^d1_in[i][4]^d1_in[i][3]^d1_in[i][1];
    p1 = d1_in[i][11]^d1_in[i][ 9]^d1_in[i][7]^d1_in[i][5]^d1_in[i][4]^d1_in[i][2]^d1_in[i][1];
    p0 = ^d1_in[i]^p8^p4^p2^p1;  // overall parity (16th bit)
// assemble output (data with parity embedded)
    $displayb ({d1_in[i][11:5],p8,d1_in[i][4:2],p4,d1_in[i][1],p2,p1,p0});
    $writeb  (DUT.dm1.core[31+2*i]);
    $displayb(DUT.dm1.core[30+2*i]);
    if({DUT.dm1.core[31+2*i],DUT.dm1.core[30+2*i]} == {d1_in[i][11:5],p8,d1_in[i][4:2],p4,d1_in[i][1],p2,p1,p0}) begin
      $display(" we have a match!");
      score1++;
    end
    else
      $display("erroneous output");   
    $display();
    case1++;
  end
  $display("program 1 score = %d out of %d",score1,case1);
  #10ns $stop;
end
*/
always begin
  #5ns clk = 1;            // tic
  #5ns clk = 0;			   // toc
end										

endmodule