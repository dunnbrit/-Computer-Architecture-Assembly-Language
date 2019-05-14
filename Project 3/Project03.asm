TITLE Integer Accumulator     (Project02.asm)

; Author: Brittany Dunn
; OSU email address: dunnbrit@oregonstate.edu
; Course number/section: CS 271_400
; Project Number: 03                Due Date: May 6 2018
; Description: This program will display programmer's name and program title, get the user's name and numbers between [-100,-1] , validate user's number, calculate and display the sum of negative numbers, and display an exit message before exiting. 

INCLUDE Irvine32.inc

INT_MAX = -1
INT_MIN = -100

.data

prompt_getnumber	BYTE	"Enter number: ",0
usernumber			SDWORD	?							;integer to be entered by user
invalid_input		BYTE	"Number is invalid. Please enter a number in the range [-100,-1] or a non-negative number if you are finished.",0
farewell_message	BYTE	"Goodbye, ",0
counter				DWORD	0
accumulator			SDWORD	0
display_number1		BYTE	"You entered ",0
display_number2		BYTE	" valid numbers.",0
display_sum			BYTE	"The sum of your valid numbers is ",0
display_average		BYTE	"The rounded average of your valid numbers is ",0
no_numbers_message	BYTE	"You did not enter any valid numbers.",0
numbers				DWORD	?
.code
main PROC



; getUserNumbers
	top:
	mov		edx, OFFSET prompt_getnumber
	call	WriteString
	call	ReadInt
	mov		usernumber, eax
	mov		ecx, usernumber
	cmp		ecx, INT_MIN				
	jge		test_non_neg					; if number is greater than or equal to min go to next test
	mov		edx, OFFSET invalid_input	
	call	WriteString
	call	Crlf
	jmp		top								; if not - input invalid return to top
	test_non_neg:
	cmp		ecx, INT_MAX		
	jg		display_results					; if number is greater than max go to display_results 
	inc		counter
	add		accumulator, ecx				; add number to accumulator
	jmp		top								

;displayResults
	display_results:
	mov		ebx, counter
	cmp		ebx, 0
	je		no_numbers	
	mov		edx, OFFSET display_number1		;number of valid numbers
	call	WriteString
	mov		eax,0
	add		eax,ebx
	call	WriteDec
	mov		edx, OFFSET display_number2
	call	WriteString
	call	Crlf
	mov		edx, OFFSET display_sum			;sum of numbers
	call	WriteString
	mov		eax, accumulator
	call	WriteInt
	call	Crlf
	mov		edx, OFFSET display_average		;average of numbers
	call	WriteString
	cdq
	idiv	ebx
	call	WriteInt
	jmp		farewell
; farewell
	no_numbers:
	mov		edx, OFFSET no_numbers_message
	call	WriteString
	farewell:
	call	Crlf
	mov		edx, OFFSET farewell_message
	call	WriteString
	mov		edx, OFFSET username
	call	WriteString
	call	Crlf

	exit	; exit to operating system
main ENDP

END main
