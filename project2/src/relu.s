.globl relu

.text
# ==============================================================================
# FUNCTION: Performs an inplace element-wise ReLU on an array of ints
# Arguments:
#   a0 (int*) is the pointer to the array
#   a1 (int)  is the # of elements in the array
# Returns:
#   None
# Exceptions:
#   - If the length of the array is less than 1,
#     this function terminates the program with error code 36
# ==============================================================================
relu:
	# Prologue
    addi sp, sp, -4
    sw s0, 0(sp)
    
    li t0, 1
    blt a1, t0, error
   	li t1,0				# set counter t1
loop:
	beq t1, a1, done	# t1 < a1
    slli t1, t1, 2		# t1 = 4*t1
    add s0, a0, t1		# s0 = &a[i]
    lw t2, 0(s0)		# t2 = a[i]
    srli t1, t1, 2		# restore t1
    bge t2, x0, donothing	# if a[i] >=0, do nothing
    sw x0, 0(s0)			# else a[i] = 0
    
donothing:
	addi t1, t1, 1		#counter++
    j loop


error:
	li a0, 36
    j exit
done:    
	# Epilogue
    lw s0, 0(sp)
    addi sp, sp, 4
	ret
