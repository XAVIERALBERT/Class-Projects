#ifndef MYDECRYPT_S
#else
// version 1.0 11/12/2022
    .arch armv6
    .arm
    .fpu vfp
    .syntax unified

    #include "cipher.h"

    .text     // start of text segment

    //////////////////////////////////////////////////
    // int decrypt(char *iobuf, char *bookbuf, int cnt)
    // decrypts iobuf using bookbuf; result in iobuf
    //////////////////////////////////////////////////
    .global decrypt
    .type   decrypt, %function
    .equ    FP_OFF, 28

decrypt:
    push    {r4-r9, fp, lr}
    add     fp, sp, FP_OFF
    // do not alter anything above this line
    // r0 contains char *iobuf
    // r1 contains char *bookbuf
    // r2 contains cnt
    // r3 is ok to use
    // r4-r9 preserved registers are ok to use

    cmp     r2, 0               // if buffer empty we are done
    ble     .Ldone

    // your code here
	
	mov		r3, 0				// int key = 0; r3

	cmp		r3, r2				//(outer while) precond. while (key < cnt)
	bge		.Lendw				//.
.Lwhile:						//.
	ldrb	r4, [r1, r3]		//unsigned int bookbufint = (unsigned int) *(bookbuf + key) r4
	ldrb 	r9, [r0, r3]		//*(iobuf + key)
	eor		r9, r4, r9			// temp = *(iobuf + key) ^ bookbufint
	strb	r9, [r0, r3]		// *(iobuf + key) = temp
	mov 	r5, 0				//int inc = 0; r5
	mov 	r6, 0				// unsigned int reverse = 0;
	ldrb	r7, [r0, r3]		// unsigned int curC = (unsigned)*(iobuf + key)

	cmp		r5, 8				//(inner while) precond. while (inc < 8)
	bge		.Lendw2				//.
.Lwhile2:						//.
	mov 	r8, r7				//temp = curC
	AND		r8, r8, 1			//temp = temp & 1
	LSL		r6, r6, 1			//reverse = reverse << 1
	ORR 	r6, r8, r6			// reverse = temp | reverse
	LSR		r7, r7, 1			//curC = curC >> 1
	ADD		r5, r5, 1			//inc++
	cmp		r5, 8				//post test
	blt		.Lwhile2			//.
.Lendw2:						//end of inner while loop
	strb 	r6, [r0, r3]		//*(iobuf + key) = reverse

	ADD		r3, r3, 1			//key++
	cmp		r3, r2				//post test
	blt		.Lwhile				//.
.Lendw:							//end of outer while loop
	

    // do not alter anything below this line
.Ldone:
    mov     r0, r2              // return cnt processed
    sub     sp, fp, FP_OFF
    pop     {r4-r9, fp, lr}
    bx      lr

    .size decrypt, (. - decrypt)
    .section .note.GNU-stack,"",%progbits
.end
#endif
