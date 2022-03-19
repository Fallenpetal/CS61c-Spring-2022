.globl write_matrix

.text
# ==============================================================================
# FUNCTION: Writes a matrix of integers into a binary file
# FILE FORMAT:
#   The first 8 bytes of the file will be two 4 byte ints representing the
#   numbers of rows and columns respectively. Every 4 bytes thereafter is an
#   element of the matrix in row-major order.
# Arguments:
#   a0 (char*) is the pointer to string representing the filename
#   a1 (int*)  is the pointer to the start of the matrix in memory
#   a2 (int)   is the number of rows in the matrix
#   a3 (int)   is the number of columns in the matrix
# Returns:
#   None
# Exceptions:
#   - If you receive an fopen error or eof,
#     this function terminates the program with error code 27
#   - If you receive an fclose error or eof,
#     this function terminates the program with error code 28
#   - If you receive an fwrite error or eof,
#     this function terminates the program with error code 30
# ==============================================================================
write_matrix:

	# Prologue
	addi sp, sp, -36
    sw s0, 4(sp)
    sw s1, 8(sp)
    sw s2, 12(sp)
    sw s3, 16(sp)
    sw s4, 20(sp)
    sw s5, 24(sp)
    sw s6, 28(sp)
    sw ra, 32(sp)
    
    mv s0, a1				#backup a1,pointer to array
    mv s1, a2
    mv s2, a3				#backup a2, a3, a2 = row, a3 = column
    li a1, 1				#read-only
    li s4, -1
    jal fopen
    beq a0, s4, fopen_error
    sw a0, 0(sp)			# store file discriptor
    li a0, 8
    jal malloc
    mv s6, a0				#store allocated space to s6
    sw s1, 0(s6)
    sw s2, 4(s6)			#store row and column to buffer before write
    lw a0, 0(sp)
    mv a1, s6
    li a2, 2				# write row to file
    mv s5, a2				# backup a2 before call fwrite
    li a3, 4
    jal fwrite
    bne a0, s5, fwrite_error
    lw a0, 0(sp)
    mv a1, s0
    mul a2, s1, s2
    mv s5, a2
    li a3, 4
    jal fwrite
    bne a0, s5, fwrite_error
    lw a0, 0(sp)
    jal fclose
    beqz a0, done
    
fclose_error:
	li a0, 28
    j exit
    

done:

	# Epilogue
    lw s0, 4(sp)
    lw s1, 8(sp)
    lw s2, 12(sp)
    lw s3, 16(sp)
    lw s4, 20(sp)
    lw s5, 24(sp)
    lw s6, 28(sp)
    lw ra, 32(sp)	
    addi sp, sp, 36
	ret


fopen_error:
	li a0, 27
    j exit


fwrite_error:
	li a0, 30
    j exit

