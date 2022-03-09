.globl factorial

.data
n: .word 8

.text
main:
    la t0, n
    lw a0, 0(t0)
    jal ra, factorial

    addi a1, a0, 0
    addi a0, x0, 1
    ecall # Print Result

    addi a1, x0, '\n'
    addi a0, x0, 11
    ecall # Print newline

    addi a0, x0, 10
    ecall # Exit

factorial:
    add s0, a0, x0		#s0 = n
    add s1, s0, x0  	#s1 = sum = n
    addi s2, x0, 1		#s2 = 1
loop:
	bge s2, s0, exit    # while(n > 1)
    addi s0, s0, -1		# n = n - 1
    mul s1, s1, s0		# sum = sum * n   
    j loop
exit:    
	add a0, x0, s1		#set the a0 as return value
    ret					# return
	