
.globl GetSystemTimerBase
GetSystemTimerBase:
	ldr r0, =0x20003000
	mov pc, lr

/* return high32:r1 low32: r0 */
.globl GetTimeStamp
GetTimeStamp:
	push {lr}
	l32 .req r0
	h32 .req r1
	timerBase .req r0

	bl GetSystemTimerBase
	ldrd l32, h32, [timerBase, #4]

	.unreq timerBase
	.unreq l32
	.unreq h32
	pop {pc}

/* r0 delay time */
.globl TimeDelay
TimeDelay:
	push {lr}

	timeNowL32 .req r0
	desireDelay .req r2
	initialTime .req r3

	mov desireDelay, r0

	bl GetTimeStamp
	mov initialTime, timeNowL32

	_loop:
		timeDiff .req r1
		bl GetTimeStamp
		sub timeDiff, timeNowL32, initialTime
		cmp timeDiff, desireDelay
		pophi {pc}
		b _loop

	.unreq timeNowL32
	.unreq desireDelay
	.unreq initialTime

