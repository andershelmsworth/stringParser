TITLE Strings to Signed Integers     (program6_933958778.asm)

; Author: Andrew Helmsworth
; Last Modified: 2020/06/01
; OSU email address: helmswoa@oregonstate.edu
; Course number/section: 271-400
; Project Number: 6                Due Date: 2020/06/07
; Description: Macros are defined which use Irvine Library 
; procedures to read and write strings. These macros are used
; by writeVal and readVal to get signed numbers from the user,
; read it as a string, validate input, convert it to a signed integer
; and store in an array. The sum and average are calculated and written
; back as strings.

INCLUDE Irvine32.inc

; (insert macro definitions here)

; (insert constant definitions here)

.data

; (insert variable definitions here)

.code
;--------------------------------------
main PROC
;
; Parses user input as a string to an int, prints sum and average
; and validates input
;
; Preconditions: none
; Postconditions: Input prompts, sum, average output to screen
; Receives: none
; Registers changed: esp
; Registers changed (through called procs):
; eax, ebx, ecx, edx, esi, edi, esp, ebp
;
; Returns: none
;
;--------------------------------------
; Used for error detection
	push	47
;--------------------------------------
;INTRODUCTION SECTION
;introduction
;
;This section of the program
;introduces the programmer and
;title.
;--------------------------------------
	;Push string offsets in reverse order
	;as they are needed in introduction



;--------------------------------------
;FAREWELL SECTION
;farewell
;
;This section of the program bids farewell
;to the user.
;--------------------------------------
	;push string address and call
	push	OFFSET seeya
	call	farewell

	;Used for error detection
	pop		eax
	;call	WriteDec
	call	CrLf

	exit	; exit to operating system
main ENDP

; (insert additional procedures here)
;--------------------------------------
introduction PROC
;
; Introduces program title and name
; of programmer, as well as extra credit
; options and description.
;
; Preconditions: Title, author, 3 EC strings, description strings,
; arraySize, HI, LO on stack
; Postconditions: Introduction and related strings output to screen
; Receives: Title, author, 3 EC strings, description strings,
; arraySize, HI, LO on stack
; Registers changed: eax, ecx, edx, ebp, esp, esi
;
; Returns: none
;
;--------------------------------------

	;Save ebp and set the base pointer
	push	ebp
	mov		ebp, esp

;--------------------------------------
; CITATION: Concept learned from reference:
; https://piazza.com/class/k83uhw9nnyd2y9?cid=278
;--------------------------------------
;; STACK FRAME CONTENTS
; 
;old ebp	|	ebp <-(Also esp)
;return @	|	ebp + 4
;titleText	|	ebp + 8
;authName	|	ebp + 12
;ecOne		|	ebp + 16
;ecTwo		|	ebp + 20
;ecThree	|	ebp + 24
;descripA	|	ebp + 28
;descripAb	|	ebp + 32
;descripB	|	ebp + 36
;descripC	|	ebp + 40
;descripD	|	ebp + 44
;descripE	|	ebp + 48
;descripF	|	ebp + 52
;HI			|	ebp + 56
;LO			|	ebp + 60
;ARRAYSIZE	|	ebp + 64
;--------------------------------------


	;Reset ebp -- esp never moved
	pop		ebp

	;Return but also clear stack
	ret		60

introduction ENDP

; (insert additional procedures here)

END main
