.globl GetGpioAddress
GetGpioAddress:
	// r0 = 0x2020 0000
	ldr r0, =0x20200000
	// return
	mov pc, lr

.globl SetGpioFunction
SetGpioFunction:
	// range checking r0=[0-53], r1=[0-7]
	cmp r0, #53
	// condition cmp: if last cmp is lower same
	cmpls r1, #7
	// condition move: if last cmp is higher
	movhi pc, lr

	// else: push {reg1,reg2,reg3..}
	push {lr}
	// cache r0
	mov r2, r0
	bl GetGpioAddress

	// r0=b_add+4*(r2/10), r2=r2%10
	jump10gpio$:
		cmp r2, #9
		// if r2 > 9 do:
		subhi r2, #10
		addhi r0, #4
		bhi jump10gpio$
		// endif

	// r2= r2*3= r2*(2+1)= r2*2+r2
	add r2, r2, lsl #1
	lsl r1, r2
	str r1, [r0]

	pop {pc}

.globl SetGpio
SetGpio:
	pinNum .req r0
	pinVal .req r1

	cmp pinNum, #53
	//cmpls pinVal, #7
	movhi pc, lr
	push {lr}

	mov r2, pinNum
	.unreq pinNum

	pinNum .req r2
	bl GetGpioAddress

	gpioAddr .req r0
	byteOffset .req r3
	// offset = pinNum/2^5*2^2
	lsr byteOffset, pinNum, #5
	lsl byteOffset, #2
	add gpioAddr, byteOffset
	.unreq byteOffset

	and pinNum, #31
	setBit .req r3
	mov setBit, #1
	lsl setBit, pinNum
	.unreq pinNum

	// check if pinVal == 0
	teq pinVal, #0
	.unreq pinVal
	streq setBit, [gpioAddr, #40]
	strne setBit, [gpioAddr, #28]
	.unreq setBit
	.unreq gpioAddr

	pop {pc}
