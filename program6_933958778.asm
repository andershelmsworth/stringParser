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
;--------------------------------------
getString MACRO inputAddress, prompt
;   Prompts user to input an integer,
;	then stores as a string.
;
;	Preconditions: Do not use any of the 
;	general purpose registers as arguments
;
;	Receives: Address for saving input,
;	address of a prompt for the user
;
;	Returns: A saved string at the input address
;
;
;--------------------------------------

	;Save the registers
	pushad

	;Prompt for user input
	mov		edx, prompt
	call	WriteString

	;Get the input from the user
	mov		edx, inputAddress
	mov		ecx, 32; ensure always null-terminated
	call	ReadString

	;Restore the registers
	popad
ENDM

; (insert constant definitions here)

.data

; (insert variable definitions here)
;Variables for introducing the programmer & farewell
titleText	BYTE	"Strings to Signed Integers",0
authName	BYTE	"Programmed by Andrew Helmsworth",0
seeya		BYTE	"Thanks for stopping by, and have a nice day!",0

;Variables for explaining EC
ecOne		BYTE	"**EC: Line numbers and a running subtotal are displayed.",0

;Variables used for program description
descripA	BYTE	"This program will prompt you for 10 signed integers, validating your input.",0dh, 0ah, 0
descripB	BYTE	"Integers must be appropriately sized for a 32-bit register.",0dh, 0ah, 0
descripC	BYTE	"After valid input is received, a list of the entered numbers, their sum, and average will be displayed.",0

;Variables for prompting for user input
plsEnter	BYTE	"Please enter a signed integer: ",0
tryAgain	BYTE	"Please try again: ",0

;Variables for storing user input
userInput	DWORD	33 DUP(0)


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
	push	OFFSET descripC
	push	OFFSET descripB
	push	OFFSET descripA
	push	OFFSET ecOne
	push	OFFSET authName
	push	OFFSET titleText

	;Introduce the program
	call	introduction
	call	CrLf

;--------------------------------------
;GET USER INPUT SECTION
;getUserInput
;
;This section of the program gets 10
;valid integers from the user.
;--------------------------------------

	getString OFFSET userInput, OFFSET plsEnter
	call	CrLf
	mov		edx, OFFSET userInput
	call	WriteString
;--------------------------------------
;FAREWELL SECTION
;farewell
;
;This section of the program bids farewell
;to the user.
;--------------------------------------
	;push string address and call
	;push	OFFSET seeya
	;call	farewell

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
; option and description.
;
; Preconditions: Title, author, EC string, description strings,
; on stack
; Postconditions: Introduction and related strings output to screen
; Receives: Title, author, EC string, description strings,
; on stack
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
;descripA	|	ebp + 20
;descripB	|	ebp + 24
;descripC	|	ebp + 28
;--------------------------------------
	;Introduce title
	mov		edx, [ebp + 8]
	call	WriteString
	call	CrLf

	;Introduce programmer
	mov		edx, [ebp + 12]
	call	WriteString
	call	CrLf

	;Specify EC option
	mov		edx, [ebp + 16]
	call	WriteString
	call	CrLf

	;List program description
	mov		edx, [ebp + 20]
	call	WriteString
	mov		edx, [ebp + 24]
	call	WriteString
	mov		edx, [ebp + 28]
	call	WriteString
	call	CrLf

	;Reset ebp -- esp never moved
	pop		ebp

	;Return but also clear stack
	ret		24

introduction ENDP

; (insert additional procedures here)

END main
