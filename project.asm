.data
grid: .word 0, 0, 0, 0, 0, 0, 0, 0, 0 # grid is an array of 9 words, each word representing a cell
# see image in gitHub for diagram of cell arrangement
# IMPORTANT: if value in a cell is 0, cell is empty. if value is 1, it is an X (player). if value is 2, it is an O (computer)
# following the above stipulations will allow everyone's code to work together once combined

.text

main:

# game introduction and start point ( Zac )

gameLoop:

# Draw board ( Courtney )

# User input ( Berlin )

# Computer input ( Morgod )

# Check for winner or tie, if no go back to gameLoop, if so go ahead ( Austin )

# Game is over. Draw board [maybe use function call] ( Courtney )

# Output win/tie message ( Austin )

# Give option to play again/quit ( Zac )

# When you are done with your part, commit it to the gitHub as its own branch and I will put it into the master branch. 
# If something is wrong with it I will try to debug but might need your help ( Zac )
# If you have any questions or anything just msg the discord chat
li $v0, 10
syscall