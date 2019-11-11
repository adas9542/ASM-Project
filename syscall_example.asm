	.data #where the global varibles are stored

str1:	
	.asciiz "Enter the number: "
	.align 2		#move to a word boundary

res:
	.space 4		#create space for 1 word
	.text 			#where your actual instructioins would be located
	.globl main	

main:
	li $v0, 4		#prints the string from the programmer argument to the console
	la $a0, str1		#a0 =  the address of the string  
	syscall
	
	li $v0, 5		#takes a user input integer from the console
	syscall

	move $t0, $v0		#t0 = the value of t0
	add $t1, $t0, $t0 	#t1 = 2 * t0
	sw $t1, res($0)		#store t1 into the memory
	
	li $v0, 1		#prints the integer to console
	move $a0, $t1
	syscall			
	
	li $v0, 10
	syscall
	