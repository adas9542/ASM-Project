#K-means algorithm implementation

#1) euclidean distance

.data
welcome: .asciiz "---------- K-means algorithm------------\n   \n\n"
prompt_d: .asciiz " Enter 10 data points\n"
prompt_c: .asciiz " Enter 2 centroids \n"
x1: .asciiz "x1: "
y1: .asciiz "y1: "
x2: .asciiz "x2: "
y2: .asciiz "y2: "

A: .word 0, 0
B: .word 0, 0
C: .word 0, 0
D: .word 0, 0
E: .word 0, 0
F: .word 0, 0
G: .word 0, 0
H: .word 0, 0
I: .word 0, 0
J: .word 0, 0
centroid_1: .word 0, 0  
centroid_2: .word 0, 0

newline: .asciiz "\n"
tab: .asciiz "\t"
E_dist_msg: .asciiz "\n-- Euclidean Distance --"
result: .asciiz "!!!!!!!!!!!!!!! Results !!!!!!!!!!!!!!!!!"
comma: .asciiz ","
updated_clusters: .asciiz "\n\n**************** updated clusters ****************\n"
datapoint_input_label: .byte 'A','B','C','D','E','F','G','H','I','J',0
x_label: .asciiz "(x, ): "
y_label: .asciiz "( ,y): "
print_c1: .asciiz "\ncluster 1: "
print_c2: .asciiz "\ncluster 2: "
print_cd1: .asciiz "centroid 1: "
print_cd2: .asciiz "centroid 2: "
cluster_1_dataPoint_names: .byte ' ',' ',' ',' ',' ',' ',' ',' ',' ',' ',0
cluster_2_dataPoint_names: .byte ' ',' ',' ',' ',' ',' ',' ',' ',' ',' ',0
cluster_1: .word 0, 0, 0, 0, 0, 0, 0, 0, 0, 0  # stores address of data points
cluster_2: .word 0, 0, 0, 0, 0, 0, 0, 0, 0, 0   # stores address of data points



.text
.globl main

main:

	#printing welcome note
	li $v0,4
	la $a0,welcome
	syscall
    # get input of 10 datapoints
    li $v0,4
	la $a0,prompt_d
	syscall
    jal input_dataPoints
    # get input of 2 centroids
    li $v0,4
    la $a0,newline
    syscall
    li $v0,4
	la $a0,prompt_c
	syscall
    jal input_centroid

    # print results label, 
    li $v0,4
	la $a0,result
	syscall

    # make clusters 
    la $a0,cluster_1
    la $a1,cluster_2
    la $a2,cluster_1_dataPoint_names
    la $a3,cluster_2_dataPoint_names
    jal make_clusters
    
    #print centroids
    li $v0,4
    la $a0,newline
    syscall
    li $v0,4
    la $a0,print_cd1
    syscall
    la $a0,centroid_1
    jal print_centroid
    li $v0,4
    la $a0,newline
    syscall
    li $v0,4
    la $a0,print_cd2
    syscall
    la $a0,centroid_2 
    jal print_centroid

    #pirnt clusters
    li $v0,4
    la $a0,print_c1
    syscall
    la $a0,cluster_1_dataPoint_names
    jal print_cluster
    li $v0,4
    la $a0,print_c2
    syscall
    la $a0,cluster_2_dataPoint_names
    jal print_cluster
  
    #update centroid 1
    la $a0,cluster_1
    la $a1, centroid_1
    jal update_centroid
    #update centroid 2    
    la $a0,cluster_2
    la $a1, centroid_2
    jal update_centroid


    #make clusters with updated centroids
    li $v0,4
	la $a0,updated_clusters
	syscall
    la $a0,cluster_1
    la $a1,cluster_2
    la $a2,cluster_1_dataPoint_names
    la $a3,cluster_2_dataPoint_names
    jal make_clusters

    
    #print updated centroids
    li $v0,4
    la $a0,print_cd1
    syscall
    la $a0,centroid_1
    jal print_centroid
    li $v0,4
    la $a0,newline
    syscall
    li $v0,4
    la $a0,print_cd2
    syscall
    la $a0,centroid_2 
    jal print_centroid
    #pirnt new clusters
    li $v0,4
    la $a0,print_c1
    syscall
    la $a0,cluster_1_dataPoint_names
    jal print_cluster
    li $v0,4
    la $a0,print_c2
    syscall
    la $a0,cluster_2_dataPoint_names
    jal print_cluster  
    


li $v0,10   # ending the entire program!
syscall

 # ---------------------- End of Main ---------------------------- #

input_dataPoints:

    la $s0,datapoint_input_label
    la $s1,A
    li $s2,1
  datpoint_loop:

    bgt $s2,10,exit_datpoint_loop
     
    li $v0,11
    lb $a0, ($s0)
    syscall
    li $v0,4
    la $a0, x_label
    syscall
    li $v0,5    # read user input, input returned in $v0
    syscall
    sw $v0,($s1)
    # ----- taking y coordinate -------- #
    addi $s1,$s1,4  # address of 'A' moved from x to y, we keep adding 4 in it, means it will move to B, then C and so on.
    li $v0,11
    lb $a0, ($s0)
    syscall
    li $v0,4
    la $a0, y_label
    syscall
    li $v0,5    # read user input, input returned in $v0
    syscall
    sw $v0,($s1)
    li $v0,4
    la $a0, newline
    syscall
    addi $s0,$s0,1  # moving datapoint_input_label to next stored label
    addi $s2,$s2,1
    addi $s1,$s1,4
    j datpoint_loop
    exit_datpoint_loop:

jr $ra

input_centroid:

    la $s1,centroid_1

    li $v0,4
    la $a0, print_cd1
    syscall
    li $v0,4
    la $a0, x_label
    syscall
    li $v0,5    # read user input, input returned in $v0
    syscall
    sw $v0,($s1)
    # ----- taking y coordinate -------- #
    addi $s1,$s1,4  # address of 'A' moved from x to y, we keep adding 4 in it, means it will move to B, then C and so on.
    li $v0,4
    la $a0, print_cd1
    syscall
    li $v0,4
    la $a0, y_label
    syscall
    li $v0,5    # read user input, input returned in $v0
    syscall
    sw $v0,($s1)
    li $v0,4
    la $a0, newline
    syscall

    la $s1,centroid_2

    li $v0,4
    la $a0, print_cd2
    syscall
    li $v0,4
    la $a0, x_label
    syscall
    li $v0,5    # read user input, input returned in $v0
    syscall
    sw $v0,($s1)
    # ----- taking y coordinate -------- #
    addi $s1,$s1,4  
    li $v0,4
    la $a0, print_cd2
    syscall
    li $v0,4
    la $a0, y_label
    syscall
    li $v0,5    # read user input, input returned in $v0
    syscall
    sw $v0,($s1)
    li $v0,4
    la $a0, newline
    syscall

jr $ra

print_centroid:
    
    move $s0,$a0
    li $v0,1
    lw $a0,($s0)
    syscall
    li $v0,4
    la $a0,comma
    syscall
    li $v0,1
    lw $a0,4($s0)
    syscall

jr $ra    

print_cluster:
    move $s0,$a0
    move $t2,$zero
    li $t3,32
    for_loop:
        bgt $t2,9,end_for_loop
        lb $a0,($s0)
        beq $a0,$t3,else_pc
            li $v0,11
            syscall
            li $v0,4
            la $a0,comma
            syscall
        else_pc:    
        addi $s0,$s0,1
        addi $t2,$t2,1
    j for_loop
    end_for_loop:

jr $ra

update_centroid:
    # preparing X Coordinate of Centroid 1
    move $s0,$a0
    move $s1,$zero	 # register to store the sum
    li $t3,1
    move $t4, $zero	#count variable, used to divide
    loop:
        bgt $t3,9,end_loop #exit loop if t3 > 10
        lw $t0,($s0) # fetch address of data points (A, B, C)
        beq $t0,$zero,else # if(t1!=0) sum += t1, else: don't add
            lw $t1,($t0) # fetch data (x coordinate) stored in points  
            add $s1,$s1,$t1   # adding the x coordinates and putting in s1 register
            addi $t4,$t4,1
        else:
        addi $s0,$s0,4  #updating the cluster_1 array
        addi $t3,$t3,1  # lopp iterator
        j loop
    end_loop:
    div $s1,$t4		#taking average
    mflo $s1
     # preparing Y Coordinate of Centroid 1
    move $s0,$a0
    move $s2,$zero # register to store the sum
    li $t3,1
    move $t4, $zero	#count variable, used to divide
    loop2:
        bgt $t3,9,end_loop2 #exit loop if t3 > 10
        lw $t0,($s0) # fetch address of data points (A, B, C)
        beq $t0,$zero,else2 # if(t1!=0) sum += t1, else: don't add
            lw $t1,4($t0) # fetch data (x coordinate) stored in points  
            add $s2,$s2,$t1   # adding the x coordinates and putting in s1 register
            addi $t4,$t4,1
        else2:
        addi $s0,$s0,4  #updating the cluster_1 array
        addi $t3,$t3,1  # lopp iterator
        j loop2
    end_loop2:
    div $s2,$t4		#taking average
    mflo $s2
    #now $s1 contains x coordinte, $s2 contains y coordinate (updating the centroid)
    move $s0,$a1
    sw $s1,($s0)
    sw $s2,4($s0)
    
jr $ra


make_clusters:
	li $s0,4
    move $s3,$a0    # address of cluster_1 in $s3
    move $s4,$a1    # address of cluster_2 in $s4
    move $s5,$a2    # address of cluster_1_point_names in $s3
    move $s6,$a3    # address of cluster_2_point_names in $s4
    move $s7,$ra # save the original value of $ra to get back to main, $ra will be changed later!
    #printing centroids label
    li $v0,4
    la $a0, E_dist_msg
    syscall
    li $v0,4
    la $a0, newline
    syscall
    li $v0,4
    la $a0, tab
    syscall
    li $v0,4
    la $a0, print_cd1
    syscall
    li $v0,4
    la $a0, print_cd2
    syscall
    li $v0,4
    la $a0, newline
    syscall
    # passing arguments in $a registers and calling Eculidean_Distance
    lw $a0,A($0)  # point A(2,2)
    lw $a1,A($s0)
    lw $a2,centroid_1($0)    # centroid E(2,4)
    lw $a3,centroid_1($s0)
    jal Eculidean_Distance  # returns distance in $v0
    move $v1,$v0            # saving result in $v1, so that we can call function again, and function will again return value in $v0
    lw $a0,A($0)  # point A(2,2)
    lw $a1,A($s0)
    lw $a2,centroid_2($0)    # centroid I(6,2)
    lw $a3,centroid_2($s0)
    jal Eculidean_Distance  # returns distance in $v0
    slt $t0,$v0,$v1  # if distance of A - E is less than A -I, jump to cluster_1 label to put A in cluster 1
    # --- printing eculidean distance of point with two centroids ---!
    move $t4,$v0 
    li $v0,11
    li $a0,'A'
    syscall 
    li $v0,4
    la $a0, tab
    syscall
    li $v0,1
    move $a0, $v1
    syscall
    li $v0,4
    la $a0, tab
    syscall
    li $v0,1
    move $a0, $t4
    syscall
    li $v0,4
    la $a0, newline
    syscall
    # ---- printing ends here ---
    la $s1,A
    li $a0,'A'
    jal save_ra  # $v0 contains the return address, #$ra is in original value
    beq $t0,$zero,Lbl_cluster_1  
    bne $t0,$zero,Lbl_cluster_2 # $v1 has original $ra, $ra has current address
    move $ra,$v1        # restroing original value of $ra
# -----------------------
    lw $a0,B($0)  # point A(2,2)
    lw $a1,B($s0)
    lw $a2,centroid_1($0)    # centroid E(2,4)
    lw $a3,centroid_1($s0)
    jal Eculidean_Distance  # returns distance in $v0
    move $v1,$v0            # saving result in $v1, so that we can call function again, and function will again return value in $v0
    lw $a0,B($0)  # point A(2,2)
    lw $a1,B($s0)
    lw $a2,centroid_2($0)    # centroid I(6,2)
    lw $a3,centroid_2($s0)
    jal Eculidean_Distance  # returns distance in $v1
    slt $t0,$v0,$v1  # if distance of A - E is less than A -I, jump to cluster_1 label to put A in cluster 1 
    # --- printing eculidean distance of point with two centroids ---!
    move $t4,$v0 
    li $v0,11
    li $a0,'B'
    syscall 
    li $v0,4
    la $a0, tab
    syscall
    li $v0,1
    move $a0, $v1
    syscall
    li $v0,4
    la $a0, tab
    syscall
    li $v0,1
    move $a0, $t4
    syscall
    li $v0,4
    la $a0, newline
    syscall
    # ---- printing ends here ---
    la $s1,B
    li $a0,'B'
    jal save_ra  # $v0 contains the return address, #$ra is in original value
    beq $t0,$zero,Lbl_cluster_1  
    bne $t0,$zero,Lbl_cluster_2 # $v1 has original $ra, $ra has current address
    move $ra,$v1
    #-------------------------
    lw $a0,C($0)  # point A(2,2)
    lw $a1,C($s0)
    lw $a2,centroid_1($0)    # centroid E(2,4)
    lw $a3,centroid_1($s0)
    jal Eculidean_Distance  # returns distance in $v1
    move $v1,$v0            # saving result in $v0, so that we can call function again, and function will again return value in $v0
    lw $a0,C($0)  # point A(2,2)
    lw $a1,C($s0)
    lw $a2,centroid_2($0)    # centroid I(6,2)
    lw $a3,centroid_2($s0)
    jal Eculidean_Distance  # returns distance in $v1
    slt $t0,$v0,$v1  # if distance of A - E is less than A -I, jump to cluster_1 label to put A in cluster 1 
    # --- printing eculidean distance of point with two centroids ---!
    move $t4,$v0 
    li $v0,11
    li $a0,'C'
    syscall 
    li $v0,4
    la $a0, tab
    syscall
    li $v0,1
    move $a0, $v1
    syscall
    li $v0,4
    la $a0, tab
    syscall
    li $v0,1
    move $a0, $t4
    syscall
    li $v0,4
    la $a0, newline
    syscall
    # ---- printing ends here ---
    la $s1,C
    li $a0,'C'
    jal save_ra  # $v0 contains the return address, #$ra is in original value
    beq $t0,$zero,Lbl_cluster_1  
    bne $t0,$zero,Lbl_cluster_2 # $v1 has original $ra, $ra has current address
    move $ra,$v1        # restroing original value of $ra
# -----------------------
    lw $a0,D($0)  # point A(2,2)
    lw $a1,D($s0)
    lw $a2,centroid_1($0)    # centroid E(2,4)
    lw $a3,centroid_1($s0)
    jal Eculidean_Distance  # returns distance in $v1
    move $v1,$v0            # saving result in $v0, so that we can call function again, and function will again return value in $v1
    lw $a0,D($0)  # point A(2,2)
    lw $a1,D($s0)
    lw $a2,centroid_2($0)    # centroid I(6,2)
    lw $a3,centroid_2($s0)
    jal Eculidean_Distance  # returns distance in $v1
    slt $t0,$v0,$v1  # if distance of A - E is less than A -I, jump to cluster_1 label to put A in cluster 1 
    # --- printing eculidean distance of point with two centroids ---!
    move $t4,$v0 
    li $v0,11
    li $a0,'D'
    syscall 
    li $v0,4
    la $a0, tab
    syscall
    li $v0,1
    move $a0, $v1
    syscall
    li $v0,4
    la $a0, tab
    syscall
    li $v0,1
    move $a0, $t4
    syscall
    li $v0,4
    la $a0, newline
    syscall
    # ---- printing ends here ---
    la $s1,D
    li $a0,'D'
    jal save_ra  # $v0 contains the return address, #$ra is in original value
    beq $t0,$zero,Lbl_cluster_1  
    bne $t0,$zero,Lbl_cluster_2 # $v1 has original $ra, $ra has current address
    move $ra,$v1
    # ----------------------
    lw $a0,E($0)  # point A(2,2)
    lw $a1,E($s0)
    lw $a2,centroid_1($0)    # centroid E(2,4)
    lw $a3,centroid_1($s0)
    jal Eculidean_Distance  # returns distance in $v1
    move $v1,$v0            # saving result in $v0, so that we can call function again, and function will again return value in $v1
    lw $a0,E($0)  # point A(2,2)
    lw $a1,E($s0)
    lw $a2,centroid_2($0)    # centroid I(6,2)
    lw $a3,centroid_2($s0)
    jal Eculidean_Distance  # returns distance in $v1
    slt $t0,$v0,$v1  # if distance of A - E is less than A -I, jump to cluster_1 label to put A in cluster 1 
    # --- printing eculidean distance of point with two centroids ---!
    move $t4,$v0 
    li $v0,11
    li $a0,'E'
    syscall 
    li $v0,4
    la $a0, tab
    syscall
    li $v0,1
    move $a0, $v1
    syscall
    li $v0,4
    la $a0, tab
    syscall
    li $v0,1
    move $a0, $t4
    syscall
    li $v0,4
    la $a0, newline
    syscall
    # ---- printing ends here ---
    la $s1,E
    li $a0,'E'
    jal save_ra  # $v0 contains the return address, #$ra is in original value
    beq $t0,$zero,Lbl_cluster_1  
    bne $t0,$zero,Lbl_cluster_2 # $v1 has original $ra, $ra has current address
    move $ra,$v1        # restroing original value of $ra
# -----------------------
    lw $a0,F($0)  # point A(2,2)
    lw $a1,F($s0)
    lw $a2,centroid_1($0)    # centroid E(2,4)
    lw $a3,centroid_1($s0)
    jal Eculidean_Distance  # returns distance in $v1
    move $v1,$v0            # saving result in $v0, so that we can call function again, and function will again return value in $v1
    lw $a0,F($0)  # point A(2,2)
    lw $a1,F($s0)
    lw $a2,centroid_2($0)    # centroid I(6,2)
    lw $a3,centroid_2($s0)
    jal Eculidean_Distance  # returns distance in $v1
    slt $t0,$v0,$v1  # if distance of A - E is less than A -I, jump to cluster_1 label to put A in cluster 1 
    # --- printing eculidean distance of point with two centroids ---!
    move $t4,$v0 
    li $v0,11
    li $a0,'F'
    syscall 
    li $v0,4
    la $a0, tab
    syscall
    li $v0,1
    move $a0, $v1
    syscall
    li $v0,4
    la $a0, tab
    syscall
    li $v0,1
    move $a0, $t4
    syscall
    li $v0,4
    la $a0, newline
    syscall
    # ---- printing ends here ---
    la $s1,F
    li $a0,'F'
    jal save_ra  # $v0 contains the return address, #$ra is in original value
    beq $t0,$zero,Lbl_cluster_1  
    bne $t0,$zero,Lbl_cluster_2 # $v1 has original $ra, $ra has current address
    move $ra,$v1
    # ------------------
    lw $a0,G($0)  # point A(2,2)
    lw $a1,G($s0)
    lw $a2,centroid_1($0)    # centroid E(2,4)
    lw $a3,centroid_1($s0)
    jal Eculidean_Distance  # returns distance in $v1
    move $v1,$v0            # saving result in $v0, so that we can call function again, and function will again return value in $v1
    lw $a0,G($0)  # point A(2,2)
    lw $a1,G($s0)
    lw $a2,centroid_2($0)    # centroid I(6,2)
    lw $a3,centroid_2($s0)
    jal Eculidean_Distance  # returns distance in $v1
    slt $t0,$v0,$v1  # if distance of A - E is less than A -I, jump to cluster_1 label to put A in cluster 1 
    # --- printing eculidean distance of point with two centroids ---!
    move $t4,$v0 
    li $v0,11
    li $a0,'G'
    syscall 
    li $v0,4
    la $a0, tab
    syscall
    li $v0,1
    move $a0, $v1
    syscall
    li $v0,4
    la $a0, tab
    syscall
    li $v0,1
    move $a0, $t4
    syscall
    li $v0,4
    la $a0, newline
    syscall
    # ---- printing ends here ---
    la $s1,G
    li $a0,'G'
    jal save_ra  # $v0 contains the return address, #$ra is in original value
    beq $t0,$zero,Lbl_cluster_1  
    bne $t0,$zero,Lbl_cluster_2 # $v1 has original $ra, $ra has current address
    move $ra,$v1        # restroing original value of $ra
# -----------------------
    lw $a0,H($0)  # point A(2,2)
    lw $a1,H($s0)
    lw $a2,centroid_1($0)    # centroid E(2,4)
    lw $a3,centroid_1($s0)
    jal Eculidean_Distance  # returns distance in $v1
    move $v1,$v0            # saving result in $v0, so that we can call function again, and function will again return value in $v1
    lw $a0,H($0)  # point A(2,2)
    lw $a1,H($s0)
    lw $a2,centroid_2($0)    # centroid I(6,2)
    lw $a3,centroid_2($s0)
    jal Eculidean_Distance  # returns distance in $v1
    slt $t0,$v0,$v1  # if distance of A - E is less than A -I, jump to cluster_1 label to put A in cluster 1 
    # --- printing eculidean distance of point with two centroids ---!
    move $t4,$v0 
    li $v0,11
    li $a0,'H'
    syscall 
    li $v0,4
    la $a0, tab
    syscall
    li $v0,1
    move $a0, $v1
    syscall
    li $v0,4
    la $a0, tab
    syscall
    li $v0,1
    move $a0, $t4
    syscall
    li $v0,4
    la $a0, newline
    syscall
    # ---- printing ends here ---
    la $s1,H
    li $a0,'H'
    jal save_ra  # $v0 contains the return address, #$ra is in original value
    beq $t0,$zero,Lbl_cluster_1  
    bne $t0,$zero,Lbl_cluster_2 # $v1 has original $ra, $ra has current address
    move $ra,$v1
    # ----------------------
    lw $a0,I($0)  # point A(2,2)
    lw $a1,I($s0)
    lw $a2,centroid_1($0)    # centroid E(2,4)
    lw $a3,centroid_1($s0)
    jal Eculidean_Distance  # returns distance in $v1
    move $v1,$v0            # saving result in $v0, so that we can call function again, and function will again return value in $v1
    lw $a0,I($0)  # point A(2,2)
    lw $a1,I($s0)
    lw $a2,centroid_2($0)    # centroid I(6,2)
    lw $a3,centroid_2($s0)
    jal Eculidean_Distance  # returns distance in $v1
    slt $t0,$v0,$v1  # if distance of A - E is less than A -I, jump to cluster_1 label to put A in cluster 1 
    # --- printing eculidean distance of point with two centroids ---!
    move $t4,$v0 
    li $v0,11
    li $a0,'I'
    syscall 
    li $v0,4
    la $a0, tab
    syscall
    li $v0,1
    move $a0, $v1
    syscall
    li $v0,4
    la $a0, tab
    syscall
    li $v0,1
    move $a0, $t4
    syscall
    li $v0,4
    la $a0, newline
    syscall
    # ---- printing ends here ---
    la $s1,I
    li $a0,'I'
    jal save_ra  # $v0 contains the return address, #$ra is in original value
    beq $t0,$zero,Lbl_cluster_1  
    bne $t0,$zero,Lbl_cluster_2 # $v1 has original $ra, $ra has current address
    move $ra,$v1        # restroing original value of $ra
# -----------------------
    lw $a0,J($0)  # point A(2,2)
    lw $a1,J($s0)
    lw $a2,centroid_1($0)    # centroid E(2,4)
    lw $a3,centroid_1($s0)
    jal Eculidean_Distance  # returns distance in $v1
    move $v1,$v0            # saving result in $v0, so that we can call function again, and function will again return value in $v1
    lw $a0,J($0)  # point A(2,2)
    lw $a1,J($s0)
    lw $a2,centroid_2($0)    # centroid I(6,2)
    lw $a3,centroid_2($s0)
    jal Eculidean_Distance  # returns distance in $v1
    slt $t0,$v0,$v1  # if distance of A - E is less than A -I, jump to cluster_1 label to put A in cluster 1 
    # --- printing eculidean distance of point with two centroids ---!
    move $t4,$v0 
    li $v0,11
    li $a0,'J'
    syscall 
    li $v0,4
    la $a0, tab
    syscall
    li $v0,1
    move $a0, $v1
    syscall
    li $v0,4
    la $a0, tab
    syscall
    li $v0,1
    move $a0, $t4
    syscall
    li $v0,4
    la $a0, newline
    syscall
    # ---- printing ends here ---
    la $s1,J
    li $a0,'J'
    jal save_ra  # $v0 contains the return address, #$ra is in original value
    beq $t0,$zero,Lbl_cluster_1  
    bne $t0,$zero,Lbl_cluster_2 # $v1 has original $ra, $ra has current address
    move $ra,$s7    # restoring the original value of $ra to get back to main
    
    jr $ra
# ------------------ End of make_clusters -------------------#

    Lbl_cluster_1:
        sw $s1,($s3)
        sb $a0,($s5)
        addi $s3,$s3,4 # move cluster_1 array to next index
        addi $s5,$s5,1 # move cluster_1_dataPoint_names array to next index
        move $v1,$ra # saving original $ra
        move $ra,$v0
        addi $ra,$ra,4

        jr $ra
        

    Lbl_cluster_2:
        sw $s1,($s4)
        sb $a0,($s6)
        addi $s4,$s4,4 # move cluster_1 array to next index
        addi $s6,$s6,1
        move $v1,$ra # saving original $ra
        move $ra,$v0
        addi $ra,$ra,8

        jr $ra

    save_ra:
        move $v0,$ra

        jr $ra    
        

Eculidean_Distance:
	
	# performing the calculation: (x2 - x1)^2
	sub $t4,$a2,$a0 #t2 has 5
	mul $t5,$t4,$t4 # = 25
	#performing the calculation: (y2 - y1)^2
	sub $t4,$a1,$a3 # = 6
	mul $t6,$t4,$t4 # = 36
	#performing the calculation: (x2 - x1)^2 + (y2 - y1)^2
	add $t0,$t5,$t6 	# =61
    move $v0,$t0
    
	jr $ra 
	
    

	
