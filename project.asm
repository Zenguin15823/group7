.data
grid: .word 32, 32, 32, 32, 32, 32, 32, 32, 32 # grid is an array of 9 words, each word representing a cell
# see image in gitHub for diagram of cell arrangement
# IMPORTANT: if value in a cell is 32, cell is empty. if value is 88, it is an X (player). if value is 79, it is an O (computer)
# following the above stipulations will allow everyone's code to work together once combined

matrix: .word 48, 49, 50, 51, 52, 53, 54, 55, 56
bigLine: .asciiz "-+-+-\n"
welcome: .asciiz "\nWelcome to Tic Tac Toe!\n"
howto: .asciiz "\nAbove, the numbers corresponding to each cell are shown. Please input a number to draw an X in that square.\n"
playagain: .asciiz "\nEnter 0 to quit, or any other number to play again.\n"

.text
j main

# Draw board ( Courtney )
drawBoard:
	# draws an example board if s0 is 0, otherwise draws the current board

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

main:

# game introduction and start point ( Zac )

# Clear the board in case 'play again' was chosen
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


# User input ( Berlin )

li $s0, 1 # These two lines will call the drawBoard function so the player can see the X's and O's
jal drawBoard 

# Computer input ( Morgod )

li $s0, 1 # These two lines will call the drawBoard function so the player can see the X's and O's
jal drawBoard 

# Check for winner or tie, if no go back to gameLoop, if so go ahead ( Austin )

# Output win/tie message ( Austin )

# Give option to play again/quit ( Zac )

la $a0, playagain
li $v0, 4
syscall
li $v0, 5
syscall
bnez $v0, main

# When you are done with your part, commit it to the gitHub as its own branch and I will put it into the master branch. 
# If something is wrong with it I will try to debug but might need your help ( Zac )
# If you have any questions or anything just msg the discord chat
li $v0, 10
syscall
