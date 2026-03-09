.section .text
.global _start

_start:
	@ bl reset
	mov r0, #2
	bl step
	mov r0, #1
	bl step
	@ bl get_player_pos
    mov r7, #1          @ Load syscall number 1 (exit) into r7
    swi #0              @ Trigger the software interrupt to perform the syscall
