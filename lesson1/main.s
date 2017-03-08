.section .init
.globl _start
_start:

	/* r0 = base */
	ldr r0, =0x20200000

	/* r1 = value of 1 << 18 */
	mov r1, #1
	lsl r1, #18
	/* function selection */
	str r1, [r0, #4]

	/* turn off pin to turn on led */
	mov r1, #1
	lsl r1, #16
	str r1, [r0,#40]

_loop$:
	b _loop$