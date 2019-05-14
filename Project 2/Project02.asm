TITLE Fibonacci Numbers     (Project02.asm)

; Author: Brittany Dunn
; OSU email address: dunnbrit@oregonstate.edu
; Course number/section: CS 271_400
; Project Number: 02                Due Date: April 22 2018
; Description: This program will display programmer's name and program title, get the user's name and a number between 1-46, validate user's number, calculate and display Fibonacci numbers, and display an exit message before exiting. 

INCLUDE Irvine32.inc

FIB_MAX = 46
FIB_MIN = 1

.data
intro_program		BYTE	"Fibonacci Numbers",0
intro_programmer	BYTE	" by Brittany Dunn",0
prompt_name			BYTE	"What is your name? ",0
username			BYTE	33 DUP(0)					;string to be entered by user
greet_user			BYTE	"Hello, ",0
prompt_number		BYTE	"Please enter a number of Fibonacci terms to be displayed.",0
prompt_range		BYTE	"The number must be an integer in the range of [1..46]",0
prompt_getnumber	BYTE	"How many Fibonacci terms would you like? ",0
usernumber			DWORD	?							;integer to be entered by user
invalid_input		BYTE	"Number is not in range. Please entr a number in the range of [1..46] ",0
fibnumber			DWORD	1
display_spaces		BYTE	"     ",0
farewell_message	BYTE	"Goodbye, ",0
counter				DWORD	1

.code
main PROC

; introduction
	mov		edx, OFFSET intro_program
	call	WriteString
	mov		edx, OFFSET intro_programmer
	call	WriteString
	call	Crlf
	mov		edx, OFFSET prompt_name
	call	WriteString
	mov		edx, OFFSET username
	mov		ecx, 32
	call	ReadString
	mov		edx, OFFSET greet_user
	call	WriteString
	mov		edx, OFFSET username
	call	WriteString
	call	Crlf

; userInstructions
	mov		edx, OFFSET prompt_number
	call	WriteString
	call	Crlf
	mov		edx, OFFSET prompt_range
	call	WriteString
	call	Crlf

; getUserData
	mov		edx, OFFSET prompt_getnumber
	call	WriteString
	top:
	call	ReadInt
	mov		usernumber, eax
	mov		ecx, usernumber
	cmp		ecx, FIB_MAX				
	jle		test_min						; if number is less than or equal to max go to next test
	mov		edx, OFFSET invalid_input	
	call	WriteString
	jmp		top								; if not - input invalid return to top
	test_min:
	cmp		ecx, FIB_MIN					
	jge		inputValid						; if number is greater than or equal to min go to inputValid 
	mov		edx, OFFSET invalid_input
	call	WriteString
	jmp		top								; if not - input invalid return to top

; displayFibs
	inputValid:
	; intialize loop
	mov		ebx, 0
	mov		eax, 1
	mov		edx, OFFSET display_spaces
	call	WriteString
	mov		ebp, 5
	call	WriteDec
	cmp		ecx, FIB_MIN
	je		endblock						; if user only wanted 1 term go to end
	mov		edx, OFFSET display_spaces
	call	WriteString
	dec		ecx
	inc		counter
	mov		eax, 1
	call	WriteDec
	mov		edx, OFFSET display_spaces
	call	WriteString
	cmp		ecx, FIB_MIN
	je		endblock						; if user only wanted 2 terms go to end
	dec		ecx
	inc		counter

	fib_loop:
	add		eax, fibnumber
	mov		ebx, eax	
	call	WriteDec
	mov		edx, OFFSET display_spaces
	cmp		counter,ebp
	jne		falseBlock						; create new line for every 5 terms
	call	Crlf
	add		ebp, 5
	falseBlock:
	inc		counter
	call	WriteString
	mov		eax, fibnumber
	mov		fibnumber, ebx
	loop	fib_loop

; farewell
	endBlock:
	call	Crlf
	mov		edx, OFFSET farewell_message
	call	WriteString
	mov		edx, OFFSET username
	call	WriteString
	call	Crlf

	exit	; exit to operating system
main ENDP

END main
