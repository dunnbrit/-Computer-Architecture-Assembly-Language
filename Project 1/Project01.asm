TITLE Elementary Arithmetic     (Project01.asm)

; Author: Brittany Dunn
; OSU email address: dunnbrit@oregonstate.edu
; Course number/section:CS 271_400
; Project Number:01                 Due Date: 04/15/2018
; Description:This program will display programmer's name and program title,get two numbers from user, and calculate the sum,difference,product,quotient and remainder.

INCLUDE Irvine32.inc

.data
intro_program		BYTE	"Elementary Arithmetic ",0
intro_programmer	BYTE	"by Brittany Dunn",0
instruction			BYTE	"This program will show you the sum, difference, product, quotient, and remainder of 2 numbers you enter.",0
prompt_1			BYTE	"Please enter the first number: ",0
firstNumber			DWORD	?	;integer to be entered by user
prompt_2			BYTE	"Please enter the second number: ",0
secondNumber		DWORD	?	;integer to be entered by user
sum_display			BYTE	" + ",0
difference_display	BYTE	" - ",0
product_display		BYTE	" x ",0
quotient_display	BYTE	" / ",0
remainder_display	BYTE	" remainder ",0
equal_display		BYTE	" = ",0
goodbye				BYTE	"Goodbye!",0
sum					DWORD	?
difference			DWORD	?
product				DWORD	?
quotient			DWORD	?					
remainder			DWORD	?
less_than			BYTE	"The second number must be less than the first number.",0
extra_credit2		BYTE	"**EC2: Program verifies second number is less than the first number",0

.code
main PROC

; introduction
	mov		edx, OFFSET intro_program
	call	WriteString
	mov		edx, OFFSET intro_programmer
	call	WriteString
	call	CrLf
	mov		edx, OFFSET extra_credit2
	call	WriteString
	call	Crlf
	mov		edx, OFFSET instruction
	call	WriteString
	call	CrLf
; get the data
	; get first number
	mov		edx, OFFSET prompt_1
	call	WriteString
	call	ReadInt
	mov		firstNumber, eax

	; get second number
	mov		edx, OFFSET prompt_2
	call	WriteString
	call	ReadInt
	mov		secondNumber, eax
; make surefirst number is less than second number	
	mov		eax, firstNumber
	cmp		eax, secondNumber
	jl		true1
	jmp		theEnd
true1:
	mov		edx, OFFSET less_than
	call	WriteString
	call	Crlf
	mov		edx, OFFSET goodbye
	call	WriteString
	call	Crlf
	exit
theEnd:
		
; calculate the required values
	; calculate sum
	mov		eax, firstNumber
	add		eax, secondNumber
	mov		sum, eax
	
	; calculate difference
	mov		eax, firstNumber
	sub		eax, secondNumber
	mov		difference, eax
	
	; calculate product
	mov		eax, firstNumber
	mov		ebx, secondNumber
	mul		ebx
	mov		product, eax

	; calculate quotient and remainder
	mov		eax, firstNumber
	cdq
	mov		ebx, secondNumber
	div		ebx
	mov		quotient, eax
	mov		remainder, edx

; display the results
	; display sum
	mov		eax, firstNumber
	call	WriteDec
	mov		edx, OFFSET sum_display
	call	WriteString
	mov		eax, secondNumber
	call	WriteDec
	mov		edx, OFFSET equal_display
	call	WriteString
	mov		eax, sum
	call	WriteDec
	call	CrLf
	
	; display difference
	mov		eax, firstNumber
	call	WriteDec
	mov		edx, OFFSET difference_display
	call	WriteString
	mov		eax, secondNumber
	call	WriteDec
	mov		edx, OFFSET equal_display
	call	WriteString
	mov		eax, difference
	call	WriteDec
	call	CrLf
	
	; display product
	mov		eax, firstNumber
	call	WriteDec
	mov		edx, OFFSET product_display
	call	WriteString
	mov		eax, secondNumber
	call	WriteDec
	mov		edx, OFFSET equal_display
	call	WriteString
	mov		eax, product
	call	WriteDec
	call	CrLf
	
	; display quotient and remainder
	mov		eax, firstNumber
	call	WriteDec
	mov		edx, OFFSET quotient_display
	call	WriteString
	mov		eax, secondNumber
	call	WriteDec
	mov		edx, OFFSET equal_display
	call	WriteString
	mov		eax, quotient
	call	WriteDec
	mov		edx, OFFSET remainder_display
	call	WriteString
	mov		eax, remainder
	call	WriteDec
	call	CrLf

; say goodbye
	mov		edx, OFFSET goodbye
	call	WriteString
	call	CrLf

	exit	; exit to operating system
main ENDP

END main
