.globl argmax

.text
# =================================================================
# FUNCTION: Given a int array, return the index of the largest
#   element. If there are multiple, return the one
#   with the smallest index.
# Arguments:
#   a0 (int*) is the pointer to the start of the array
#   a1 (int)  is the # of elements in the array
# Returns:
#   a0 (int)  is the first index of the largest element
# Exceptions:
#   - If the length of the array is less than 1,
#     this function terminates the program with error code 36
# =================================================================
#C Language Version
#int Argmax(int *a, int len) {
#	if(len < 1) {
#		return 36;
#	}
#	int maxIndex = 0;
#	for (int i = 0; i < len; i++) {
#		if (a[maxIndex] < a[i]) {
#			maxIndex = i;
#		}
#	}
#	return maxIndex;
#} 
argmax:
	# Prologue
	li t0, 1
    blt a1, t0, error
    li t1, 0		# set counter
    li t2, 0		#initialized maxIndex = t2 = 0
loop:    
    beq t1, a1, done
    slli t3, t1, 2			#t3 = 4*i
    slli t4, t2, 2			#t4 = 4*maxIndex
    add t5,t3,a0			#t5 = &a[i]
    lw t5,0(t5)				#t5 = a[i]
    add t6, t4, a0			#t6 = &a[maxIndex]
    lw t6, 0(t6)			#t6 = a[maxIndex]
    bge t6, t5 , donothing		#if a[maxIndex] >= a[i],do nothing
    add t2, x0, t1				#else maxIndex = i
donothing:    
    addi t1, t1, 1
    j loop

# Epilogue
done:    
    add a0, x0, t2
    ret

error:
	li a0 36
    j exit
