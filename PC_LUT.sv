module PC_LUT #(parameter D=12)(
  input       [4:0] addr,	   // target 4 values
  output logic[D-1:0] target);

  always_comb case(addr)
    5'b00000: target = 12'b000000100110;   // for program1
    5'b00001: target = 12'b000000101000;   // 40 for prog3
    5'b00010: target = 12'b000011000100;   // 196 for prog3
    5'b00011: target = 12'b000010111000;   // 184 for prog3
    5'b00100: target = 12'b000010101101;   // 173 for prog3
    5'b00101: target = 12'b000010100010;   // 162 for prog3
    5'b00110: target = 12'b000010001111;   // 143 for prog3
    5'b00111: target = 12'b000010001011;   // 139 for prog3
    5'b01000: target = 12'b000001111111;   // 127 for prog3
    5'b01001: target = 12'b000001110010;   // 114 for prog3
    5'b01010: target = 12'b000001100101;   // 101 for prog3
    5'b01011: target = 12'b000001011001;   // 89 for prog3
    5'b01100: target = 12'b000001001100;   // 76 for prog3
	 
    5'b01101: target = 12'b000001000000;   // 64 for prog3
    5'b01110: target = 12'b000000110100;   // 52 for prog3
    5'b01111: target = 12'b000000101101;   // jump to 0 currently used for tb_for_alu
    5'b10000: target = 12'b000000000000;   // jump to 81, to get to add
    5'b10001: target = 12'b000000000000;   // jump to 0
    5'b10010: target = 12'b000000000000;   // jump to 0
    5'b10011: target = 12'b000000000000;   // jump to 0
    5'b10100: target = 12'b000000000000;   // jump to 0
    5'b10101: target = 12'b000000000000;   // jump to 0
    5'b10110: target = 12'b000000000000;   // jump to 0
    5'b10111: target = 12'b000000000000;   // jump to 0
    5'b11000: target = 12'b000000000000;   // jump to 0
    5'b11001: target = 12'b000000000000;   // jump to 0
    5'b11010: target = 12'b000000000000;   // jump to 0
    5'b11011: target = 12'b000000000000;   // jump to 0
    5'b11100: target = 12'b000000000000;   // jump to 0
    5'b11101: target = 12'b000000000000;   // jump to 0
    5'b11110: target = 12'b000000000000;   // jump to 0
    5'b11111: target = 12'b000000000000;   // jump to 0
	default: target = 'b0;  // hold PC  
  endcase

endmodule

/*

	   pc = 4    0000_0000_0100	  4
	             1111_1111_1111	 -1

                 0000_0000_0011   3

				 (a+b)%(2**12)


   	  1111_1111_1011      -5
      0000_0001_0100     +20
	  1111_1111_1111      -1
	  0000_0000_0000     + 0


  */
