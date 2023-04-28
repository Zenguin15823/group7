computer_input:

	
	addi $a1, $zero, 9
	addi $v0, $zero, 42
	syscall				# Generates random # from 0 - 8
	
	
    	sll $t0, $a0, 2              	# Correcting offset of array
    	la $t1, grid                 	# Loads grid address to $t1
    	add $t1, $t1, $t0            	# Adding offset ($t0) to the grid address ($t1)
    	
    	lw $t2, 0($t1)               	# Loads the element of the random number in the array
    	li $t3, 32                   	# Loads " " in $t3
    	bne $t2, $t3, computer_input 	# Compares the chosen element to the space, if a space, continue, if not, generate a new number

	li $t4, 79                  	# Loads "O" in $t4 
	sw $t4, 0($t1)              	# Stores "O" in chosen element