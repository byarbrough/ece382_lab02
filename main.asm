;-------------------------------------------------------------------------------
; MSP430 Assembler Code Template for use with TI Code Composer Studio
; Lab02
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
key:	.byte	0xac

;Store Message to be decoded here
messg:	.byte	0xef, 0xc3, 0xc2, 0xcb, 0xde, 0xcd

;Initialize Registers
mTrk:		.equ		r5		;register for tracking location on encrypted message
work:		.equ		r6		;workhrse register - this is where things will be decrypted
dTrk:		.equ		r7		;register for tracking location on the resulting message

;-------------------------------------------------------------------------------
RESET       mov.w   #__STACK_END,SP         ; Initialize stackpointer
StopWDT     mov.w   #WDTPW|WDTHOLD,&WDTCTL  ; Stop watchdog timer

;-------------------------------------------------------------------------------
                                            ; Main loop here
;-------------------------------------------------------------------------------
		mov		#mssg, mTrk	;point the register at the start of the message
		mov		#0x200, dTrk	;starting location for decrypted message



;-------------------------------------------------------------------------------
;           Stack Pointer definition
;-------------------------------------------------------------------------------
            .global __STACK_END
            .sect 	.stack

;-------------------------------------------------------------------------------
;           Interrupt Vectors
;-------------------------------------------------------------------------------
            .sect   ".reset"                ; MSP430 RESET Vector
            .short  RESET
