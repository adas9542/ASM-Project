#simple counting for loop and a conditional if and else statement
.data
L1: 	.word 0x44 22 33 55	#array input

.text
.globl main

main:
	la, $t0, L1 # t0 = address of L1
	li $t1, 4   # t1 = 4 so we can intilize loop count
	add $t2, $t2, $0 # t2 is intialized to the be the output sum and has the value 0
 
loop:
	lw $t3, 0($t0) #load the first element onto t3
	add $t2, $t2, $t3 # add t3 into the sum output
	addi $t0, $t0, 4 #go to the second address in t0/ point to the next word
	addi $t1, $t1, -1 # decrement the loop count by 1
	bne $t1, $0, loop # if t1 != 0 go to the top of the loop
	
	bgt $t2, $0, then #if t2 is greater than 0 then jump to then statement
	move $s0, $t2	#put the value of t2 (the sum)into s0 
	j exit	#exit 

then: 	
	move $s1, $t2 #when the sum is greater than 0 the value will be copied to s1

exit:	
	li $v0, 10
	syscall