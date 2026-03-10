
.section .data
	MULTIPLIER: .word 1664525
	INCREMENT: .word 1013904223
	seed: .word 1

.section .text
.global get_random_num

get_random_num:
	push {r1, r2, r3, r4, r5}	
	
	ldr r1, =seed
	ldr r0, [r1]
	ldr r2, =MULTIPLIER
    ldr r2, [r2]
	ldr r3, =INCREMENT
    ldr r3, [r3]

	mul r0, r2, r0
	add r0, r3, r0

	str r0, [r1]

	pop	{r1, r2, r3, r4, r5}	
	bx lr

