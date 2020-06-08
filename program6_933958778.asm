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
	displayString prompt

	;Get the input from the user
	mov		edx, inputAddress
	mov		ecx, 32; ensure always null-terminated
	call	ReadString

	;Restore the registers
	popad
ENDM

;--------------------------------------
displayString MACRO outputAddress
;   Outputs a supplied string to screen.
;
;	Preconditions: Do not use any of the 
;	general purpose registers as arguments
;
;	Receives: Address of string to output
;
;	Returns: none
;
;
;--------------------------------------

	;Save the registers
	pushad

	;Prompt for user input
	mov		edx, outputAddress
	call	WriteString

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

;Variables for clearing strings
zero		BYTE	0
thirtyThree	DWORD	33

;Variables for writing values
intOutput	BYTE	33 DUP(0)
currentInt	DWORD	?
tempString	BYTE	33 DUP(0)
digits		DWORD	?

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
	;push all registers
	pushad

	;Used for error detection
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
	push	OFFSET thirtyThree
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
	;call	getNumbers
	;call	CrLf

	call	readVal
	push	OFFSET digits
	push	OFFSET thirtyThree
	push	OFFSET tempString
	push	OFFSET currentInt
	push	OFFSET validInt
	push	OFFSET intOutput
	call	writeVal
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

	;returh registers
	popad

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

	;Saving registers
	pushad

;--------------------------------------
; CITATION: Concept learned from reference:
; https://piazza.com/class/k83uhw9nnyd2y9?cid=278
;--------------------------------------
;; STACK FRAME CONTENTS
;
;registers	|	ebp--
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
	displayString [ebp + 8]
	call	CrLf

	;Introduce programmer
	displayString [ebp + 12]
	call	CrLf

	;Specify EC option
	displayString [ebp + 16]
	call	CrLf

	;List program description
	displayString [ebp + 20]
	displayString [ebp + 24]
	displayString [ebp + 28]
	call	CrLf

	;return registers
	popad

	;Reset ebp -- esp never moved
	pop		ebp

	;Return but also clear stack
	ret		24

introduction ENDP

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

	;save registers
	pushad

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
;thirtyThree|	ebp + 48
;--------------------------------------
	;initialize counter and edi
	mov		ebx, [ebp + 44]
	mov		eax, 10
	mov		[ebx], eax

getMore:
	;push values for readVal
	push	[ebp + 48]
	push	[ebp + 44]
	push	[ebp + 40]
	push	[ebp + 36]
	push	[ebp + 32]
	push	[ebp + 28]
	push	[ebp + 24]
	push	[ebp + 20]
	push	[ebp + 16]
	push	[ebp + 12]
	push	[ebp + 8]

	;Get next value
	call	readVal

	;Clear the input string
	push	[ebp + 48]
	push	[ebp + 16]
	call	clearString

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
	push	eax
	call	writeVal
	add		esi, 4
	call	CrLf
	loop	printEm

	;return registers
	popad

	;return ebp to initial value
	pop		ebp

	ret 44
getNumbers ENDP

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

	;save registers
	pushad

;--------------------------------------
; CITATION: Concept learned from reference:
; https://piazza.com/class/k83uhw9nnyd2y9?cid=278
;--------------------------------------
;; STACK FRAME CONTENTS
;
;registers	|	ebp--
;old ebp	|	ebp
;ret@		|	ebp + 4
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
;thirtyThree|	ebp + 48
;--------------------------------------
	;Skip over invalid unless jumped to
	jmp		initRead

invalidEntry:	
	;Input was invalid
	;Clear the input string
	push	[ebp + 48]
	push	[ebp + 16]
	call	clearString

	;Initialize validInt, isNeg, clear direction
	mov		edi, [ebp + 20];validInt
	mov		eax, 0
	mov		[edi], eax
	mov		edi, [ebp + 24];isNeg
	mov		[edi], eax
	cld

	;Get input from user
	getString [ebp + 16], [ebp + 12];userInput, tryAgain
	call	CrLf

	;skip inital prompt
	jmp		firstByte

initRead:
	;Get input from user
	getString [ebp + 16], [ebp + 8];userInput, plsEnter
	call	CrLf
	
	;Initialize validInt, isNeg, clear direction
	mov		eax, 0
	mov		edi, [ebp + 20];validInt
	mov		[edi], eax
	mov		edi, [ebp + 24];isNeg
	mov		[edi], eax
	cld

firstByte:
	;Set esi, direction, reinit isNeg
	mov		esi, [ebp + 16];esi set to userInput@
	mov		eax, 0
	mov		edi, [ebp + 24];isNeg
	mov		[edi], eax;isNeg set to zero

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
	mov		edi, [ebp + 20];validInt
	add		[edi], eax;first digit stored in validInt
	jmp		keepReading

negFound:
	;set boolean and continue
	mov		edi, [ebp + 24];isNeg
	mov		eax, 1
	mov		[edi], eax;isNeg set to 1
	jmp		keepReading

posFound:
	;set boolean and continue
	mov		edi, [ebp + 24];isNeg
	mov		eax, 0
	mov		[edi], eax;isNeg set to 0
	jmp		keepReading

keepReading:
	;Check next byte before loading
	mov		cl, [esi]
	cmp		cl, 0
	jz		endRead

	;Multiply to next dec place
	mov		ebx, 10
	mov		edi, [ebp + 20];validInt
	mov		eax, [edi];validInt literal in eax
	neg		eax;doing inverse first
	imul		ebx;validInt * 10
	jo		invalidEntry
	neg		eax;back to positive

	;check overflow flag
	neg		eax;is negative
	and		eax, eax
	jo		invalidEntry

	;Wasn't enough to overflow, renagting
	neg		eax;back to positive
	;and		eax, eax
	;jo		invalidEntry
	mov		[edi], eax;storing new *10'd int in validInt

	;get the next byte, zero-extend
	lodsb
	movzx	eax, al

	;checking this byte in range
	sub		eax, 48
	cmp		eax, 0; lower than zero?
	jb		invalidEntry
	cmp		eax, 9;greater than 9?
	ja		invalidEntry

	;Is a digit, adding to running total
	mov		edi, [ebp + 20];validInt
	mov		ebx, [edi];validInt literal in ebx
	neg		ebx;going for inverse first
	and		ebx, ebx
	jo		invalidEntry
	sub		ebx, eax;subbing new digit from validInt

	;checking overflow
	jo		invalidEntry
	and		ebx, ebx
	jo		invalidEntry

	;checking sign boolean
	mov		edi, [ebp + 24]
	mov		ecx, [edi]
	cmp		ecx, 0
	jz		posOverflow
	jmp		noOverflow

posOverflow:
	;checking if its 2147483648
	sub		ebx, 1
	jo		invalidEntry
	add		ebx, 1
	jo		invalidEntry

noOverflow:
	;didn't overflow, saving
	neg		ebx;returning to pos
	jo		invalidEntry
	and		ebx, ebx
	jo		invalidEntry
	mov		edi, [ebp + 20];validInt
	mov		[edi], ebx;storing new total in validInt

	;continue
	jmp		keepReading
	
endRead:
	;Valid int is now saved in validInt
	;now we need to check sign
	mov		edi, [ebp + 24];isNeg
	mov		eax, 1
	cmp		[edi], eax;compare isNeg to 1
	jz		complement
	jmp		endReadVal

complement:
	;get two's complement of validInt
	mov		edi, [ebp + 20];validInt
	mov		eax, [edi];validInt is in eax
	neg		eax;negated integer is in eax
	jo		invalidEntry
	and		eax, eax
	jo		invalidEntry
	mov		[edi], eax;negated integer is in validInt

endReadVal:
	;reset ebp, registers and clean stack for next proc
	popad
	pop		ebp
	ret 44
readVal ENDP

;--------------------------------------
clearString PROC
;
; Blanks out the userInput string
;
; Preconditions: userInput, zero, thirtyThree on stack
; Postconditions: userInput blanked out
; Receives: userInput, zero, thirtyThree on stack
; Registers changed: eax, ebx, ecx, edx, ebp, esp, esi
;
; Returns: none
;
;--------------------------------------

	;Save ebp and set the base pointer
	push	ebp
	mov		ebp, esp

	;save registers
	pushad

;--------------------------------------
; CITATION: Concept learned from reference:
; https://piazza.com/class/k83uhw9nnyd2y9?cid=278
;--------------------------------------
;; STACK FRAME CONTENTS
;
;registers	|	ebp--
;old ebp	|	ebp
;ret@		|	ebp + 4
;userInput	|	ebp + 8
;thirtyThree|	ebp + 12
;--------------------------------------
	;init counter
	mov		esi, DWORD PTR [ebp + 12]
	mov		ecx, [esi]

	;init edi
	mov		edi, [ebp + 8]

keepBlanking:
	;blank out next spot in string
	mov		al, 0
	stosb

	;continue if needed
	loop	keepBlanking

	;reset ebp, registers and clean stack for next proc
	popad
	pop		ebp
	ret 8
clearString ENDP

;--------------------------------------
writeVal PROC
;
; Converts an integer in memory to a string of digits,
; then outputs that string to screen.
;
; Preconditions: intOutput on stack
; Postconditions: string output to screen
; Receives: intOutput on stack
; Registers changed: eax, ecx, edx, ebp, esp, esi
;
; Returns: none
;
;--------------------------------------

	;Save ebp and set the base pointer
	push	ebp
	mov		ebp, esp

	;save registers
	pushad

;--------------------------------------
; CITATION: Concept learned from reference:
; https://piazza.com/class/k83uhw9nnyd2y9?cid=278
;--------------------------------------
;; STACK FRAME CONTENTS
;
;registers	|	ebp--
;old ebp	|	ebp
;ret@		|	ebp + 4
;intOutput	|	ebp + 8 
;validInt	|	ebp + 12
;currentInt	|	ebp + 16
;tempString	|	ebp + 20
;thirtyThree|	ebp + 24
;digits		|	ebp + 28
;--------------------------------------
	;clear digits
	mov		esi, [ebp + 28]
	mov		eax, 0
	mov		[esi], eax

	;clear intOutput
	push	[ebp + 24]
	push	[ebp + 8]
	call	clearString

	;clear tempString
	push	[ebp + 24]
	push	[ebp + 20]
	call	clearString

	;copy validInt to currentInt
	mov		edi, [ebp + 16]
	mov		esi, [ebp + 12]
	mov		eax, [esi]
	mov		[edi], eax

	;init intOutput
	mov		edi, [ebp + 8]

keepDividing:
	;get currentInt, sign-extend
	mov		esi, [ebp + 16]
	mov		eax, [esi]
	cdq

	;divide by 10 move quotient to ecx and currentInt
	mov		ebx, 10
	idiv	ebx
	mov		ecx, eax
	mov		[esi], eax

	;remainder is in dl, saving to string
	mov		eax, 0
	mov		al, dl
	add		al, 48;adjust to ascii
	stosb

	;increment digits
	mov		edx, [ebp + 28]
	mov		ebx, [edx]
	add		ebx, 1
	mov		[edx], ebx

	;check if done
	cmp		ecx, 0
	jnz		keepDividing

	;Reverse string
	mov		eax, edi
	mov		edi, [ebp + 20];tempString
	mov		esi, eax;intOutput end
	sub		esi, 1

keepReversing:
	;check end of string
	mov		eax, [esi]
	cmp		eax, 0
	jz		doneReversing

	;not end of string, move from source to dest
	std;backwards from source
	lodsb
	cld;forwards from destination
	stosb

	;check to see if we're at the end
	mov		edx, [ebp + 28]
	mov		eax, [edx]
	sub		eax, 1
	mov		[edx], eax
	cmp		eax, 0
	jnz		keepReversing

doneReversing:
	;Done converting, time to display tempString
	displayString [ebp + 20]
	call	CrLf

	;used for error detection
	;mov		esi, [ebp + 12]
	;mov		eax, [esi]
	;call	WriteInt
	;call	CrLf

	;reset ebp, registers and clean stack for next proc
	popad
	pop		ebp
	ret 24
writeVal ENDP


; (insert additional procedures here)

END main
