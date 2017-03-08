.section .init
.globl _start
_start:
	mov sp, #0x8000
	b sos_main

.section .text
sos_main:
	pinNum .req r0
	pinFunc .req r1
	mov pinNum, #16
	mov pinFunc, #1
	bl SetGpioFunction
	.unreq pinNum
	.unreq pinFunc

loadPattern:
	pattern .req r4
	counter .req r5
	ldr pattern, =SosPattern
	ldr pattern, [pattern]
	mov counter, #32

loop:
	pinNum .req r0
	pinVal .req r1
	and pinVal, pattern, #1
	mov pinNum, #16
	bl SetGpio
	.unreq pinNum
	.unreq pinVal

	desireDelay .req r0
	ldr r0, =OneSecond
	ldr desireDelay, [r0]
	bl TimeDelay
	.unreq desireDelay

	lsr pattern, pattern, #1
	sub counter, counter, #1
	cmp counter, #0

	bne loop
	beq loadPattern

.section .data
.align 2
OneSecond:
	.int 0x000F4240

.align 2
SosPattern:
	/* reverse pattern */
	.int 0b11111111101010100010001000101010
