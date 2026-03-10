.section .data
	Qs: .fill 256, 4, 0          @ 8 * 8 * 4 
	visits: .fill 256, 4, 0      @ 8 * 8 * 4 
	gamma: .float 0.9
	alpha: .float 0.1

.section .text
.global train
@ .global get_value
.global get_best_action

@ parameter. r0: num of training steps
train:
	@ r0: volatile, r1: steps remaining, r2: player pos, r3: next player pos, r4: action, r5: reward
	@ r6: relative address of current action, r8: num of visits, r9: current value
	push {r0, r1, r2, r3, r4, r5, lr}
	mov r1, r0
	bl reset	
	bl get_player_pos
	mov r2, r0

train_loop:
	subs r1, r1, #1
	bmi train_finish
	
	mov r0, r2
	bl get_action
	mov r4, r0
	bl step
	mov r5, r0
	bl get_player_pos
	mov r3, r0

	lsl r6, r2, #4   @ multiply by 4*4=16
	lsl r7, r4, #2   @ multiply by 4
	add r6, r6, r7
	ldr r7, =visits
	add r7, r6, r7
	ldr r8, [r7]
	add r8, r8, #1
	str r8, [r7]
	sub r8, r8, #1
	
	@ s0: new_value, s1: current_value, s2: next_value, s3: gamma, s4: alpha, s5: reward

	mov r0, r3
	bl get_best_value
	vldr s2, [r0]
	ldr r7, =Qs
	add r6, r7, r6	
	vldr s1, [r6]
	vldr s3, =gamma
	vldr s4, =alpha 
	vmov s5, r5
	vcvt.f32.s32 s5, s5

	@ here begins the calculation
	vmov s0, s2           @ next value
	vmul.f32 s0, s3, s0   @ gamma * (next value)
	vadd.f32 s0, s5, s0   @ reward + gamma * (next value)
	vsub.f32 s0, s0, s1   @ reward + gamma * (next value) - current value
	vmul.f32 s0, s4, s0   @ alpha * (reward + gamma * (next value) - current value)
	vadd.f32 s0, s1, s1   @ current value + alpha * (reward + gamma * (next value) - current value)

	vstr s0, [r6]
	
	mov r2, r3 @ make next action be the current action	

	b train_loop
	
train_finish:
	pop {r0, r1, r2, r3, r4, r5, lr}
	bx lr


@ argument: r0 - player position return: r0 - action
@ epsilon is hard coded to be 0.25
get_action:
	push {r1, r2, r3, r4, r5, lr}
	mov r1, r0
	bl get_random_num
	ands r0, r0, #3
	
	beq return_best
	bl get_random_num
	and r0, r0, #3
	b finish_get_action

return_best:
	mov r0, r1
	bl get_best_action

finish_get_action:
	pop {r1, r2, r3, r4, r5, lr}	
	bx lr


@ argument: r0 - player position return: r0 - best action
get_best_action:
	push {r1, r2, r3, r4, r5, lr}
	lsl r0, r0, #4   @ each index consumes 4*4 bytes
	ldr r1, =Qs
	add r1, r0, r1

	mov r0, #0
	vldr s0, [r1]

	mov r2, #1	
loop_get_best_action:
	cmp r2, #4
	beq finish_get_best_action

	add r2, r2, #1
	add r1, r1, #4
	vldr s1, [r1]

	vcmp.f32 s0, s1
	bgt loop_get_best_action
	vmov s0, s1
	sub r0, r2, #1
	b loop_get_best_action

finish_get_best_action:	
	pop {r1, r2, r3, r4, r5, lr}
	bx lr

@ argument: r0 - player position return: r0 - best value address
get_best_value:
	push {r1, r2, r3, r4, r5, lr}
	lsl r0, r0, #4   @ each index consumes 4*4 bytes
	ldr r1, =Qs
	add r1, r0, r1

	mov r0, r1
	vldr s0, [r1]

	mov r2, #1	
loop_get_best_value:
	cmp r2, #4
	beq finish_get_best_value

	add r2, r2, #1
	add r1, r1, #4
	vldr s1, [r1]

	vcmp.f32 s0, s1
	bgt loop_get_best_value
	vmov s0, s1
	mov r0, r1
	b loop_get_best_value

finish_get_best_value:	
	pop {r1, r2, r3, r4, r5, lr}
	bx lr
































