    // version 1.0 05/22/2022 //
#ifndef MYMAIN_S
#else
    .arch   armv6
    .arm
    .fpu    vfp
    .syntax unified

    // imports
    #include "main.h"
    #include "rdbuf.h"
    #include "setup.h"
    #include "cipher.h"
    .extern fwrite
    .extern stdin
    .extern stdout
    .extern stderr

    .section .rodata
    // do not change these error messages
.Lbdrd:  .string "%s: read failed\n"
.Lbdwr:  .string "%s: write failed\n"

    .text

    //
    // encrypter [-d | -e] -b bookfile
    //
    // int main(int argc, char **argv)
    // int main(r0=argc, r1=argv)

    .global main
    .type   main, %function

    //
    // stack frame layout
    //
    // TODO PA9: complete the following stack frame design
    // You can change or delete any comments in this file
    //
    .equ    FP_OFF,     32          		// fp offset in main stack frame
    .equ    FPBOOK,     FP_OFF + 4          // FILE * to book file
    .equ    IOBUF,      FPBOOK + BUFSZ      // buffer for input file
    .equ    MODE,       IOBUF + 4           // decrypt or encrypt mode
    .equ    BOOKBUF,    MODE + BUFSZ        // buffer for book file
    .equ    ARGV0,      BOOKBUF + 4         // save argv[0] for error printing
    //
    // add your local variables here if you need them:
    // NOTICE: Adjust PAD so FRMADD + FP_OFF + 4 divides by 8 EVENLY!
    //
	.equ	LOCAL_RDBUF,	ARGV0 + 4
	.equ	LOCAL_ARGC,		LOCAL_RDBUF + 4
    .equ 	PAD,		LOCAL_ARGC + 4      // Stack frame PAD
    .equ    OARG5,      PAD + 4             // output arg5 must be at bottom
    .equ    FRMADD,     OARG5-FP_OFF 		// space in frame for locals+passed args

    // TODO PA9: list how you are using the preserved registers
    // preserved register use
    // r4 fpbook
    // r5 iobuf
    // r6 mode flag
    // r7 bookbuf
    // r8 
    // r9 save r1
    // r10

main:
    push    {r4-r10, fp, lr}       		// push all the usable preserved registers
    add     fp, sp, FP_OFF          	// set frame pointer to frame base
    ldr     r3, =FRMADD             	// get space needed for locals+passed args
    sub     sp, sp, r3              	// allocate space for locals and passed args 
		
	ldr 	r10, [r1]					// argv[0] stored in ARGV0
	str		r10, [fp, -ARGV0]			//.

	str		r0, [fp, -LOCAL_ARGC]		//stores argc into local var. LOCAL_ARGC
	
    // at the entry to main() argc is in r0 and argv is in r1.
    // call int setup(r0=argc, r1=argv, r2=*mode, r3=*FPBOOK)
    // r2 and r2 are output parameters. Put the address of where mode
    // and FPBOOK are located on main()'s stack and put these in r2 and r3
    // so setup can fill them in (passing a pointer to a local variable in r2,r3)
    // if setup fails, put EXIT_FAIL in r0 and then branch to .Lexit

	//r0 should still be argc and r1 should still be **argv

	sub		r6, fp, MODE		//r2 = address of mode
	mov 	r2, r6				//.

	sub		r4, fp, FPBOOK		// r3 = address of fpbook
	mov 	r3, r4				//.
	
	bl 		setup				//calls setup (branch and link)

	cmp		r0, 0				//if statement, compares r0 to 0
	beq		.Lendif				// r0 is not 0
	mov 	r0, EXIT_FAILURE	// set r0 = EXIT_FAIL
	b		.Lexit				// branch to .Lexit
	
.Lendif:

    // set up for main loop
    // save the variables you need in the preserved registers as you will be making
    // function calls in the loop body below and r0-r3 will be used for that

.Lloop:

	ldr 	r8, =stdin		//r0 = stdin
	ldr		r8, [r8]		//.
	mov 	r0, r8			//.

	sub		r10, fp, FPBOOK	//r1 = fpbook
	ldr		r10, [r10]		//.
	mov		r1, r10			//.

	mov 	r2, BUFSZ		//r2 = BUFSZ
	
	sub		r5, fp, IOBUF	//r3 = IOBUF
	mov		r3, r5

	sub		r4, fp, BOOKBUF
	str		r4, [fp, -OARG5]

	bl		rdbuf				// bl into rdbuf

	cmp		r0, 0				//if statement that compares if r0 = 0
	bne		.Lendif2			//.
	b		.Ldone				//.
.Lendif2:
	cmp		r0, 0				// if statement that compares if r0 < 0
	bge		.Lendif3			//.

	ldr		r0, =stderr			//r0 = stderr
	ldr		r0, [r0]			//.
	ldr		r1, =.Lbdrd			//r1 = .Lbdrd
	sub		r2, fp, ARGV0		//r2 = *argv0
	ldr		r2, [r2]			//.
	
	bl 		fprintf		
	b		.Ldone
.Lendif3:
	
	str 	r0, [fp, -LOCAL_RDBUF]		//saves bytes into local variable

    // this is a loop that runs until rdbuf indicates the EOF on stdin
    // was reached or there was an error.
    // int rdbuf(r0=stdin, r1=fpbook, r2=BUFSZ, r3=iobuf,OARG5=bookbuf)
    // NOTICE that the 5th arg is on the stack so you need to str the 
    // address of bookbuf at offset OARG5 on the stack
    // if r0 on return from rdbuf has a 0 in r0 we are done, branch to .Ldone
    // if return less than 0, error print to stderr .Lbdrd, and go to .Ldone ABOVE ^^^^

    // check the mode flag and call either encrypt or decrypt
    // int XXcrypt(r0=char *iobuf, r1=char *bookbuf, r2=int cnt)
    // encrypt or decrypt 
    // returns cnt
	
	//just reload from locals
	
	sub 	r0, fp, IOBUF 			//r0 = iobuf
	sub 	r1, fp, BOOKBUF			//r1 = bookbuf
	sub		r2, fp, LOCAL_RDBUF		//r2 = bytes
	ldr		r2, [r2]				//.
	
	sub		r6, fp, MODE
	ldr		r6, [r6]

	cmp 	r6, ENCRYPT_MODE		//compares r6, mode to encrypt_mode
	bne 	.Lelse					//.
	bl 		encrypt					// bl encrypt
	b		.Lendif4				//.
.Lelse:								
	bl 		decrypt					// bl into decrypt otherwise
.Lendif4:							
	mov		r10, r0			// saves cnt into r10

	sub 	r0, fp, IOBUF	// reloads r0 with iobuf
	mov 	r1, 1			// r1 = 1
	mov		r2, r10			// r2 = cnt
	ldr		r8, =stdout		// r3 = stdout
	ldr		r8, [r8]
	mov		r3, r8			//.
	
	bl 		fwrite			//bl into fwrite

	cmp		r0, r10			//compares r0 to r10
	bne		.Lelse2			//if r0 != r10 fall through
	b		.Lendif5		//else end if statement
.Lelse2:
	ldr		r0, =stderr		//r0 = stderr
	ldr		r0, [r0]		//.
	ldr		r1, =.Lbdwr		//r1 = .Lbdwr
	sub		r2, fp, ARGV0	//r2 = *argv0
	ldr		r2, [r2]
	
	bl 		fprintf			//bl into fprintf
	b		.Ldone
.Lendif5:

	b		.Lloop			//branches back to beginning of .Lloop

    // make sure to save cnt so we can check that fwrite wrote cnt characters
    // fwrite returns number of characters it wrote.
    // fwrite(r0=iobuf, r1=1, r2=cnt, r3=*stdout)
    // if cnt characters written go to .Lloop (write is ok)
    // othewise error, print to stderr .Lbdwr and fall through to .Ldone
    
.Ldone:
    // normal exit, call fclose of fpbook and fall through
    // to .Lexit

	sub 	r0, fp, FPBOOK 		//reloads r0 to fpbook
	ldr		r0, [r0]
	bl 		fclose				//bl to fclose

.Lexit:
    sub     sp, fp, FP_OFF
    pop     {r4-r10, fp, lr}
    bx      lr

    .size   main, (. - main)
    .section .note.GNU-stack,"",%progbits
.end
#endif
