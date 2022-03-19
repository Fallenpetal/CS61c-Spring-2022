.globl classify

.text
# =====================================
# COMMAND LINE ARGUMENTS
# =====================================
# Args:
#   a0 (int)        argc
#   a1 (char**)     argv
#   a1[1] (char*)   pointer to the filepath string of m0
#   a1[2] (char*)   pointer to the filepath string of m1
#   a1[3] (char*)   pointer to the filepath string of input matrix
#   a1[4] (char*)   pointer to the filepath string of output file
#   a2 (int)        silent mode, if this is 1, you should not print
#                   anything. Otherwise, you should print the
#                   classification and a newline.
# Returns:
#   a0 (int)        Classification
# Exceptions:
#   - If there are an incorrect number of command line args,
#     this function terminates the program with exit code 31
#   - If malloc fails, this function terminates the program with exit code 26
#
# Usage:
#   main.s <M0_PATH> <M1_PATH> <INPUT_PATH> <OUTPUT_PATH>
classify:
ebreak
	#Prologue
    addi sp, sp, -72
    sw a0, 8(sp)
    sw a1, 12(sp)
    sw a2, 16(sp)
    sw s0, 20(sp)
    sw s1, 24(sp)
    sw s2, 28(sp)
    sw s3, 32(sp)
    sw s4, 36(sp)
    sw s5, 40(sp)
    sw s6, 44(sp)
    sw s7, 48(sp)
    sw s8, 52(sp)
    sw s9, 56(sp)
    sw s10, 60(sp)
    sw s11, 64(sp)
    sw ra, 68(sp)
    

	li s0, 5
    bne a0, s0, args_error				#args' number != 5
    
    #read m0 matrix
    li a0, 4
    jal malloc
    beqz a0, malloc_error
    mv s1, a0							# s1 is pointer to m0's row
    li a0, 4
    jal malloc
    beqz a0, malloc_error
    mv s2, a0							# s2 is pointer to m0's column
    lw a1, 12(sp)
    lw a0, 4(a1)						# a0 is args[1] m0
	mv a1, s1
    mv a2, s2
    jal read_matrix
    mv s3, a0							# s3 is m0 matrix
    
    #read m1 matrix
    li a0, 4
    jal malloc
    beqz a0, malloc_error
    mv s4, a0							#s4 is pointer to m1's row
    li a0, 4
    jal malloc
    beqz a0, malloc_error	
    mv s5, a0							#s5 is pointer to m1's column
    lw a1, 12(sp)
    lw a0, 8(a1)						# a0 is args[2] m1
	mv a1, s4
    mv a2, s5
    jal read_matrix
    mv s6, a0							# s6 is m1 matrix
    
    #read input matrix
    li a0, 4
    jal malloc
    beqz a0, malloc_error
    mv s7, a0							#s7 is pointer to input's row
    li a0, 4
    jal malloc
    beqz a0, malloc_error	
    mv s8, a0							#s8 is pointer to input's column
    lw a1, 12(sp)
    lw a0, 12(a1)						# a0 is args[3] input
	mv a1, s7
    mv a2, s8
    jal read_matrix
    mv s9, a0							# s9 is input matrix    


    #allocate space for h matrix
    lw t1, 0(s1)
    lw t2, 0(s8)
    mul t0, t1, t2						#if m0 (m x p) , m1 (q x m), input (p x n),then h = m0 x input --> m x n
    sw t0, 0(sp)						# t0 is h's size
    slli t0, t0, 2						# 4byte per element
    mv a0, t0
    jal malloc
    beqz a0, malloc_error
    mv s10, a0							# s10 is pointer to h


    #prepare to compute h = matmul(m0, input)
    mv a0, s3
    lw a1, 0(s1)
    lw a2, 0(s2)						#load m0's row and column from memory
    mv a3, s9
    lw a4, 0(s7)
    lw a5, 0(s8)						#load input's row and column from memory
    mv a6, s10
    jal matmul
 
    #call relu()
    mv a0, s10
    lw a1, 0(sp)						#0(sp) is t0 which is h's size
    jal relu
    
    #allocate space for o
    lw t1, 0(s4)						# m1's row
    lw t2, 0(s8)						# input's column, if m0 (m x p) , m1 (q x m), input (p x n),h(m x n),then ,o = m1 x h -->q x n
    mul t3, t1, t2
    sw t3, 4(sp)						# store o's size
    slli t3, t3, 2
    mv a0, t3
    jal malloc
    beqz a0, malloc_error
    mv s11, a0							# s11 is pointer to o
    
    #compute matmul(m1, h)
    mv a0, s6
    lw a1, 0(s4)						# q x m
    lw a2, 0(s5)
    mv a3, s10
    lw a4, 0(s1)						# m x n
    lw a5, 0(s8)
    mv a6, s11
    jal matmul							# q x n
 
    #write o to file
    lw a1, 12(sp)
    lw a0, 16(a1)						# output file pointer
    mv a1, s11
    lw a2, 0(s4)
    lw a3, 0(s8)
    jal write_matrix

    #call argmax(o)
    mv a0, s11
    lw a1, 4(sp)						# 4(sp) is o's size
    jal argmax
ebreak
    mv s0, a0							# store return value in s0
    lw a2, 16(sp)						#the argument decide whether to print '\n' or not
    beqz, a2, print
    j done

print:    
    mv a0, s0
    jal print_int
    li t0, '\n'
    mv a0, t0
    jal print_char
    
done:
	#free every malloc
    mv a0, s1			# m0's row
    jal free			
    mv a0, s2			# m0's column
    jal free
    mv a0, s3			# m0 matrix
    jal free
    mv a0, s4			# m1's row
    jal free
    mv a0, s5			# m1's column
    jal free
    mv a0, s6			# m1 matrix
    jal free
    mv a0, s7			# input's row
    jal free
    mv a0, s8			# input's column
    jal free
    mv a0, s9			# input matrix
    jal free
    mv a0, s10			# h matrix
    jal free
    mv a0, s11			# o matrix
    jal free
ebreak    
    #Epilogue
    lw a0, 8(sp)
    lw a1, 12(sp)
    lw a2, 16(sp)
    lw s0, 20(sp)
    lw s1, 24(sp)
    lw s2, 28(sp)
    lw s3, 32(sp)
    lw s4, 36(sp)
    lw s5, 40(sp)
    lw s6, 44(sp)
    lw s7, 48(sp)
    lw s8, 52(sp)
    lw s9, 56(sp)
    lw s10, 60(sp)
    lw s11, 64(sp)
    lw ra, 68(sp)
    addi sp, sp, 72
    mv a0, s0
	ret

args_error:
	li a0, 31
    j exit
    
malloc_error:
	li a0, 26
    j exit