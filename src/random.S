.section .data
	MULTIPLIER: .word 1664525
	INCREMENT: .word 1013904223
	seed: .word 1

.section .text
.global get_random_num

get_random_num:
	push {r1, r2, r3, lr}	
	
	ldr r1, =seed
	ldr r0, [r1]
	ldr r2, =MULTIPLIER
    ldr r2, [r2]
	ldr r3, =INCREMENT
    ldr r3, [r3]

	mul r0, r2, r0
	add r0, r3, r0

	str r0, [r1]

	@ here if we only get the 2 least significant bits it quickly becomes repetitive
	@ so we sum the bits
	bl sum_bits

	pop	{r1, r2, r3, lr}	
	bx lr

@ arg: number, return: sumed bits
sum_bits:
	push {r1, r3, r4, lr}

	mov r1, r0      @ original number
	mov r0, #0      @ result
	mov r3, #31     

sum_bits_loop:

	mov r4, #1
	lsl r4, r4, r3
	and r4, r1, r4
	lsr r4, r4, r3
	add r0, r4, r0

	subs r3, r3, #1 
	bpl sum_bits_loop

	pop {r1, r3, r4, lr}
	bx lr
