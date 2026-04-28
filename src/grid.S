.section .data
	grid_array: .space 256
	player_pos: .word 0
	goal_pos: .word 0
	player_rep: .asciz "A"
	empty_rep: .asciz "."
	goal_rep:  .asciz "O"
	newline: .byte 10

.section .text
.global get_player_pos
.global reset
.global step
.global print_board

@ A function that returns the player's position
get_player_pos:
	ldr r0, =player_pos
	ldr r0, [r0]
	bx lr

@ A function that reset's the player's position
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

@ A function move's the player in a direction corresponding to the input
@ arguments: r0 - action. 0 is up, 1 is right, 2 is down and 3 is left
@ return: reward
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

@ A function that prints the board's state to the console.
print_board:
	push {r0, r1, r2, r3, r4, lr}
	ldr r2, =goal_pos
	ldr r2, [r2]
	
	ldr r3, =player_pos
	ldr r3, [r3]

	ldr r0, =newline
	bl print_char

	mov r4, #0
	mov r1, #0
loop_print:
	cmp r4, r3
	bne after_player
	ldr r0, =player_rep
	bl print_char
	b finish_char_print

after_player:
	cmp r4, r2
	bne after_goal
	ldr r0, =goal_rep
	bl print_char
	b finish_char_print

after_goal:	
	ldr r0, =empty_rep
	bl print_char

finish_char_print:
	add r1, r1, #1
	cmp r1, #8
	bne after_new_row
	ldr r0, =newline
	bl print_char
	mov r1, #0

after_new_row:
	add r4, r4, #1
	cmp r4, #64
	beq finish_print
	b loop_print

finish_print:
	ldr r0, =newline
	bl print_char

	pop {r0, r1, r2, r3, r4, lr}
	bx lr

@ A function that prints a character to the console using syscall
@ argument: r0 - address to charater to print
print_char:
	push {r0, r1, r2, r7}

	mov r1, r0
	mov r0, #1
	mov r2, #1
	mov r7, #4

	svc #0
	
	pop {r0, r1, r2, r7}
	bx lr




