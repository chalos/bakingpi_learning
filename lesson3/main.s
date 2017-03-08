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
	mov pinVal, #0
	bl SetGpio

	mov r0, #0x3F0000
	bl wait

	mov pinNum, #16
	mov pinVal, #1
	bl SetGpio
	.unreq pinNum
	.unreq pinVal

	mov r0, #0x3F0000
	bl wait

	b loop

.globl wait
wait:
	decr .req r0
	sub decr,#1
	teq decr,#0
	bne wait
	.unreq decr
	mov pc, lr
