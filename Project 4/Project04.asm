TITLE Composite Numbers     (Project04.asm)

; Author: Brittany Dunn
; OSU email address: dunnbrit@oregonstate.edu
; Course number/section:CS271_400
; Project Number: 04                 Due Date: May 13 2018
; Description: This program will display programmer's name and program title, gets the user's number [1..400], validates the number, calculate and display all of the composite numbers up to and including the nth composite. 

INCLUDE Irvine32.inc

INT_MAX = 400
INT_MIN = 1

.data

intro_program		BYTE	"Compsite Numbers ",0
intro_programmer	BYTE	"by Brittany Dunn",0
prompt_instruct		BYTE	"How many composite numbers would you like to see?",0
prompt_number		BYTE	"Please enter a number in the range [1..400]",0
n					SDWORD	?			;integer to be entered by user
prompt_getnumber	BYTE	"Enter number: ",0
invalid_input		BYTE	"Number is invalid. Please enter a number in the range [1..400].",0
number				DWORD	4
spaces				BYTE	"   ",0
counter				DWORD	0
farewell_message	BYTE	"Goodbye! ",0

.code
main PROC
	call	introduction
	call	getUserData
	call	showComposites
	call	farewell
	exit	; exit to operating system
main ENDP


;Procedure to display program name and programmer's name
;recieves: none
;returns: none
;preconditions: none
;registers changed: edx
introduction PROC					
	;display program name and programmer
	mov		edx, OFFSET intro_program
	call	WriteString
	mov		edx, OFFSET intro_programmer
	call	WriteString
	call	CrLf
	;display instructions
	call	Crlf
	mov		edx, OFFSET prompt_instruct
	call	WriteString
	call	Crlf
	mov		edx, OFFSET prompt_number
	call	WriteString
	call	Crlf
	ret
introduction ENDP


;Procedure to get the number of composites to be displayed
;recieves: none
;returns: user input for global varible n
;preconditions: none
;registers changed: eax
getUserData PROC
	call	Crlf
	mov		edx, OFFSET prompt_getnumber
	call	WriteString
	call	ReadInt
	mov		n, eax
	call	validate

		;Procedure to validate user's choice is in range
		;recieves: global varible n
		;returns: validated input for global varible n
		;precondtions: none
		;registers changed: eax
		validate PROC
			jmp		test_min
		wrong:
			mov		edx, OFFSET prompt_getnumber
			call	WriteString
			call	ReadInt
			mov		n, eax
		test_min:
			cmp		n, INT_MIN				
			jge		test_max					; if number is greater than or equal to min go to next test
			mov		edx, OFFSET invalid_input	
			call	WriteString
			call	Crlf
			jmp		wrong						; if not - input invalid return to top
		test_max:
			cmp		n, INT_MAX		
			jle		last						; if number is less than or equal to max to last
			mov		edx, OFFSET invalid_input	
			call	WriteString
			call	Crlf
			jmp		wrong						; if not - input invalid return to top
		last:
			ret
		validate ENDP

	ret
getUserData ENDP

;Procedure to display n composite numbers
;recieves: global varible n
;returns: none
;preconditions: 1<= n <= 400
;registers changed: eax,edx
showComposites PROC
		call	Crlf
		mov		ecx, n					;set loop counter to n
	show_numbers:
		call	isComposite				;get a composite number
		mov		eax, number
		call	WriteDec				;display number
		mov		edx, OFFSET spaces		;add space
		call	WriteString
		inc		number
		inc		counter
		cmp		counter, 10				;after 10 numbers, go to new line
		jne		continue
		call	Crlf
		mov		counter,0				;reset counter to 0 after new line created
		continue:
		loop	show_numbers			;loop until displayed n composite numbers
		

				;Procedure checks if a number is composite
				;Recieves: global varible number
				;returns: global varible number
				;preconditions: none
				;registers changed: during proc edx,ebx, and eax but registers are saved before and restored after proc
				isComposite PROC
				pushad						;save registers
				try_again:					;try next number
					mov	ebx, 2				;start division at 2
					mov	ecx, number			;set counter
					dec ecx					;to not divide by 1
					dec ecx					;to not divide by itself
				numbers:
					mov		edx,0
					mov		eax, number
					div		ebx
					cmp		edx,0
					je		leave_loop		;if remainder is 0 then composite, exit loop
					inc		ebx				;else see if it is divisible by next number
					loop	numbers			;loop through 2 to current number -1
					inc		number			;number was prime, check next number
					jmp		try_again		;current number was prime, try next number
				leave_loop:
					popad					;restore registers
					ret
				isComposite	ENDP

		ret 
showComposites ENDP


;Procedure displays farewell message
;recieves: none
;returns: none
;preconditions: none
;registers changed: EDX
farewell PROC
	call	Crlf
	call	Crlf
	mov		edx, OFFSET farewell_message
	call	WriteString
	call	Crlf
	call	Crlf
	ret
farewell ENDP

END main
