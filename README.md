# 141L-Mips-Project
Summary: Hardware created to handle certain bit functions
with limited instruction bits(up to 9).

machine type: register-register/load-store type of machine
registers used r0->r8, 
only add can modify r8,
bne only compares with 1 bit register (r1 or r0)

instruction formats and supported operations and bit breakdown:
supported operations: add, shift, XOR, bne, load, store, 
loadreg, concat
add (increment or reset to 0):
ex: add r8 #0
3 bit opcode, 4 bit register, 1'b0, 1 bit mode

XOR (dest reg = dest reg XOR src reg)
ex: XOR r1 r0, 

loadreg (dest reg = src reg)
ex: loadreg r3 r2, 

concat (append all bits to the right of and including
src reg value's most significant nonzero to dest reg's value and left shift)
ex: concat r5 r4, 

load (dest reg = [src reg])
ex: load r7 r6, 

store ([dest reg] = src reg)
ex: store r6 r7:

bit breakdown for XOR, loadreg, concat, load, store:
3 bit opcode, 3 bit destination register, 3 bit source register

bne (branch if r8 != 1 bit register):
ex: bne #31 r1
3 bit opcode, 5 bit lookup index, 1 bit register

shift (shift left or right by 1 or 2 with 0 bit shifting or appending to other side):
shift #1 #1 r3 #1
3 bit opcode, 1 bit direction, 1 bit mode, 3 bit register, 
1 bit intermediate
(direction 0=left, 1=right)
(mode 0=shift and push 0's in, 1=shift and append 
bit you shifted off)

branching logic: use bne to compare r0 or r1 with a r8, 
which can only be changed through add 
(can reset to 0 or increment)

assembly code explanation:
obtain data with load, store results with store, manipulate with other operations
we use bne to branch and to have a pseudo jump, we bne where the single bit register
we compare with is definitely not equal to r8 (such as resetting r1 before comparing to a nonzero r8)

prog 1 assmebly explanation: use bne to loop through mem and for every iteration:
calculate the parities and store the 16 bits in appropriate memory

prog 3 assembly explanation: use bne to loop through mem and in our iterations through mem, 
first calculate the 5-bit occurrences to store in mem[33], 
then in that iteration, increment value only once to store in mem[34] if any occurrence is found,
then calculate the 5 bit occurrences between the current 8 bit memory and the next 8 bit memory, 
add to what you found to store in mem[33] and store in mem[35] the overall occurrences

testbench explanation:
we used the testbenches prog1.tb, prog2.tb, prog3.tb given)
prog 1: randomly generates b11 through b1 in mem, runs program 1, and line by line, 
compares calculated parities with what is stored by program 1 in mem

prog 3: generate mem[0:32] and calculate in test bench for bytes to store in [33], [34], [35]
then run program 3 and compare with [33], [34], [35]

evaluate performance of processor:
This processor is a register-register/load-store type of machine, so most of the math is done 
by register-register in these programs.
With this processor, memory accesses (which are costly) are only necessary to load in data and store to memory.
Since these programs only load and store to memory not very often, the processor runs well for these programs.
