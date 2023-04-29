.data
grid: .word 32, 32, 32, 32, 32, 32, 32, 32, 32 # grid is an array of 9 words, each word representing a cell
# if value in a cell is 32, cell is empty. if value is 88, it is an X (player). if value is 79, it is an O (computer)

matrix: .word 48, 49, 50, 51, 52, 53, 54, 55, 56
bigLine: .asciiz "-+-+-\n"
welcome: .asciiz "\nWelcome to Tic Tac Toe! Here are the rules: \nYou will make a move, and then the computer will make one, then repeat until someone gets 3 of their letter in a row!\n"
howto: .asciiz "\nAbove, the numbers corresponding to each cell are shown."
howtwo: .asciiz "\nPlease input a number to draw an X in that square.\n"
playagain: .asciiz "\nEnter 0 to quit, or any other number to play again.\n"
invalid_input_msg: .asciiz "\nInvalid input. Please choose an empty cell by entering the corresponding number.\n"
tieGameStr: .asciiz "\nThe game was a tie!\n"
playerWinStr: .asciiz "\nCongratulations, you won!.\n"
computerWinStr: .asciiz "\nThe computer won!\n"
playAgainStr: .asciiz "\nPlay again?\n"

.text
j main

# Draw grid ( Courtney )
drawBoard:
	# draws an example grid if s0 is 0, otherwise draws the current grid

	# new line
	li $a0, 10
   	li $v0, 11
   	syscall

	la $t1, grid
	bnez $s0, notExample
	la $t1, matrix
	notExample:
	#row counter
	li $t0, 0 
loopRows:
	#column counter
	li $t5, 0 
	
loopCols:
    	
	#load elemnet matrix
    	lw $a0, 0($t1)
    	addi $t1, $t1, 4
	
    	#print
    	li $v0, 11
    	syscall
    	
    	bgt $t5, 1, noVert
    	# print vertical line
    	li $a0, 124
    	li $v0, 11
	syscall
	noVert:
	
    	#increment col
    	addi $t5, $t5, 1
    	blt $t5, 3, loopCols
    	
  	#line between rows
  	li $a0, 10
   	li $v0, 11
   	syscall
   	
   	bgt $t0, 1, noHoriz
 	la $a0, bigLine
	li $v0, 4
	syscall
	noHoriz:
    	
    	#inc row pointer
	addi $t0, $t0, 1
	blt $t0, 3, loopRows
	
	jr $ra # end of drawBoard function

# Check for winner or tie, if no go back to gameLoop, if so go ahead ( Austin )
# Output win/tie message ( Maulik )
checkWin:
	li $s0, 264 # 88 x 3 = 264. If three cells sum to this number, there are 3 X's
	li $s1, 237 # 79 x 3 = 237. If three cells sum to this number, there are 3 O's

	la $t1, grid
	li $t5, 2 # iterator so we only loop 3 times
	checkRow:
	lw $t2, 0($t1)
	lw $t3, 4($t1)
	lw $t4, 8($t1) 
	add $t0, $t2, $t3 
	add $t0, $t0, $t4 # add up each cell in the row,
	beq $t0, $s0, playerWin # then check if there are 3 X's
	beq $t0, $s1, computerWin # or 3 O's
	beqz $t5, checkRowOut # if all 3 rows have been checked, exit
	subi $t5, $t5, 1
	addi $t1, $t1, 12 # otherwise, iterate to next row and go again
	j checkRow
	checkRowOut:
	
	la $t1, grid
	li $t5, 2 # iterator so we only loop 3 times
	checkCol:
	lw $t2, 0($t1)
	lw $t3, 12($t1)
	lw $t4, 24($t1)
	add $t0, $t2, $t3
	add $t0, $t0, $t4 # add up each cell in the column,
	beq $t0, $s0, playerWin # then check if there are 3 X's
	beq $t0, $s1, computerWin # or 3 O's
	beqz $t5, checkColOut # if all 3 columns have been checked, exit
	subi $t5, $t5, 1
	addi $t1, $t1, 4 # otherwise, iterate to next column and go again
	j checkCol
	checkColOut:
	
	la $t1, grid
	# Now let's check the top left to bottom right diagonal
	lw $t2, 0($t1)
	lw $t3, 16($t1)
	lw $t4, 32($t1)
	add $t0, $t2, $t3
	add $t0, $t0, $t4 # add up each cell in the diagonal,
	beq $t0, $s0, playerWin # then check if there are 3 X's
	beq $t0, $s1, computerWin # or 3 O's

	# And the the top right to bottom left diagonal
	lw $t2, 8($t1)
	lw $t3, 16($t1)
	lw $t4, 24($t1)
	add $t0, $t2, $t3
	add $t0, $t0, $t4 # add up each cell in the diagonal,
	beq $t0, $s0, playerWin # then check if there are 3 X's
	beq $t0, $s1, computerWin # or 3 O's
	
	# Finally, let's check for a tie by whether or not any blank spaces remain
	li $t5, 9 # iterator
	li $s2, 32 # ascii value of space, if we find one then there are still possible moves and thus not a tie
	checkTie:
	lw $t0, 0($t1)
	beq $t0, $s2, noTie # not a tie if there is a blank cell, exit loop
	subi $t5, $t5, 1 # iterate
	addi $t1, $t1, 4 # iterate to next cell
	bnez $t5, checkTie # if there are still cells to check, loop
	j tieGame # if no cells remain and none were blank, it is a tie.

	noTie:
	
	jr $ra
	
playerWin:
la $a0, playerWinStr
li $v0, 4
syscall
j endScr

computerWin:
la $a0, computerWinStr
li $v0, 4
syscall
j endScr

tieGame:
la $a0, tieGameStr
li $v0, 4
syscall
j endScr

main: # this is where the fun begins

# game introduction and start point ( Zac )

# Clear the grid in case 'play again' was chosen
li $t0, 32
la $t1, grid
li $t2, 9
clearLoop:
sw $t0, 0($t1)
addi $t1, $t1, 4
subi $t2, $t2, 1
bnez $t2, clearLoop

# Outputting starting messages
la $a0, welcome
li $v0, 4
syscall
li $s0, 0
jal drawBoard
la $a0, howto
li $v0, 4
syscall

gameLoop:

la $a0, howtwo
li $v0, 4
syscall

# User input ( Manav )
user_input:
    li $v0, 5                   # syscall for reading an integer
    syscall
    sll $t0, $v0, 2             # multiply the index by 4 to get the correct offset in the array
    la $t1, grid                # load the address of the grid array
    add $t1, $t1, $t0           # add the offset to the grid address
    lw $t2, 0($t1)              # load the value at the chosen position
    li $t3, 32                  # load the value 32 (ASCII space)
    bne $t2, $t3, invalid_input # if the chosen position is not empty, input is invalid

    li $t4, 88                  # load the value 88 (ASCII 'X')
    sw $t4, 0($t1)              # store the value 'X' in the chosen position
    j end_user_input            # jump to the end of the user input section

invalid_input:
    # Output an error message and repeat the user input process
    la $a0, invalid_input_msg
    li $v0, 4
    syscall
    j user_input

end_user_input:

li $s0, 1 # These two lines will call the drawBoard function so the player can see the X's and O's
jal drawBoard 
jal checkWin # This line checks for a win/tie, and if one is found it ends the game accordingly.

# Computer input ( Morgod )
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

li $s0, 1 # These two lines will call the drawBoard function so the player can see the X's and O's
jal drawBoard 


jal checkWin # This line checks for a win/tie, and if one is found it ends the game accordingly.
j gameLoop # If no win or tie was found, the game continues
# Give option to play again/quit ( Zac )
endScr:

la $a0, playagain
li $v0, 4
syscall
li $v0, 5
syscall
bnez $v0, main

exit:
li $v0, 10
syscall
