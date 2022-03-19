.globl matmul

.text
# =======================================================
# FUNCTION: Matrix Multiplication of 2 integer matrices
#   d = matmul(m0, m1)
# Arguments:
#   a0 (int*)  is the pointer to the start of m0
#   a1 (int)   is the # of rows (height) of m0
#   a2 (int)   is the # of columns (width) of m0
#   a3 (int*)  is the pointer to the start of m1
#   a4 (int)   is the # of rows (height) of m1
#   a5 (int)   is the # of columns (width) of m1
#   a6 (int*)  is the pointer to the the start of d
# Returns:
#   None (void), sets d = matmul(m0, m1)
# Exceptions:
#   Make sure to check in top to bottom order!
#   - If the dimensions of m0 do not make sense,
#     this function terminates the program with exit code 38
#   - If the dimensions of m1 do not make sense,
#     this function terminates the program with exit code 38
#   - If the dimensions of m0 and m1 don't match,
#     this function terminates the program with exit code 38
# =======================================================
#C Language Version
#int matmul(int *a0, int a1, int a2, int *a3, int a4, int a5, int *a6) {
#	if (a1 < 1 || a2 < 1 || a4 < 1 || a5 < 1) {
#		return 38;
#	}
#	if (a2 != a4) {
#		return 38;
#	}
#	int t = 0;
#	int *q = a3;
#	for (int i = 0; i < a1; i++) {
#		for (int j = 0; j < a5; j++) {
#			a6[t] = dot(a0, q, a2, 1, a5);
#			t++;
#			q++;
#		}
#		a0 = a0 + a2;
#		q = a3;
#	}
#	return ;
#}
#====================================================
matmul:
	# Error checks
	li t0, 1
    blt a1, t0, error
    blt a2, t0, error
    blt a4, t0, error
    blt a5, t0, error
    bne a2, a4, error

	li t1, 0			# t = 0
	add t2, x0, a3		# *q = a3
    li t3, 0			# i = 0
outer_loop_start:

	li t4, 0			# j = 0
	beq t3, a1, outer_loop_end

inner_loop_start:

	beq t4, a5, inner_loop_end    
    # Prologue
    addi sp, sp, -52
    sw a0, 0(sp)
    sw a1, 4(sp)
    sw a2, 8(sp)
    sw a3, 12(sp)
    sw a4, 16(sp)
    sw a5, 20(sp)
    sw a6, 24(sp)
    sw t0, 28(sp)
    sw t1, 32(sp)
    sw t2, 36(sp)
    sw t3, 40(sp)
    sw t4, 44(sp)
    sw ra, 48(sp)
      
    mv a1, t2
    li a3, 1
    mv a4, a5

    jal ra, dot
	lw t1, 32(sp)		# restore t
    lw t2, 36(sp)		# restore *q
    lw a6, 24(sp)
    slli t1, t1, 2
    add t5, t1, a6
    sw a0, 0(t5)		# a6[t] = dot(......)
    srli t1, t1, 2
    
    # Epilogue
    lw a0, 0(sp)
    lw a1, 4(sp)
    lw a2, 8(sp)
    lw a3, 12(sp)
    lw a4, 16(sp)
    lw a5, 20(sp)
    lw t0, 28(sp)
    lw t3, 40(sp)
    lw t4, 44(sp)
    lw ra, 48(sp)
    addi sp, sp, 52
    
    addi t1, t1, 1		# t++
    addi t2, t2, 4		# q++
    addi t4, t4, 1		# j++
    j inner_loop_start
    

inner_loop_end:
	slli a2 a2, 2
	add a0, a0, a2
    srli a2, a2, 2
    mv t2, a3
    addi t3, t3, 1
	j outer_loop_start

outer_loop_end:
	ret
error:
	li a0, 38
    j exit


