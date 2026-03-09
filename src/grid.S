.section .data
	grid_array: .space 256
	player_pos: .word 0
	goal_pos: .word 0

.section .text
.global get_player_pos
.global reset
.global step

get_player_pos:
	ldr r0, =player_pos
	ldr r0, [r0]
	bx lr

reset:
	push {r0, r1}
	
	ldr r1, =player_pos
	mov r0, #54   @ player pos is bottom right minus one space each, so (7, 7) 
	str r0, [r1]

	ldr r1, =goal_pos
	mov r0, #9   @ player pos is bottom right minus one space each, so (1, 1) 
	str r0, [r1]

	pop {r0, r1}
	bx lr

@ arg: r0 - action. 0: up,  1: right, 2: down, 3: left
@ return: r0, reward
step:
	@ r0 represents the action, r1 the address of current pos, r2 the value of the current pos, r3 the possibly new pos, r4 the goal pos, r5 the reward
	push {r1, r2, r3, r4, r5, r6, r7}
	mov r5, #0
	ldr r1, =player_pos
	ldr r2, [r1]	

	cmp r0, #0
	beq move_up
	
	cmp r0, #1
	beq move_right

	cmp r0, #2
	beq move_down

	cmp r0, #3
	beq move_left

after_change:
	str r3, [r1]
	ldr r1, =goal_pos
	ldr r4, [r1]
	cmp r3, r4
	bne after_nochange
	mov r5, #1

after_nochange:
	mov r0, r5
	pop {r1, r2, r3, r4, r5, r6, r7}
	bx lr

move_up:
	subs r3, r2, #8
	bpl after_change
	b after_nochange

move_right:
	add r3, r2, #1
	lsr r6, r2, #3
	lsr r7, r3, #3
	cmp r6, r7
	beq after_change
	b after_nochange

move_down:
	add r3, r2, #8
	cmp r3, #64
	blt after_change
	b after_nochange

move_left:
	sub r3, r2, #1
	lsr r6, r2, #3
	lsr r7, r3, #3
	cmp r6, r7
	beq after_change
	b after_nochange
	
