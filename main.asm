;-------------------------------------------------------------------------------
; MSP430 Assembler Code Template for use with TI Code Composer Studio
;
; Name: C2C Brian Yarbrough
; Section: ECE 382, T5
; MCU: MSP430G2553
; Lab 02: Cryptogrophy
; Description: This program decrypts a message given a known key. If the key is unknown, it must be found externally and then inputted.
;		The message must be in bytes, but the key can be any length as long as the lenght of the key is updated in ROM before running
;		Additionally, this program makes use of subroutines, this helps break the problem into smaller parts and keep things clean.
;			Enter message under "messg:" , the key under "key:" , and the length of the key in bytes under "keyL:"
;
; Date Due: 18 Sep 14
;
;-------------------------------------------------------------------------------
            .cdecls C,LIST,"msp430.h"       ; Include device header file

;-------------------------------------------------------------------------------
            .text                           ; Assemble into program memory
            .retain                         ; Override ELF conditional linking
                                            ; and retain current section
            .retainrefs                     ; Additionally retain any sections
                                            ; that have references to current
                                            ; section
; Store Key Here
key:	.byte	0x73, 0xBE ;0xac; , 0xdf, 0x23
keyL:	.byte	0x2		;length of the key in bytes
;Store Message to be decoded here
messg:
		;A functionality
		.byte 0x35,0xdf,0x00,0xca,0x5d,0x9e,0x3d,0xdb,0x12,0xca,0x5d,0x9e,0x32,0xc8,0x16,0xcc,0x12,0xd9,0x16,0x90
		.byte 0x53,0xf8,0x01,0xd7,0x16,0xd0,0x17,0xd2,0x0a,0x90,0x53,0xf9,0x1c,0xd1,0x17,0x90,0x53,0xf9,0x1c,0xd1,0x17,0x90, 0x8f

		;B functionality
	;	.byte 0xf8,0xb7,0x46,0x8c,0xb2,0x46,0xdf,0xac,0x42,0xcb,0xba,0x03,0xc7,0xba,0x5a,0x8c,0xb3,0x46,0xc2,0xb8
	;	.byte 0x57,0xc4,0xff,0x4a,0xdf,0xff,0x12,0x9a,0xff,0x41,0xc5,0xab,0x50,0x82,0xff,0x03,0xe5,0xab,0x03,0xc3
	;	.byte 0xb1,0x4f,0xd5,0xff,0x40,0xc3,0xb1,0x57,0xcd,0xb6,0x4d,0xdf,0xff,0x4f,0xc9,0xab,0x57,0xc9,0xad,0x50
	;	.byte 0x80,0xff,0x53,0xc9,0xad,0x4a,0xc3,0xbb,0x50,0x80,0xff,0x42,0xc2,0xbb,0x03,0xdf,0xaf,0x42,0xcf,0xba,0x50,0x8f

	;Required functionality
	;	.byte	0xef,0xc3,0xc2,0xcb,0xde,0xcd,0xd8,0xd9,0xc0,0xcd,0xd8,0xc5,0xc3,0xc2,0xdf,0x8d,0x8c,0x8c,0xf5
	;	.byte	0xc3,0xd9,0x8c,0xc8,0xc9,0xcf,0xde,0xd5,0xdc,0xd8,0xc9,0xc8,0x8c,0xd8,0xc4,0xc9,0x8c,0xe9,0xef
	;	.byte	0xe9,0x9f,0x94,0x9e,0x8c,0xc4,0xc5,0xc8,0xc8,0xc9,0xc2,0x8c,0xc1,0xc9,0xdf,0xdf,0xcd,0xcb,0xc9
	;	.byte	0x8c,0xcd,0xc2,0xc8,0x8c,0xcd,0xcf,0xc4,0xc5,0xc9,0xda,0xc9,0xc8,0x8c,0xde,0xc9,0xdd,0xd9,0xc5
	;	.byte	0xde,0xc9,0xc8,0x8c,0xca,0xd9,0xc2,0xcf,0xd8,0xc5,0xc3,0xc2,0xcd,0xc0,0xc5,0xd8,0xd5,0x8f


;Initialize Registers
mTrk:		.equ		r5		;register for tracking location on encrypted message
work:		.equ		r6		;workhorse register - this is where things will be decrypted
dTrk:		.equ		r7		;register for tracking location on the resulting message
kTrk:		.equ		r8		;register for tracking key increment
;-------------------------------------------------------------------------------
RESET       mov.w   #__STACK_END,SP         ; Initialize stackpointer
StopWDT     mov.w   #WDTPW|WDTHOLD,&WDTCTL  ; Stop watchdog timer

;-------------------------------------------------------------------------------
                                            ; Main loop here
;-------------------------------------------------------------------------------
			mov.b	#0x61, key

			mov 	#messg, mTrk	;point at start of message
			mov	 	#0x200, dTrk	;point decryted at proper place in RAM
			mov		#key, kTrk		;point at start of key

            call    #decryptMessage

forever:    jmp     forever

;-------------------------------------------------------------------------------
                                            ; Subroutines
;-------------------------------------------------------------------------------

;-------------------------------------------------------------------------------
;Subroutine Name: decryptMessage
;Author: Brian Yarbrough
;Function: Decrypts a string of bytes and stores the result in memory.  Accepts
;           the address of the encrypted message, address of the key, and address
;           of the decrypted message (pass-by-reference).  Accepts the length of
;           the message by value.  Uses the decryptCharacter subroutine to decrypt
;           each byte of the message.  Stores theresults to the decrypted message
;           location.
;Inputs: r5, r6, r7
;Outputs: stores decrypted message in RAM
;Registers destroyed: r5, r6, r7
;-------------------------------------------------------------------------------

decryptMessage:
			push	r9

loopKey		mov		#key, kTrk
			clr		r9

nextByte	inc		r9
			mov.b	@mTrk+, work	;stage byte for decryption
			call	#decryptCharacter ;call second subroutine
			mov.b	work, 0(dTrk)	;store decrypted
			inc		dTrk
			cmp.b	#0x8F, mTrk		;check for end character
			jz		return
			inc		kTrk
			cmp.b 	r9, keyL		;decide if key was fully used
			jz		loopKey
			jmp		nextByte	;if not, go again

return		pop		r9
			ret

;-------------------------------------------------------------------------------
;Subroutine Name: decryptCharacter
;Author: Brian Yarbrough
;Function: Decrypts a byte of data by XORing it with a key byte.  Returns the
;           decrypted byte in the same register the encrypted byte was passed in.
;           Expects both the encrypted data and key to be passed by value.
;Inputs:  r5, r6, r7 - pointers and register for decryption
;Outputs: r6 - decrypted byte
;Registers destroyed: r6
;-------------------------------------------------------------------------------

decryptCharacter:
			push	mTrk
			push	dTrk
			xor.b	@kTrk, work
			pop		dTrk
			pop		mTrk
            ret

;-------------------------------------------------------------------------------
;           Stack Pointer definition
;-------------------------------------------------------------------------------
            .global __STACK_END
            .sect    .stack

;-------------------------------------------------------------------------------
;           Interrupt Vectors
;-------------------------------------------------------------------------------
            .sect   ".reset"                ; MSP430 RESET Vector
            .short  RESET
