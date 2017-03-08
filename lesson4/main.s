.section .init
.globl _start
_start:
	mov sp, #0x8000
	b main

.section .text
main:
	pinNum .req r0
	pinFunc .req r1
	mov pinNum, #16
	mov pinFunc, #1
	bl SetGpioFunction
	.unreq pinNum
	.unreq pinFunc

loop:
	pinNum .req r0
	pinVal .req r1
	mov pinNum, #16
	mov pinVal, #1
	bl SetGpio

	ldr r0, =OneSecond
	ldr r0, [r0]
	bl TimeDelay

	mov pinNum, #16
	mov pinVal, #0
	bl SetGpio
	.unreq pinNum
	.unreq pinVal

	ldr r0, =OneSecond
	ldr r0, [r0]
	bl TimeDelay

	b loop

.section .data
.align 2
OneSecond:
.int 0x000F4240
