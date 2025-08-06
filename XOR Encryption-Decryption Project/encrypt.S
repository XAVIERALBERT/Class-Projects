#ifndef MYENCRYPT_S
#else
// version 1.0 11/12/2022
    .arch armv6
    .arm
    .fpu vfp
    .syntax unified

    #include "cipher.h"

    .text     // start of text segment

    //////////////////////////////////////////////////
    // int encrypt(char *iobuf, char *bookbuf, int cnt)
    // encrypts  iobuf with bookbuf; updating iobuf
    //////////////////////////////////////////////////
    .global encrypt
    .type   encrypt, %function
    .equ    FP_OFF, 28

encrypt:
    push    {r4-r9, fp, lr}
    add     fp, sp, FP_OFF
    // do not alter anything above this line
    // r0 contains char *iobuf
    // r1 contains char *bookbuf
    // r2 contains cnt
    // r3 is ok to use
    // r4-r9 preserved registers are ok to use

	cmp 	r2, 0				//if buffer empty we are done
	ble		.Ldone

	mov		r3, 0 				// int key = 0; r3
	
	cmp 	r3, r2				// (outer while) precond. while(key < cnt)
	bge		.Lendw				//.
.Lwhile: 						//.
	mov		r4, 0				// int inc = 0; r4
	mov 	r5, 0				// unsigned int reverse = 0 r5
	ldrb 	r6, [r0, r3]		// unsigned int curC = (unsigned int) *(iobuf + key) r6
	
	cmp 	r4, 8				// (inner while) precond. while (inc < 8)
	bge 	.Lendw2				//.
.Lwhile2:						//.
	mov 	r7, r6				//temp = curC r7
	AND		r7, r7, 1			//temp = temp & 1
	LSL 	r5, r5, 1			// reverse = reverse << 1
	ORR 	r5, r7, r5			// reverse = temp | reverse
	LSR 	r6, r6, 1			// curC = curC >> 1
	ADD		r4, r4, 1			//inc++
	cmp 	r4, 8				//post test
	blt 	.Lwhile2			//.
.Lendw2:						// end of inner while loop
	
	ldrb 	r8, [r1, r3]		//unsigned int bookbufint = (unsigned int) *(bookbuf + key) r8
	eor 	r5, r5, r8			// reverse = reverse ^ bookbufint
	strb	r5, [r0, r3]		// *(iobuf + key) = reverse

	ADD 	r3, r3, 1			// key++
	cmp 	r3, r2				//post test
	blt 	.Lwhile				//.
.Lendw:							// end of outer while loop

    // do not alter anything below this line
.Ldone:
    mov     r0, r2              // return cnt processed
    sub     sp, fp, FP_OFF
    pop     {r4-r9, fp, lr}
    bx      lr

    .size encrypt, (. - encrypt)
    .section .note.GNU-stack,"",%progbits
.end
#endif
