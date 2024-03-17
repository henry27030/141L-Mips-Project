// sample top level design
module top_level(
  input        clk, reset, req, 
  output logic done);
  parameter D = 12,             // program counter width
    A = 3;             		  // ALU command bit width
  wire[D-1:0] target, 			  // jump 
              prog_ctr;
  wire        RegWrite;
  wire        isShift; //ADDED
  wire        isBranch; //ADDED
  wire        isAdd; //ADDED
  wire[7:0]   datA,datB, InALUB,		  // from RegFile
              muxB, 
			  rslt,               // alu output
			  readout, //ADDED, dat_mem output
			  toRegWrite,
              immed;
  logic sc_in,   				  // shift/carry out from/to ALU
   		pariQ,              	  // registered parity flag from ALU
		zeroQ;                    // registered zero flag from ALU 
  wire  relj;                     // from control to PC; relative jump enable
  wire  pari,
        zero,
		sc_clr,
		sc_en,
		absj, //added
        MemWrite,
		 MemtoReg, //ADDED 
        ALUSrc;		              // immediate switch
  wire[A-1:0] alu_cmd;
  wire[8:0]   mach_code;          // machine code
  wire[3:0] rd_addrA, rd_addrB;    // address pointers to reg_file was [2:0]
  assign absj = zero & isBranch;
// fetch subassembly
  PC #(.D(D)) 					  // D sets program counter width
     pc1 (.reset (reset)            ,
         .clk (clk)              ,
		 .reljump_en (relj),
		 .absjump_en (absj),
		 .target (target)           ,
		 .prog_ctr (prog_ctr)          );

// lookup table to facilitate jumps/branches
  PC_LUT #(.D(D))
    pl1 (.addr  (mach_code[5:1]),
         .target (target)          );   

// contains machine code
  instr_ROM ir1(.prog_ctr(prog_ctr),
               .mach_code(mach_code));

// control decoder
  Control ctl1(.instr(mach_code[8:6]),
  .RegDst  (RegDst), 
  .Branch  (relj)  , 
  .MemWrite (MemWrite), 
  .ALUSrc   (ALUSrc), 
  .RegWrite   (RegWrite),     
  .MemtoReg(MemtoReg),
  .ALUOp(ALUOp), 
  .isBranch(isBranch), 
  .isShift(isShift),
  .isAdd (isAdd));

  assign alu_cmd  = mach_code[8:6];
  //assign rd_addrA = {1'b0, mach_code[5:3]};
  //assign rd_addrB = {1'b0, mach_code[2:0]};
  
  mux1 mu1 (.mach_code(mach_code), //goes into reg_file
  .isBranch(isBranch), 
  .isShift(isShift), 
  .isAdd(isAdd), 
  .InRegA(rd_addrA), 
  .InRegB(rd_addrB));

  reg_file #(.pw(4)) rf1(.dat_in(toRegWrite),	   // loads, most ops, WAS regfile_dat, WAS readout
              .clk(clk)         ,
              .wr_en   (RegWrite),
              .rd_addrA(rd_addrA),
              .rd_addrB(rd_addrB),
              .wr_addr (rd_addrA),      // in place operation, CHANGED from rd_addrB
              .datA_out(datA),
              .datB_out(datB)); 

  mux2 mu2 (.mach_code(mach_code), //goes into alu
  .rd_addrB(datB), 
  .isShift(isShift), 
  .isAdd(isAdd),  
  .InALUB(InALUB));

  alu alu1(.alu_cmd(alu_cmd),
       .inA    (datA),
		 .inB    (InALUB),//was (muxB)
		 .sc_i   (sc),   // output from sc register
		 .rslt    (rslt),//was blank
		 .sc_o   (sc_o), // input to sc register
		 .pari, 
		 .zero(zero));  
	//assign muxB = datB;
	//assign absj = zero & isBranch;
/*
  mux4 mu4 (.zero(zero), //goes into reg from dat_mem and alu
  .isBranch(isBranch), 
  .absj(absj));
  */
  dat_mem dm1(.dat_in(datB)  ,  // from reg_file, was datB, this is what is stored into memory
          .clk(clk)           ,
			 .wr_en  (MemWrite), // stores
			 .addr   (rslt), //was rslt
          .dat_out(readout)); //was readout

  mux3 mu3 (.fromALU(rslt), //goes into reg from dat_mem and alu
  .fromdat_mem(readout),
  .MemtoReg(MemtoReg), 
  .toReg(toRegWrite));

// registered flags from ALU
  always_ff @(posedge clk) begin
    pariQ <= pari;
	zeroQ <= zero;
    if(sc_clr)
	  sc_in <= 'b0;
    else if(sc_en)
      sc_in <= sc_o;
  end

  assign done = prog_ctr == 500; //was 128
  //assign done = 'b1;
 
endmodule