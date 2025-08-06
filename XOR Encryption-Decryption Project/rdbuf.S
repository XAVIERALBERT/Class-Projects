#ifndef MYRDBUF_S
#else
// version 1.0 10/12/2022 //
    .arch   armv6
    .arm
    .fpu    vfp
    .syntax unified

    // global constants
    #include "cipher.h"

    .extern fread
    .extern feof
    .extern ferror
    .text

    // int rdbuf(r0=FILE *in, r1=FILE *book, r2=int cnt, r3=char *iobuf, 
    //            on the stack at ARG5 offset=char *bookbuf)
    // returns number of bytes read EXIT_FAIL otherwise
    // you can change or remove any comments in this file

    .type   rdbuf, %function
    .global rdbuf
    .equ    ARG5,  4 
    .equ    FP_OFF, 28
 
rdbuf:
    push    {r4-r9, fp, lr}
    add     fp, sp, FP_OFF

    // save the register args (r0-r3) into preserved registers
    // as there are many function calls SAVE IN ONE OF THE PRESERVED REGISTERS
	// WHATEVER IS RETURNING MOV TO R0, THEN BRANCH INTO .LDONE
	
    mov 	r5, r0		// *in
	mov		r6, r1		// *fpbook
	mov		r7, r2		// cnt
	mov		r8, r3		// *iobuf
	ldr		r9, [fp, 4]	//*bookbuf

	bl		feof		// branch links into feof
	cmp 	r0, 0		// compares r0 to 0
	beq		.Lendif 		// see if r0 = 0
	mov		r0, 0		// fall through, sets r0 = 0
	b		.Ldone		// branches into done
.Lendif:
	mov 	r0, r5		//reloads reg

	bl 		ferror		//branch links into ferror
	cmp		r0, 0		// compares r0 to 0
	beq		.Lendif2		// see if r0 = 0
	mov		r0, EXIT_FAIL		//falls through, moves r0 to EXIT_FAIL
	b		.Ldone		//branches into done
.Lendif2:
	mov 	r0, r8		//r0 = *iobuf
	mov		r1, 1		// r1 = 1
	mov		r2, r7		// r2 = cnt
	mov		r3, r5		// r3 = *in

	bl 		fread		//branch links into fread
	cmp 	r0, 0		//compares r0 to 0
	bgt		.Lendif3		// see if r0 is less than equal to 0
	mov		r0, 0		// fall through, sets r0 to 0
	b		.Ldone		//branches into done
.Lendif3:
	mov 	r4, r0		//saves bytes

	mov 	r0,	r9		// r0 = bookbuf
	mov 	r1, 1		// r1 = 1
	mov		r2, r4		// r2 = bytes
	mov 	r3, r6		// r3 = fpbook

	bl		fread		// branch links into fread
	cmp		r0, r4		//compares r0 and bytes
	beq		.Lendif4		// sees if r0 != bytes
	mov		r0, EXIT_FAIL		//falls through, moves r0 to EXIT_FAIL
	b  		.Ldone		//branches into done
.Lendif4:
	mov 	r0, r4		//moves bytes into r0
	b		.Ldone		//branches into done


    // check for end of file feof(in)
    // if r0 is not zero at EOF, set r0 to 0 and return
    // otherwise check for read errors
    // check for error ferror(in)
    // if r0 is zero, no errors, do the reads
    // if r0 is not zero, set r0 to EXIT_FAIL and return

    // bytes = fread(r0=iobuf, r1=1, r2=cnt, r3=in)
    // save bytes so we can check that we read same bytes from bookfile
    // if r0 <= 0 return with r0 = 0

    // r0 = fread(r0=bookbuf, r1=1, r2=bytes, r3=book)
    // the pointer to bookbuf is passed on the stack so
    // you need to do a ldr from ARG5 offset to get the address
    // to pass to the fread
    // if r0 on the return from fread is not equal to bytes 
    // return in r0 from stdin (into iobuf) return EXIT fail
    // otherwise set r0 = bytes and return

.Ldone:
    sub     sp, fp, FP_OFF
    pop     {r4-r9, fp, lr}
    bx      lr

    .size   rdbuf, (. - rdbuf)
    .section .note.GNU-stack,"",%progbits
.end
#endif
