.section .init
.globl _start
_start:
/* select function: */
	/* r0 = 0x2020 0000 */
	ldr r0, =0x20200000

	/* r1 = 0x00 0x04 0x00 0x00 */
	mov r1, #1
	lsl r1, #18
	/* [20200004] = r1 */
	str r1, [r0, #4]

	/* r1 = 0x00 0x01 0x00 0x00 */
	mov r1, #1
	lsl r1, #16

loop$:
	/* turn on */
	str r1, [r0, #40]
	mov r2, #0x3F0000
	wait1$:
		sub r2, #1
		cmp r2, #0
		bne wait1$

	/* turn off */
	str r1, [r0, #28]
	mov r2, #0x3F0000
	wait2$:
		sub r2, #1
		cmp r2, #0
		bne wait2$

	b loop$
