#simple array of readin operands from memory and writing back to a reserved space in memory

.data #where global variables are stored (similar to the start of a class)
L1: .word 0x2345 #L1 is now a 32 bit container for the hex value
L2: .word 0x33667 #L2 is now a 32 bit container for the hex value
Res: .space 8 #reserve 4 bytes or 1 word 

.text #where your actual instructions are (similar to a function or method call)
.globl main

main: 	lw $t0, L1($0)
	lw $t1, L2($0)
	and $t2, $t0, $t1
	or $t3, $t0, $t1
	sw $t3, Res($0)
	
	li $v0, 10
	syscall #control all user input and output operations and ends the program 
		#all of the input and output operations happen on the console

