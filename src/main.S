.section .text
.global _start

_start:
	mov r1, #100
	mul r0, r1, r1
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
