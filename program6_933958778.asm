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
tryAgain	BYTE	"Error! You didn't enter a signed int, or you overflowed the register.",0dh, 0ah
			BYTE	"Please try again: ",0

;Variables for storing user input
userInput	BYTE	33 DUP(0)
validInt	DWORD	?
isNeg		DWORD	0
minus		BYTE	"-"
plus		BYTE	"+"
emptyStr	BYTE	33 DUP(0)
intArray	SDWORD	10 DUP(?)
arrayCount	DWORD	10

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

	;Push user input offsets in the reverse
	;order that they are needed in the proc
	push	OFFSET arrayCount
	push	OFFSET intArray
	push	OFFSET emptyStr
	push	OFFSET minus
	push	OFFSET plus
	push	OFFSET isNeg
	push	OFFSET validInt
	push	OFFSET userInput
	push	OFFSET tryAgain
	push	OFFSET plsEnter

	;Get 10 values
	call	getNumbers
	call	CrLf

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
	call	WriteDec
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
;--------------------------------------
readVal PROC
;
; Gets and validates a signed integer from the user.
;
; Preconditions: userInput, validInt on stack
; Postconditions: valid integer in validInt
; Receives: userInput string on stack
; Registers changed: eax, ecx, edx, ebp, esp, esi
;
; Returns: valid integer in validInt
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
;old ebp	|	ebp
;return@	|	ebp + 4
;ebpfrmCall	|	ebp + 8
;ret@frmCall|	ebp + 12
;plsEnter	|	ebp + 16 
;tryAgain	|	ebp + 20
;userInput	|	ebp + 24
;validInt	|	ebp + 28
;isNeg		|	ebp + 32
;plus		|	ebp + 36
;minus		|	ebp + 40
;emptyStr	|	ebp + 44
;intArray	|	ebp + 48
;arrayCount	|	ebp + 52
;--------------------------------------
	;Skip over invalid unless jumped to
	jmp		initRead

invalidEntry:	
	;Input was invalid
	;Clear the input string
	INVOKE	Str_copy, [ebp + 44], [ebp + 24]

	;Initialize validInt, isNeg, clear direction
	mov		edi, [ebp + 28]
	mov		eax, 0
	mov		[edi], eax
	mov		edi, [ebp + 32]
	mov		[edi], eax
	cld

	;Get input from user
	getString [ebp + 24], [ebp + 20]
	call	CrLf

	;skip inital prompt
	jmp		firstByte

initRead:
	;Get input from user
	getString [ebp + 24], [ebp + 16]
	call	CrLf
	
	;Initialize validInt, isNeg, clear direction
	mov		eax, 0
	mov		edi, [ebp + 28]
	mov		[edi], eax
	mov		edi, [ebp + 32]
	mov		[edi], eax
	cld

firstByte:
	;Set esi, direction, reinit isNeg
	mov		esi, [ebp + 24]
	mov		eax, 0
	mov		edi, [ebp + 32]
	mov		[edi], eax

	;Get the first byte, zero-extend
	lodsb
	movzx	eax, al

	;Check to see if it's a negative sign
	cmp		eax, 45
	jz		negFound

	;Check to see if it's a positive sign
	cmp		eax, 43
	jz		posFound

	;No sign, checking this byte in range
	sub		eax, 48
	cmp		eax, 0; lower than zero?
	jb		invalidEntry
	cmp		eax, 9;greater than 9?
	ja		invalidEntry

	;Was a digit, proceeding
	mov		edi, [ebp + 28]
	add		[edi], eax
	jmp		keepReading

negFound:
	;set boolean and continue
	mov		edi, [ebp + 32]
	mov		eax, 1
	mov		[edi], eax
	jmp		keepReading

posFound:
	;set boolean and continue
	mov		edi, [ebp + 32]
	mov		eax, 0
	mov		[edi], eax
	jmp		keepReading

keepReading:
	;Check next byte before loading
	mov		ecx, [esi + 4]
	cmp		ecx, 0
	jz		dontAdvTens

	;Multiply to next dec place
	mov		ebx, 10
	mov		edi, [ebp + 28]
	mov		eax, [edi]
	mul		ebx
	jc		invalidEntry

	;check overflow flag
	neg		eax
	and		eax, eax
	jo		invalidEntry

	;Wasn't enough to overflow, renagting
	neg		eax
	mov		[edi], eax

dontAdvTens:
	;save current number to validInt
	mov		edi, [ebp + 28]
	mov		[edi], eax

	;get the next byte, zero-extend
	lodsb
	movzx	eax, al

	;Check if null char
	cmp		eax, 0
	jz		endRead

	;checking this byte in range
	sub		eax, 48
	cmp		eax, 0; lower than zero?
	jb		invalidEntry
	cmp		eax, 9;greater than 9?
	ja		invalidEntry

	;Is a digit, adding to running total
	mov		edi, [ebp + 28]
	mov		ebx, [edi]
	add		eax, ebx
	jc		invalidEntry

	;check overflow
	neg		eax
	and		eax, eax
	jo		invalidEntry

	;didn't overflow, renegating
	neg		eax
	mov		edi, [ebp + 28]
	mov		[edi], eax

	;continue
	jmp		keepReading
	
endRead:
	;Valid int is now saved in validInt
	;now we need to check sign
	mov		edi, [ebp + 32]
	mov		eax, 1
	cmp		[edi], eax
	jz		complement
	jmp		endReadVal

complement:
	;get two's complement of validInt
	mov		edi, [ebp + 28]
	mov		eax, [edi]
	neg		eax
	mov		[edi], eax

endReadVal:
	;reset ebp, registers and leave stack for next proc
	pop		ebp
	ret
readVal ENDP

;--------------------------------------
getNumbers PROC
;
; Stores 10 valid ints from the user

; Preconditions: large stack, see stack contents below
; Postconditions: valid integer in validInt
; Receives: large stack, see stack contents below
; Registers changed: eax, ebx, ecx, edx, ebp, esp, esi
;
; Returns: valid integers in intArray
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
;plsEnter	|	ebp + 8
;tryAgain	|	ebp + 12
;userInput	|	ebp + 16
;validInt	|	ebp + 20
;isNeg		|	ebp + 24
;plus		|	ebp + 28
;minus		|	ebp + 32
;emptyStr	|	ebp + 36
;intArray	|	ebp + 40
;arrayCount	|	ebp + 44
;--------------------------------------
	;initialize counter and edi
	mov		ebx, [ebp + 44]
	mov		eax, 10
	mov		[ebx], eax

getMore:
	;Get next value
	call	readVal

	;get validInt
	mov		esi, [ebp + 20]

	;save to array and increment
	;subtract arrayCount from 10
	mov		eax, 10
	mov		edi, [ebp + 44]
	sub		eax, [edi]
	mov		ebx, 4

	;multiply by four
	mul		ebx
	mov		edi, [ebp + 40]

	;add this offset to edi
	add		edi, eax
	mov		esi, [ebp + 20]
	mov		eax, [esi]

	;save valid int
	mov		[edi], eax

	;continue to fill array
	mov		ebx, [ebp + 44]
	mov		eax, 1
	sub		[ebx], eax; sub 1 from arrayCount
	mov		eax, 0
	cmp		[ebx], eax
	jnz		getMore

	mov		ecx, 10
	mov		esi, [ebp + 40]
printEm:
	;Write the integers in array
	mov		eax, [esi]
	call	WriteInt
	add		esi, 4
	call	CrLf
	loop	printEm

	;return ebp to initial value
	pop		ebp

	ret 40
getNumbers ENDP

; (insert additional procedures here)

END main
