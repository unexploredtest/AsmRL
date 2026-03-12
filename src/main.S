.section .data
	train_steps: .word 10000

.section .text
.global _start

_start:
	ldr r0, =train_steps
	ldr r0, [r0]
	bl train
	bl reset
	bl print_board

print_loop:
	bl get_player_pos
	bl get_best_action
	bl step
	bl print_board
	cmp r0, #0
	beq print_loop

	mov r0, #0
	mov r7, #1
	swi #0
