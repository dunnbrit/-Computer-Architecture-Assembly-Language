TITLE Designing low-level I/O procedures     (Project06a.asm)

; Author: Brittany Dunn
; OSU email address: dunnbrit@oregonstate.edu
; Course number/section:CS271_400
; Project Number: 06a                 Due Date: June 10 2018
; Description: This program will display programmer's name and program title, prompt the user for 10 integers and validate, store the integers in an array, and calculate and display the integers, their sum, and their average.

INCLUDE Irvine32.inc


getString MACRO userPrompt, userInput
	push			ecx									;;save register
	push			edx									;;save register
	displayString	userPrompt							;;use macro to display prompt
	mov				edx,userInput						;;address of where to store input
	mov				ecx,MAX_USER_STRING					;;max size of input
	call			ReadString							;;store string in input
	pop				edx									;;restore register
	pop				ecx									;;restore register
ENDM

displayString MACRO output			
	push	edx											;;save register
	mov		edx,output									;;address of output
	call	WriteString									;;display output
	pop		edx											;;restore register
ENDM

MAX_USER_STRING = 100									;global variable for max size of user's input string

.data

intro_program		BYTE	"Designing low-level I/o procedures ",0
intro_programmer	BYTE	"by Brittany Dunn",0
description_1		BYTE	"Please enter 10 unsigned decimal integers. (Each number must be small enough to fit in a 32 bit register)",0
description_2		BYTE	"This program will then display a list of the entered integers, their sum, and their average.",0
integers			DWORD	0							;numeric form of string inputed by user
list				DWORD	10 DUP(?)					;array to hold user's 10 integers in numeric form
inputString			BYTE	MAX_USER_STRING DUP(?)		;array to hold string from user to be converted into numeric form
error_message		BYTE	"Error: You did not enter an unsigned number or your number was too large. Please try again. ",0
prompt				BYTE	"Please enter an unsigned number: ",0
input_size			DWORD	LENGTHOF inputString
conversionString	BYTE	MAX_USER_STRING DUP(?)		;array to hold validated digits
spaces				BYTE	"  ",0
display_prompt		BYTE	"You entered the following numbers: ",0
digitString			BYTE	MAX_USER_STRING DUP(?)		;array to hold string converted from numeric form to digits
reverseString		BYTE	MAX_USER_STRING DUP(?)		;array to hold digit string in reverse
display_sum			BYTE	"The sum is:",0
display_average		BYTE	"The average is",0
digit_character		BYTE	?
int_loop_counter	DWORD	10							;varible to control loops in WriteVal
display_counter		DWORD	1							;varible to control loops in WriteVal
sum					DWORD	?							;varible to store sum
average				DWORD	?							;varible to store average
display_prompt_sum	BYTE	"The sum is: ",0
display_prompt_avg	BYTE	"The average is: ",0

.code

main PROC

	push			OFFSET intro_program
	push			OFFSET intro_programmer
	push			OFFSET description_1
	push			OFFSET description_2 
	call			introduction						;display introduction


	mov				ecx,10								;set loop counter to 10 for integers
	mov				esi,OFFSET list								
get_integers:
	push			esi
	push			OFFSET error_message
	push			OFFSET prompt
	push			OFFSET conversionString
	push			input_size
	push			OFFSET inputString
	push			OFFSET integers
	call			readVal								;get integer from user,validate, and store in numeric form
	add				esi,4								;move to next array element in list
	loop			get_integers

	
	push			int_loop_counter
	push			OFFSET spaces
	push			OFFSET display_prompt
	push			OFFSET digit_character
	push			OFFSET list
	push			OFFSET digitString
	push			OFFSET reverseString
	call			writeVal							;convert numeric list to digits and display

	push			OFFSET sum
	push			OFFSET average
	push			OFFSET list
	call			calcSum_Average						;calculate the sum and average

	push			display_counter
	push			OFFSET spaces
	push			OFFSET display_prompt_sum
	push			OFFSET digit_character
	push			OFFSET sum
	push			OFFSET digitString
	push			OFFSET reverseString
	call			writeVal							;display sum

	push			display_counter
	push			OFFSET spaces
	push			OFFSET display_prompt_avg
	push			OFFSET digit_character
	push			OFFSET average
	push			OFFSET digitString
	push			OFFSET reverseString
	call			writeVal							;display average



	exit	; exit to operating system
main ENDP

;Procedure to display program name, programmer's name, breif instructions and description.
;recieves: address of intro_program,intro_programmer, description_1, description_2
;returns: none
;preconditions: none
;registers changed(registers are all saved then restored): (macro-edx)

introduction PROC
	push			ebp
	mov				ebp,esp
	displayString	[ebp+20]							;display intro_program
	displayString	[ebp+16]							;display intro_programmer
	call			Crlf		
	call			Crlf
	displayString	[ebp+12]							;display description 1
	call			Crlf	
	displayString	[ebp+8]								;display description 2
	call			Crlf
	call			Crlf
	pop				ebp
	ret				16
introduction ENDP


;Procedure to get a string of digits from user and validate the characters are digits with a sub procedure to convert the digits into numeric form
;recieves: addresses of error_message, prompt message, inputString array, conversionString array, integers varible,list array ; value of input_size
;returns: numberic value of digit string stored in list array element
;preconditions: strings must contain only digits which fit into a 32 bit register
;registers changed(registers are all saved then restored): esi,edi,ecx,ebx,edx,eax(macro-edx,ecx)

ReadVal PROC
	pushad												;save registers
	push			ebp
	mov				ebp,esp
	jmp				begin
	error:
		displayString	[ebp+60]						;display error_message
		call			Crlf
	begin:
		mov				esi,[ebp+44]					;address of inputString
		mov				edi,[ebp+52]					;address of conversionString
		getString		[ebp+56],esi					;get string from user using macro, store in inputString array						
		mov				ecx,[ebp+48]					;set counter to length of inputString
		mov				ebx,0							;use eax as a counter for the number of digits in the array
		cld												;clear direction flag so it increments
		clc												;clear carry flag for unsigned integer overflow
		continue:
			lodsb										;load byte into al register
			cmp			al,0							;compare to empty element(0)
			je			end_string						;if empty exit loop
			cmp			al,48							;compare to smallest digit 0
			jl			error							;if less than then not a digit go to error
			cmp			al,57							;compare to largest digit 9
			jg			error							;if greater than then not a digit go to error
			stosb										;store digit in conversionString	
			inc			ebx								;increment digit counter
			loop		continue						;go to next byte
		end_string:
			mov			esi,[ebp+52]					;move conversionString to esi
			mov			ecx,ebx							;set counter to digit counter			
			mov			edi,[ebp+40]					;address of integers
			mov			eax,0							;set eax to 0
			mov			[edi],eax						;set x (integers) to 0
		convert_string:									;equation: (10 * x) + (str[k] - 48)
			mov			eax,0							;clear eax
			lodsb										;load byte of conversionString into eax(al): (str[k])
			sub			eax,48							;(str[k] - 48)
			mov			ebx,eax							;move to edx so eax can be used for multiplication in equation (edx = (str[k]-48))	
			mov			edx,[edi]						;value of integers (ebx = x)
			mov			eax,edx							;store integers in eax (eax = x)
			mov			edx,10							;store 10 for multiplication step (ebx = 10)
			mul			edx								;eax = 10 * x
			add			eax,ebx							;eax = (10 * x) + (str[k] - 48)
			jc			error							;if carry flag was set then digits did not fit in 32 bit register go to error
			mov			[edi],eax						;move result into integers (integers = x = (10 * x) + (str[k] - 48) )					
			loop		convert_string					;loop for each digit			
			mov			edi,[ebp+64]					;address of list
			mov			[edi],eax						;move integers into list element
	pop			ebp				
	popad												;restore registers
	ret			28
ReadVal ENDP


;Procedure to convert numeric value to a string of digits and then display the string
;recieves:address of spaces message,prompt message, list array/sum variable/average variable, digitString array, reverseString array;value of counter variable
;returns: stores numeric value as digits in digitString and digitString reversed in reverseString 
;preconditions: Sum is assumed to fit in a 32 bit register; strings contain only digits which fit into a 32 bit register
;registers changed(registers are all saved then restored): esi,edi,ecx,ebx,edx,eax(macro-edx,ecx)
WriteVal PROC
	pushad												;save registers
	push			ebp
	mov				ebp,esp
	displayString	[ebp+56]							;display prompt
	mov				ecx,[ebp+64]						;set counter for loop1
	mov				esi,[ebp+48]						;address of list[i]
	loop1:
		push			ecx								;save loop1 counter
		mov				eax,[esi]						;numeric value stored in list[i]		
		push			esi								;save esi: list[i]
		mov				edi,[ebp+44]					;address of digitString
		mov				ebx,10							;for division
		mov				ecx,0							;set counter to 0
	get_digits:	
		mov				edx,0							;clear for division	
		cmp				eax,10							;check if numeric value is less than 10
		jl				store_digit						;if so store the digit as is
		div				ebx								;if not, divide numberic value by 10	
		add				edx,48							;convert to ASCII
		mov				[edi],edx						;move digit to digitString[i]
		inc				ecx								;inc counter
		inc				edi								;next element to store in diitString
		jmp				get_digits						;get the next digit
	store_digit:
		add				eax,48							;convert to ASCII
		mov				[edi],eax						;move digit to digitString[i]
		inc				ecx								;inc counter
	mov				esi,[ebp+44]						;address of digitString
	mov				edi, [ebp+40]						;address of reverseString
	add				esi,ecx								;start at end of digitString
	dec				esi									;dec because of 0 byte
	std													;set direction flag to dec
	reverse:
		lodsb											;load byte of digitString
		mov				[edi],al						;move byte into reverseString[i]
		inc				edi								;next element of reverseString
		loop			reverse							;loop for each digit in digitString
		mov				al,0							;store 0 for last byte
		mov				[edi],al						;add last byte to indicate end of string
	displayString	[ebp+40]							;display reverseString
	displayString	[ebp+60]							;display spaces
	pop				esi									;restore register (list[i])
	add				esi,4								;move to next element
	pop				ecx									;restore loop1 counter
	loop			loop1								;loop as necessary
	call		Crlf
	popad												;restore registers
	pop			ebp
	ret			24
WriteVal ENDP

;Procedure to calculate the sum and average of numeric values of all 10 numbers
;recieves:address of list array, sum variable, average variable
;returns: numeric sum and average stored in sum and average variables
;preconditions: Sum is assumed to fit in a 32 bit register; strings contain only digits which fit into a 32 bit register
;registers changed(registers are all saved then restored): esi,edi,ecx,ebx,edx,eax(macro-edx,ecx)
calcSum_Average PROC
	pushad												;save registers
	push			ebp
	mov				ebp,esp
	mov				esi,[ebp+40]						;address of list
	mov				edi,[ebp+48]						;address of sum
	mov				ecx,10								;set counter to 10
	sum_numbers:
		mov				eax,[esi]						;numeric value of list[i]
		mov				ebx,[edi]						;value of sum
		add				eax,ebx							;sum + numeric value of list[i]
		mov				[edi],eax						;store in sum variable
		add				esi,4							;next element in list
		loop			sum_numbers						;loop once for each number
	mov				edx,0								;clear for division
	mov				ebx,10								;number of numbers
	mov				eax,[edi]							;value of sum
	div				ebx									;sum/10
	mov				esi,[ebp+44]						;address of average
	mov				[esi],eax							;store average in variable
	popad												;restore registers
	pop			ebp
	ret			12
calcSum_Average ENDP




END main

