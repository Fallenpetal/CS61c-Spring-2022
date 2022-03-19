.globl dot

.text
# =======================================================
# FUNCTION: Dot product of 2 int arrays
# Arguments:
#   a0 (int*) is the pointer to the start of arr0
#   a1 (int*) is the pointer to the start of arr1
#   a2 (int)  is the number of elements to use
#   a3 (int)  is the stride of arr0
#   a4 (int)  is the stride of arr1
# Returns:
#   a0 (int)  is the dot product of arr0 and arr1
# Exceptions:
#   - If the length of the array is less than 1,
#     this function terminates the program with error code 36
#   - If the stride of either array is less than 1,
#     this function terminates the program with error code 37
# =======================================================
# C Language Version
#int dot(int* a0, int *a1, int a2, int a3, int a4) {
#	if(a2 < 1) {
#		return 36;
#	}
#	if(a3 < 1 || a4 < 1) {
#		return 37;
#	}
#	int sum = 0;
#	int i = 0;
#	int j = 0;
#	int k = 0;
#	for (i = 0; i < a2; i++) {
#		sum += a0[j] * a1[k];
#		j = j + a3;
#		k = k + a4;
#	}
#	return sum;
#}
#=======================================================
dot:
	# Prologue
    addi sp, sp, -4
    sw s0, 0(sp)
    
	li t0, 1
    blt a2, t0, error1
    blt a3, t0, error2
    blt a4, t0, error2
	mv s0, x0				# sum = s0 = 0
    mv t0, x0				# i = t0 = 0
    mv t1, x0				#j = t1
    mv t2, x0				# k = t2
loop:
	beq t0, a2, done
	slli t1, t1, 2
    slli t2, t2, 2
    add t3, t1, a0
    add t4, t2, a1
    lw t3, 0(t3)			# t3 = a0[j]
    lw t4, 0(t4)			# t4 = a1[k]
    srli t1, t1, 2
    srli t2, t2, 2
    mul t5, t3, t4			#t5 = a0[j]*a1[k]
    add s0, s0, t5			# sum+= t5
    add t1, t1, a3			# j = j + step
    add t2, t2, a4			# k = k + step
    addi t0, t0, 1			# i ++
    j loop

error1:
	li a0, 36
    j exit
error2:
	li a0, 37
    j exit
    
done:
	mv a0, s0

	# Epilogue
    lw s0, 0(sp)
    addi sp, sp, 4  
	ret
