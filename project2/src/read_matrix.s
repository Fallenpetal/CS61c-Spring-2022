.globl read_matrix

.text
# ==============================================================================
# FUNCTION: Allocates memory and reads in a binary file as a matrix of integers
#
# FILE FORMAT:
#   The first 8 bytes are two 4 byte ints representing the # of rows and columns
#   in the matrix. Every 4 bytes afterwards is an element of the matrix in
#   row-major order.
# Arguments:
#   a0 (char*) is the pointer to string representing the filename
#   a1 (int*)  is a pointer to an integer, we will set it to the number of rows
#   a2 (int*)  is a pointer to an integer, we will set it to the number of columns
# Returns:
#   a0 (int*)  is the pointer to the matrix in memory
# Exceptions:
#   - If malloc returns an error,
#     this function terminates the program with error code 26
#   - If you receive an fopen error or eof,
#     this function terminates the program with error code 27
#   - If you receive an fclose error or eof,
#     this function terminates the program with error code 28
#   - If you receive an fread error or eof,
#     this function terminates the program with error code 29
# ==============================================================================
read_matrix:
	# Prologue
	addi sp, sp, -32
    sw ra, 4(sp)
    sw s0, 8(sp)
    sw s1, 12(sp)
    sw s2, 16(sp)
    sw s3, 20(sp)
    sw s4, 24(sp)	
    sw s5, 28(sp)
    mv s1, a1			# s1 = pointer to row backup
    mv s2, a2			# s2 = pointer to column backup
    li a1, 0			# 0 represent read-only
    jal fopen

    li t0, -1
    beq a0, t0, fopen_error
    sw a0, 0(sp)		# store the file descriptor
    mv a1, s1			# a1 = pointer to row
    li s3, 4
    mv a2, s3			# maybe a2 will be overwrite after call fread
    jal fread

    bne a0, s3, fread_error
	mv a1, s2			# a1 = pointer to column
    mv a2, s3
    lw a0, 0(sp)		#Hint : due to a0 will be overwrite after each call , we should restore it in time , a0 is file descriptor 
    jal fread
    bne a0, s3, fread_error   
    
	lw t3, 0(s1)
    lw t4, 0(s2)
    mul s4, t3, t4		# t3 = row , t4 = column
    slli s4, s4, 2		# byte = 4 * row * column
    mv a0, s4
    jal malloc
 
    beqz a0, malloc_error
    mv s5, a0			# s5 is pointer to matrix'address in memory , which allocated by malloc
    lw a0, 0(sp)		# file descriptor
    mv a1, s5			# buffer address
    mv a2, s4			# byte number
    jal fread
    bne a0, s4, fread_error
    
    lw a0, 0(sp)
    jal fclose
    beqz a0, done
    
fclose_error:
	li a0, 28
    j exit    
    
done:
        
	# Epilogue
    mv a0, s5
	lw ra, 4(sp)
    lw s0, 8(sp)
    lw s1, 12(sp)
    lw s2, 16(sp)
    lw s3, 20(sp)
    lw s4, 24(sp)
    lw s5, 28(sp)
    addi sp, sp, 32
	ret


fopen_error:
	li a0, 27
    j exit
    
fread_error:
	li a0, 29
    j exit
    
malloc_error:
	li a0, 26
    j exit
    
